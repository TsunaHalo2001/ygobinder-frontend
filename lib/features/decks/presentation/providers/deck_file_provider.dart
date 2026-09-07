import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/providers/currency_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/decks/data/repositories/deck_sync_repository.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'deck_file_provider.g.dart';

class DeckState {
  final String content;
  final String? name;
  final bool _isQuoteDeck;

  bool get isQuoteDeck => _isQuoteDeck;

  DeckState({
    required this.content,
    this.name,
    bool? isQuoteDeck,
  }) : _isQuoteDeck = isQuoteDeck ?? false;
}

@riverpod
class DeckFileContent extends _$DeckFileContent {
  StreamSubscription? _intentSubscription;

  @override
  DeckState build() {
    ref.onDispose(() => _intentSubscription?.cancel());
    _initIntentListener();
    return DeckState(content: '');
  }

  void _initIntentListener() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    // For sharing files coming from outside the app while the app is in the memory
    _intentSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  Future<void> _handleSharedFile(String path) async {
    await loadFromPath(path);
  }

  Future<void> loadFromPath(String path) async {
    try {
      final rawPath = path.trim();
      final parsedUri = Uri.tryParse(rawPath);
      final isContentUri = parsedUri != null && parsedUri.scheme == 'content';

      String filePath = rawPath;
      if (rawPath.startsWith('file://')) {
        filePath = Uri.parse(rawPath).toFilePath();
      }

      if (isContentUri) {
        final media = await ReceiveSharingIntent.instance.getInitialMedia();
        if (media.isNotEmpty) {
          final sharedPath = media.first.path;
          if (sharedPath.isNotEmpty) {
            filePath = sharedPath;
          }
        }
      }

      if (!filePath.toLowerCase().endsWith('.ydk')) {
        state = DeckState(content: "Error: Only .ydk files are supported.");
        return;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        state = DeckState(content: "Error: File does not exist at $filePath");
        return;
      }

      final content = await file.readAsString();
      state = DeckState(
        content: content,
        name: filePath.split('/').last.replaceAll('.ydk', ''),
      );
    } catch (e) {
      state = DeckState(content: "Error reading file: $e\nPath: $path");
    }
  }

  void reset() {
    state = DeckState(content: '');
  }

  void createNewDeck([String name = 'New Deck']) {
    final buffer = StringBuffer();
    buffer.writeln('#main');
    buffer.writeln('#extra');
    buffer.writeln('!side');
    state = DeckState(
      content: buffer.toString(),
      name: name,
    );
  }

