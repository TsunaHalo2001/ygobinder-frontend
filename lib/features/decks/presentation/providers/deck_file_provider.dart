import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

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

  Future<void> saveToDatabase(String name) async {
    final categorizedCards = parseYdk();
    final db = ref.read(databaseProvider);
    await db.saveDeck(name, categorizedCards);
    state = DeckState(content: state.content, name: name);
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
      final result = await FilePicker.saveFile(
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
  return ref.watch(databaseProvider).watchCollection().map((items) {
    final inventory = <int, int>{};
    for (final item in items) {
      inventory[item.card.id] = (inventory[item.card.id] ?? 0) + item.collectionItem.quantity;
    }
    return inventory;
  });
});

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
  }.toList();

  final allCards = await repo.getCardsByIds(allIds);
  final cardMap = {for (final card in allCards) card.id: card};

  return {
    'main': categorizedIds['main']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
    'extra': categorizedIds['extra']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
    'side': categorizedIds['side']!.map((id) => cardMap[id]).whereType<YgoCard>().toList(),
  };
}
