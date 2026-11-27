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
import 'package:ygobinder/core/utils/formatters.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/services/price_resolver.dart';
import 'package:ygobinder/features/decks/data/repositories/deck_sync_repository.dart';
import 'package:ygobinder/features/decks/data/ydk.dart';
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

      // Deck files from other tools can use card ids the card data has
      // retired; map them so those cards aren't dropped as unknown.
      final aliases = await ref.read(databaseProvider).getRetiredCardIdAliases();
      final content = replaceYdkCardIds(await file.readAsString(), aliases);
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
    state = DeckState(
      content: buildYdk(),
      name: name,
    );
  }

  Map<String, List<int>> parseYdk() => parseYdkContent(state.content);

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

    state = DeckState(
      content: buildYdk(main: mainCards, extra: extraCards),
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
    state = DeckState(
      content: buildYdkFromCategorized(categorized),
      name: state.name,
      isQuoteDeck: state.isQuoteDeck,
    );
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
    
    state = DeckState(
      content: buildYdkFromCategorized(groupDeckCardsByCategory(cards)),
      name: deck?.name,
      isQuoteDeck: false,
    );
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

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path)],
          subject: 'YGO Deck: ${state.name ?? "deck"}',
        ),
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

  /// Loads quote collection (#0) items and prices them; null when empty.
  Future<_QuoteEstimate?> _buildQuoteEstimate() async {
    final db = ref.read(databaseProvider);
    final quoteItems = await (db.select(db.collectionItems)..where((t) => t.collectionNumber.equals(0))).get();
    if (quoteItems.isEmpty) return null;

    final cardIds = quoteItems.map((i) => i.cardId).toSet().toList();
    final (driftCards, setPrices, globalPrices) = await (
      (db.select(db.cards)..where((t) => t.id.isIn(cardIds))).get(),
      (db.select(db.setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get(),
      (db.select(db.cardPrices)..where((t) => t.cardId.isIn(cardIds))).get(),
    ).wait;
    final cardNameById = {for (final c in driftCards) c.id: c.name};
    final resolver = PriceResolver(globalPrices: globalPrices, setPrices: setPrices);

    final rows = [
      for (final item in quoteItems)
        _QuoteRow(
          item: item,
          cardName: cardNameById[item.cardId] ?? 'Unknown Card',
          unitPriceUsd: resolver.quoteItemPrice(item),
        ),
    ];
    return _QuoteEstimate(rows, DateTime.now());
  }

  Future<void> shareQuoteEstimate(CurrencyInfo currencyInfo) async {
    final estimate = await _buildQuoteEstimate();
    if (estimate == null) return;

    final buffer = StringBuffer();
    buffer.writeln('================================================================================');
    buffer.writeln('                        YGOBINDER - QUOTE ESTIMATE');
    buffer.writeln('================================================================================');
    buffer.writeln('Date Generated : ${estimate.dateLabel}');
    buffer.writeln('Currency       : ${currencyInfo.code}');
    buffer.writeln('Source         : Quote Collection (#0)');
    buffer.writeln('--------------------------------------------------------------------------------\n');

    buffer.writeln('#   QTY   CARD NAME                          SET CODE    RARITY                     UNIT PRICE    SUBTOTAL');
    buffer.writeln('--------------------------------------------------------------------------------------------------------------');

    for (var i = 0; i < estimate.rows.length; i++) {
      final row = estimate.rows[i];
      final setCode = row.item.setCode;
      final rarity = row.item.rarity;
      final cardName = row.cardName;

      final padNum = (i + 1).toString().padRight(3);
      final padQty = '${row.item.quantity}x'.padRight(5);
      final padName = (cardName.length > 33 ? '${cardName.substring(0, 30)}...' : cardName).padRight(33);
      final padCode = setCode.padRight(11);
      final padRarity = (rarity.length > 25 ? '${rarity.substring(0, 22)}...' : rarity).padRight(25);
      final padUnitPrice = currencyInfo.formatPrice(row.unitPriceUsd).padRight(13);
      final padSubtotal = currencyInfo.formatPrice(row.subtotalUsd);

      buffer.writeln('$padNum $padQty $padName $padCode $padRarity $padUnitPrice $padSubtotal');
    }

    final totalFormatted = currencyInfo.formatPrice(estimate.totalUsd);
    final totalCardCount = estimate.totalCardCount;

    buffer.writeln('--------------------------------------------------------------------------------------------------------------');
    buffer.writeln('TOTAL QUOTED CARDS : $totalCardCount cards');
    buffer.writeln('TOTAL ESTIMATE     : $totalFormatted');
    buffer.writeln('================================================================================');
    buffer.writeln('Generated by YGOBINDER App • Unofficial Yu-Gi-Oh! Binder & Manager');

    final contentStr = buffer.toString();
    final fileName = 'Quoted_Cards_Estimate_${estimate.fileDate}.txt';

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, fileName));
      await tempFile.writeAsString(contentStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path)],
          subject: 'YGOBinder Quote Estimate ($totalFormatted)',
          text: 'YGOBinder Quote Estimate:\nTotal: $totalFormatted ($totalCardCount cards)',
        ),
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
    final estimate = await _buildQuoteEstimate();
    if (estimate == null) return;

    final pdf = pw.Document();

    final tableData = [
      for (var i = 0; i < estimate.rows.length; i++)
        [
          '${i + 1}',
          '${estimate.rows[i].item.quantity}x',
          estimate.rows[i].cardName,
          estimate.rows[i].item.setCode,
          estimate.rows[i].item.rarity,
          currencyInfo.formatPrice(estimate.rows[i].unitPriceUsd),
          currencyInfo.formatPrice(estimate.rows[i].subtotalUsd),
        ],
    ];

    final totalCardCount = estimate.totalCardCount;
    final totalFormatted = currencyInfo.formatPrice(estimate.totalUsd);

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
                    pw.Text('Date: ${estimate.dateLabel}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
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
    final fileName = 'Quoted_Cards_Estimate_${estimate.fileDate}.pdf';

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, fileName));
      await tempFile.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path)],
          subject: 'YGOBinder Quote Estimate PDF ($totalFormatted)',
          text: 'YGOBinder Quote Estimate PDF:\nTotal: $totalFormatted ($totalCardCount cards)',
        ),
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

class _QuoteRow {
  final DriftCollectionItem item;
  final String cardName;
  final double unitPriceUsd;

  const _QuoteRow({required this.item, required this.cardName, required this.unitPriceUsd});

  double get subtotalUsd => unitPriceUsd * item.quantity;
}

class _QuoteEstimate {
  final List<_QuoteRow> rows;
  final DateTime generatedAt;

  _QuoteEstimate(this.rows, this.generatedAt);

  double get totalUsd => rows.fold(0.0, (sum, r) => sum + r.subtotalUsd);
  int get totalCardCount => rows.fold(0, (sum, r) => sum + r.item.quantity);

  /// e.g. `26/11/2026 14:05`
  String get dateLabel => formatDateTime(generatedAt);

  /// e.g. `2026-11-26`
  String get fileDate =>
      '${generatedAt.year}-${generatedAt.month.toString().padLeft(2, '0')}-${generatedAt.day.toString().padLeft(2, '0')}';
}
