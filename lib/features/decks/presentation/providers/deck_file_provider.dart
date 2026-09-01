import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

part 'deck_file_provider.g.dart';

@riverpod
class DeckFileContent extends _$DeckFileContent {
  StreamSubscription? _intentSubscription;

  @override
  String build() {
    ref.onDispose(() => _intentSubscription?.cancel());
    _initIntentListener();
    return '';
  }

  void _initIntentListener() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    // For sharing files coming from outside the app while the app is in the memory
    _intentSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
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
    if (path.endsWith('.ydk')) {
      try {
        final file = File(path);
        if (!await file.exists()) {
          state = "Error: File does not exist at $path";
          return;
        }
        final content = await file.readAsString();
        state = content;
      } catch (e) {
        state = "Error reading file: $e\nPath: $path";
      }
    } else {
      state = "Error: Only .ydk files are supported.";
    }
  }

  void reset() {
    state = '';
  }

  Map<String, List<int>> parseYdk() {
    final Map<String, List<int>> categorizedCards = {
      'main': [],
      'extra': [],
      'side': [],
    };

    if (state.isEmpty) return categorizedCards;

    final lines = state.split('\n');
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

  Future<void> saveToDatabase(String name) async {
    final categorizedCards = parseYdk();
    final db = ref.read(databaseProvider);
    await db.saveDeck(name, categorizedCards);
  }

  Future<void> loadFromDatabase(int deckId) async {
    final db = ref.read(databaseProvider);
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

    state = buffer.toString();
  }
}

final savedDecksProvider = StreamProvider<List<DriftDeck>>((ref) {
  return ref.watch(databaseProvider).watchAllDecks();
});

final userInventoryIdsProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(databaseProvider).watchCollection().map((items) {
    return items.map((item) => item.card.id).toSet();
  });
});

@riverpod
Future<Map<String, List<YgoCard>>> categorizedDeckCards(Ref ref) async {
  final ydk = ref.watch(deckFileContentProvider);
  if (ydk.isEmpty) {
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
  }.toList();

  final allCards = await repo.getCardsByIds(allIds);
  final cardMap = {for (final card in allCards) card.id: card};

  return {
    'main': categorizedIds['main']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
    'extra': categorizedIds['extra']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
    'side': categorizedIds['side']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
  };
}