  Map<String, List<int>> parseYdk() {
    final Map<String, List<int>> categorizedCards = {
      'main': [],
      'extra': [],
      'side': [],
    };

    if (state.content.isEmpty) return categorizedCards;

    final lines = state.content.split('\n');
    String currentCategory = '';

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed == '#main') {
        currentCategory = 'main';
      } else if (trimmed == '#extra') {
        currentCategory = 'extra';
      } else if (trimmed == '!side') {
        currentCategory = 'side';
      } else {
        final cardId = int.tryParse(trimmed);
        if (cardId != null && currentCategory.isNotEmpty) {
          categorizedCards[currentCategory]?.add(cardId);
        }
      }
    }

    return categorizedCards;
  }

  Future<void> loadQuoteDeck() async {
    final db = ref.read(databaseProvider);
    final quoteItems = await (db.select(db.collectionItems)..where((t) => t.collectionNumber.equals(0))).get();

    final mainCards = <int>[];
    final extraCards = <int>[];

    final cardIds = quoteItems.map((i) => i.cardId).toSet().toList();
    if (cardIds.isNotEmpty) {
      final driftCards = await (db.select(db.cards)..where((t) => t.id.isIn(cardIds))).get();
      final cardTypeMap = {for (final c in driftCards) c.id: c.type.toLowerCase()};

      for (final item in quoteItems) {
        final cardType = cardTypeMap[item.cardId] ?? '';
        final isExtra = cardType.contains('fusion') ||
            cardType.contains('synchro') ||
            cardType.contains('xyz') ||
            cardType.contains('link');

        for (var i = 0; i < item.quantity; i++) {
          if (isExtra) {
            extraCards.add(item.cardId);
          } else {
            mainCards.add(item.cardId);
          }
        }
      }
    }

    final buffer = StringBuffer();
    buffer.writeln('#main');
    for (final id in mainCards) {
      buffer.writeln(id);
    }
    buffer.writeln('#extra');
    for (final id in extraCards) {
      buffer.writeln(id);
    }
    buffer.writeln('!side');

    state = DeckState(
      content: buffer.toString(),
      name: 'Quoted Cards (#0)',
      isQuoteDeck: true,
    );
  }

  void addCardToCategory(int cardId, String category) {
    if (state.isQuoteDeck) return;
    final categorized = parseYdk();
    categorized[category]?.add(cardId);
    _updateContentFromCategorized(categorized);
  }

  void removeOneCopyFromCategory(int cardId, String category) {
    if (state.isQuoteDeck) return;
    final categorized = parseYdk();
    categorized[category]?.remove(cardId);
    _updateContentFromCategorized(categorized);
  }

  void removeOneCopyFromAnyCategory(int cardId) {
    if (state.isQuoteDeck) return;
    final categorized = parseYdk();
    if (categorized['main']?.contains(cardId) ?? false) {
      categorized['main']?.remove(cardId);
    } else if (categorized['extra']?.contains(cardId) ?? false) {
      categorized['extra']?.remove(cardId);
    } else if (categorized['side']?.contains(cardId) ?? false) {
      categorized['side']?.remove(cardId);
    }
    _updateContentFromCategorized(categorized);
  }

  void _updateContentFromCategorized(Map<String, List<int>> categorized) {
    final buffer = StringBuffer();
    buffer.writeln('#main');
    for (final id in categorized['main'] ?? []) {
      buffer.writeln(id);
    }
    buffer.writeln('#extra');
    for (final id in categorized['extra'] ?? []) {
      buffer.writeln(id);
    }
    buffer.writeln('!side');
    for (final id in categorized['side'] ?? []) {
      buffer.writeln(id);
    }
    state = DeckState(content: buffer.toString(), name: state.name, isQuoteDeck: state.isQuoteDeck);
  }

  Future<void> saveToDatabase(String name) async {
    final categorizedCards = parseYdk();
    final db = ref.read(databaseProvider);
    
    final syncId = const Uuid().v4();
    final deckId = await db.saveDeck(name, categorizedCards, syncId: syncId);
    
    // Sync to cloud (Non-blocking and safe)
    _syncDeckToCloud(deckId);

    state = DeckState(content: state.content, name: name, isQuoteDeck: false);
  }

  Future<void> _syncDeckToCloud(int deckId) async {
    try {
      final db = ref.read(databaseProvider);
      final syncRepo = ref.read(deckSyncRepositoryProvider);
      final deck = await db.getDeckById(deckId);
      final cards = await db.getDeckCards(deckId);
      if (deck != null) {
        await syncRepo.syncDeck(deck, cards);
      }
    } catch (e) {
      debugPrint('Cloud sync failed: $e');
    }
  }

  Future<void> loadFromDatabase(int deckId) async {
    final db = ref.read(databaseProvider);
    final deck = await db.getDeckById(deckId);
    final cards = await db.getDeckCards(deckId);
    
    final main = cards.where((c) => c.category == 'main').map((c) => c.cardId);
    final extra = cards.where((c) => c.category == 'extra').map((c) => c.cardId);
    final side = cards.where((c) => c.category == 'side').map((c) => c.cardId);

    final buffer = StringBuffer();
    buffer.writeln('#main');
    for (final id in main) {
      buffer.writeln(id);
    }
    buffer.writeln('#extra');
    for (final id in extra) {
      buffer.writeln(id);
    }
    buffer.writeln('!side');
    for (final id in side) {
      buffer.writeln(id);
    }

    state = DeckState(content: buffer.toString(), name: deck?.name, isQuoteDeck: false);
  }

  Future<void> deleteDeck(int deckId) async {
    final db = ref.read(databaseProvider);
    final syncRepo = ref.read(deckSyncRepositoryProvider);
    
    final deck = await db.getDeckById(deckId);
    if (deck != null && deck.syncId != null) {
      // Don't await cloud removal to ensure local deletion is fast
      syncRepo.removeDeck(deck.syncId!).catchError((e) {
        debugPrint('Cloud removal failed: $e');
      });
    }

    await db.deleteDeck(deckId);
    reset();
  }

  Future<void> shareDeck() async {
    if (state.content.isEmpty) return;

    final fileName = state.name != null && state.name!.isNotEmpty ? '${state.name}.ydk' : 'deck.ydk';

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Mobile sharing
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, fileName));
      await tempFile.writeAsString(state.content);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        subject: 'YGO Deck: ${state.name ?? "deck"}',
      );
    } else {
      // Desktop/Web fallback: Save As dialog
      await FilePicker.saveFile(
        dialogTitle: 'Export Deck',
        fileName: fileName,
        type: FileType.any,
        bytes: Uint8List.fromList(utf8.encode(state.content)),
      );
    }
  }

  Future<void> shareQuoteEstimate(CurrencyInfo currencyInfo) async {
    final db = ref.read(databaseProvider);
    final quoteItems = await (db.select(db.collectionItems)..where((t) => t.collectionNumber.equals(0))).get();

    if (quoteItems.isEmpty) return;

    final cardIds = quoteItems.map((i) => i.cardId).toSet().toList();
    final driftCards = await (db.select(db.cards)..where((t) => t.id.isIn(cardIds))).get();
    final cardNameById = {for (final c in driftCards) c.id: c.name};

    final livePricesList = await (db.select(db.setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
    final livePricesBySetCode = <String, double>{};
    for (final sp in livePricesList) {
      final p = sp.marketPrice ?? sp.lowPrice ?? 0.0;
      if (sp.setCode != null && sp.setCode!.isNotEmpty) {
        livePricesBySetCode['${sp.cardId}_${sp.setCode!.toUpperCase()}_${sp.printing.trim().toLowerCase()}'] = p;
        livePricesBySetCode['${sp.cardId}_${sp.setCode!.toUpperCase()}'] = p;
      }
    }

    final globalPricesList = await (db.select(db.cardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
    final globalPriceById = <int, double>{};
    for (final p in globalPricesList) {
      globalPriceById[p.cardId] = p.tcgPlayerPrice ?? p.cardMarketPrice ?? 0.0;
    }

    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final dateStr = '$day/$month/$year $hour:$minute';

    final buffer = StringBuffer();
    buffer.writeln('================================================================================');
    buffer.writeln('                        YGOBINDER - QUOTE ESTIMATE');
    buffer.writeln('================================================================================');
    buffer.writeln('Date Generated : $dateStr');
    buffer.writeln('Currency       : ${currencyInfo.code}');
    buffer.writeln('Source         : Quote Collection (#0)');
    buffer.writeln('--------------------------------------------------------------------------------\n');

    double totalEstimateUsd = 0.0;
    int totalCardCount = 0;

    buffer.writeln('#   QTY   CARD NAME                          SET CODE    RARITY                     UNIT PRICE    SUBTOTAL');
    buffer.writeln('--------------------------------------------------------------------------------------------------------------');

    for (var i = 0; i < quoteItems.length; i++) {
      final item = quoteItems[i];
      final cardName = cardNameById[item.cardId] ?? 'Unknown Card';
      final setCode = item.setCode;
      final rarity = item.rarity;
      final qty = item.quantity;

      final key = '${item.cardId}_${setCode.trim().toUpperCase()}_${rarity.trim().toLowerCase()}';
      final fallbackKey = '${item.cardId}_${setCode.trim().toUpperCase()}';

      double unitPriceUsd = livePricesBySetCode[key] ??
          livePricesBySetCode[fallbackKey] ??
          (item.priceAtPurchase ?? 0.0);

      if (unitPriceUsd <= 0.0) {
        unitPriceUsd = globalPriceById[item.cardId] ?? 0.0;
      }

      final subtotalUsd = unitPriceUsd * qty;
      totalEstimateUsd += subtotalUsd;
      totalCardCount += qty;

      final padNum = (i + 1).toString().padRight(3);
      final padQty = '${qty}x'.padRight(5);
      final padName = (cardName.length > 33 ? '${cardName.substring(0, 30)}...' : cardName).padRight(33);
      final padCode = setCode.padRight(11);
      final padRarity = (rarity.length > 25 ? '${rarity.substring(0, 22)}...' : rarity).padRight(25);
      final padUnitPrice = currencyInfo.formatPrice(unitPriceUsd).padRight(13);
      final padSubtotal = currencyInfo.formatPrice(subtotalUsd);

      buffer.writeln('$padNum $padQty $padName $padCode $padRarity $padUnitPrice $padSubtotal');
    }

    final totalFormatted = currencyInfo.formatPrice(totalEstimateUsd);

    buffer.writeln('--------------------------------------------------------------------------------------------------------------');
    buffer.writeln('TOTAL QUOTED CARDS : $totalCardCount cards');
    buffer.writeln('TOTAL ESTIMATE     : $totalFormatted');
    buffer.writeln('================================================================================');
    buffer.writeln('Generated by YGOBINDER App • Unofficial Yu-Gi-Oh! Binder & Manager');

    final contentStr = buffer.toString();
    final fileName = 'Quoted_Cards_Estimate_${year}-${month}-${day}.txt';

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, fileName));
      await tempFile.writeAsString(contentStr);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        subject: 'YGOBinder Quote Estimate ($totalFormatted)',
        text: 'YGOBinder Quote Estimate:\nTotal: $totalFormatted ($totalCardCount cards)',
      );
    } else {
      await FilePicker.saveFile(
        dialogTitle: 'Export Quote Estimate',
        fileName: fileName,
        type: FileType.any,
        bytes: Uint8List.fromList(utf8.encode(contentStr)),
      );
    }
  }

  Future<void> shareQuoteEstimatePdf(CurrencyInfo currencyInfo) async {
    final db = ref.read(databaseProvider);
    final quoteItems = await (db.select(db.collectionItems)..where((t) => t.collectionNumber.equals(0))).get();

    if (quoteItems.isEmpty) return;

    final cardIds = quoteItems.map((i) => i.cardId).toSet().toList();
    final driftCards = await (db.select(db.cards)..where((t) => t.id.isIn(cardIds))).get();
    final cardNameById = {for (final c in driftCards) c.id: c.name};

    final livePricesList = await (db.select(db.setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
    final livePricesBySetCode = <String, double>{};
    for (final sp in livePricesList) {
      final p = sp.marketPrice ?? sp.lowPrice ?? 0.0;
      if (sp.setCode != null && sp.setCode!.isNotEmpty) {
        livePricesBySetCode['${sp.cardId}_${sp.setCode!.toUpperCase()}_${sp.printing.trim().toLowerCase()}'] = p;
        livePricesBySetCode['${sp.cardId}_${sp.setCode!.toUpperCase()}'] = p;
      }
    }

    final globalPricesList = await (db.select(db.cardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
    final globalPriceById = <int, double>{};
    for (final p in globalPricesList) {
      globalPriceById[p.cardId] = p.tcgPlayerPrice ?? p.cardMarketPrice ?? 0.0;
    }

    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final dateStr = '$day/$month/$year $hour:$minute';

    final pdf = pw.Document();

    final tableData = <List<String>>[];
    double totalEstimateUsd = 0.0;
    int totalCardCount = 0;

    for (var i = 0; i < quoteItems.length; i++) {
      final item = quoteItems[i];
      final cardName = cardNameById[item.cardId] ?? 'Unknown Card';
      final setCode = item.setCode;
      final rarity = item.rarity;
      final qty = item.quantity;

      final key = '${item.cardId}_${setCode.trim().toUpperCase()}_${rarity.trim().toLowerCase()}';
      final fallbackKey = '${item.cardId}_${setCode.trim().toUpperCase()}';

      double unitPriceUsd = livePricesBySetCode[key] ??
          livePricesBySetCode[fallbackKey] ??
          (item.priceAtPurchase ?? 0.0);

      if (unitPriceUsd <= 0.0) {
        unitPriceUsd = globalPriceById[item.cardId] ?? 0.0;
      }

      final subtotalUsd = unitPriceUsd * qty;
      totalEstimateUsd += subtotalUsd;
      totalCardCount += qty;

      tableData.add([
        '${i + 1}',
        '${qty}x',
        cardName,
        setCode,
        rarity,
        currencyInfo.formatPrice(unitPriceUsd),
        currencyInfo.formatPrice(subtotalUsd),
      ]);
    }

    final totalFormatted = currencyInfo.formatPrice(totalEstimateUsd);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Header Banner
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.amber100,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.amber800, width: 1.5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('YGOBINDER', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.amber900)),
                    pw.Text('QUOTE ESTIMATE / COTIZACION', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Date: $dateStr', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.Text('Currency: ${currencyInfo.code}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Items Table
          pw.TableHelper.fromTextArray(
            headers: ['#', 'Qty', 'Card Name', 'Set Code', 'Rarity', 'Unit Price', 'Subtotal'],
            data: tableData,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey800),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
            },
            rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
            oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          ),
          pw.SizedBox(height: 20),

          // Summary Box
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Quoted Cards: $totalCardCount cards', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text('TOTAL ESTIMATE: $totalFormatted', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: PdfColors.green800)),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Generated by YGOBINDER App • Unofficial Yu-Gi-Oh! Manager', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          ),
        ],
      ),
    );

    final pdfBytes = await pdf.save();
    final fileName = 'Quoted_Cards_Estimate_${year}-${month}-${day}.pdf';

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, fileName));
      await tempFile.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        subject: 'YGOBinder Quote Estimate PDF ($totalFormatted)',
        text: 'YGOBinder Quote Estimate PDF:\nTotal: $totalFormatted ($totalCardCount cards)',
      );
    } else {
      await FilePicker.saveFile(
        dialogTitle: 'Export Quote Estimate PDF',
        fileName: fileName,
        type: FileType.any,
        bytes: pdfBytes,
      );
    }
  }
}

