import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/database/database_provider.dart';
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

  DeckState({required this.content, this.name});
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

  void addCardToCategory(int cardId, String category) {
    final categorized = parseYdk();
    categorized[category]?.add(cardId);
    _updateContentFromCategorized(categorized);
  }

  void removeOneCopyFromCategory(int cardId, String category) {
    final categorized = parseYdk();
    categorized[category]?.remove(cardId);
    _updateContentFromCategorized(categorized);
  }

  void removeOneCopyFromAnyCategory(int cardId) {
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
    state = DeckState(content: buffer.toString(), name: state.name);
  }

  Future<void> saveToDatabase(String name) async {
    final categorizedCards = parseYdk();
    final db = ref.read(databaseProvider);
    
    final syncId = const Uuid().v4();
    final deckId = await db.saveDeck(name, categorizedCards, syncId: syncId);
    
    // Sync to cloud (Non-blocking and safe)
    _syncDeckToCloud(deckId);

    state = DeckState(content: state.content, name: name);
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

    state = DeckState(content: buffer.toString(), name: deck?.name);
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