final savedDecksProvider = StreamProvider<List<DriftDeck>>((ref) {
  return ref.watch(databaseProvider).watchAllDecks();
});

final userInventoryIdsProvider = StreamProvider<Map<int, int>>((ref) {
  return ref.watch(databaseProvider).watchCollectionCardQuantities();
});

class DeckVisualCard {
  final YgoCard card;
  final bool isOwned;

  const DeckVisualCard({required this.card, required this.isOwned});
}

class VisualDeckData {
  final List<DeckVisualCard> main;
  final List<DeckVisualCard> extra;
  final List<DeckVisualCard> side;

  const VisualDeckData({
    required this.main,
    required this.extra,
    required this.side,
  });
}

final processedDeckDataProvider = FutureProvider<VisualDeckData>((ref) async {
  final categorized = await ref.watch(categorizedDeckCardsProvider.future);
  final inventory = ref.watch(userInventoryIdsProvider).value ?? {};

  final usageTracker = <int, int>{};

  List<DeckVisualCard> prepareVisualCards(List<YgoCard> source) {
    return source.map((card) {
      final totalOwned = inventory[card.id] ?? 0;
      final usedSoFar = usageTracker[card.id] ?? 0;
      final isOwned = usedSoFar < totalOwned;
      usageTracker[card.id] = usedSoFar + 1;
      return DeckVisualCard(card: card, isOwned: isOwned);
    }).toList();
  }

  return VisualDeckData(
    main: prepareVisualCards(categorized['main'] ?? []),
    extra: prepareVisualCards(categorized['extra'] ?? []),
    side: prepareVisualCards(categorized['side'] ?? []),
  );
});

final _deckCardCache = <int, YgoCard>{};

@riverpod
Future<Map<String, List<YgoCard>>> categorizedDeckCards(Ref ref) async {
  final deckState = ref.watch(deckFileContentProvider);
  if (deckState.content.isEmpty) {
    return {'main': [], 'extra': [], 'side': []};
  }

  // Reuse parsing logic
  final categorizedIds = ref.read(deckFileContentProvider.notifier).parseYdk();
  final repo = ref.read(cardRepositoryProvider);

  // Flatten IDs to fetch in one go
  final allIds = <int>{
    ...categorizedIds['main']!,
    ...categorizedIds['extra']!,
    ...categorizedIds['side']!,
  };

  final missingIds = allIds.where((id) => !_deckCardCache.containsKey(id)).toList();

  if (missingIds.isNotEmpty) {
    final fetchedCards = await repo.getCardsByIds(missingIds);
    for (final card in fetchedCards) {
      _deckCardCache[card.id] = card;
    }
  }

  return {
    'main': categorizedIds['main']!.map((id) => _deckCardCache[id]).whereType<YgoCard>().toList(),
    'extra': categorizedIds['extra']!.map((id) => _deckCardCache[id]).whereType<YgoCard>().toList(),
    'side': categorizedIds['side']!.map((id) => _deckCardCache[id]).whereType<YgoCard>().toList(),
  };
}
