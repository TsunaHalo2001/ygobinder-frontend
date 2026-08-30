import 'dart:isolate';
import 'package:drift/drift.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';
import 'package:ygobinder/features/inventory/data/repositories/inventory_sync_repository.dart';

class CardRepository {
  final AppDatabase _db;
  final CardDataService _dataService;
  final InventorySyncRepository? _syncRepo;

  CardRepository(this._db, this._dataService, [this._syncRepo]);

  Future<void> syncAllCards({
    void Function(String status, double? progress)? onStatusChange,
  }) async {
    onStatusChange?.call('Downloading card data...', 0.0);

    final rawData = await _dataService.fetchRawCardData(
      onProgress: (received, total) {
        if (total > 0) {
          final progress = (received / total).clamp(0.0, 1.0);
          onStatusChange?.call('Downloading...', progress);
        }
      },
    );

    onStatusChange?.call('Parsing ${rawData.length} cards...', null);
    final cards = await fetchAndParseCards(rawData);

    onStatusChange?.call('Saving ${cards.length} cards to database...', null);
    await saveCards(cards);

    final todayString = DateTime.now().toIso8601String();
    await _db.saveSetting('last_sync_date', todayString);

    onStatusChange?.call('Sync complete!', 1.0);
  }

  Future<List<YgoCard>> fetchAndParseCards(List<dynamic> apiData) async {
    return Isolate.run(() {
      final validData = apiData.where((item) => item['type'] != 'Skill Card').toList();

      return validData.map((item) => YgoCard.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<void> saveCards(List<YgoCard> cards) async {
    // 1. Prepare all data in memory first (Very fast, no DB calls yet)
    final cardCompanions = cards.map((c) => CardMapper.toDriftCardCompanion(c)).toList();
    final imageCompanions = <CardImagesCompanion>[];
    final priceCompanions = <CardPricesCompanion>[];
    final setCompanions = <CardSetsCompanion>[];
    final banlistCompanions = <BanlistInfosCompanion>[];

    for (final card in cards) {
      if (card.cardImages?.isNotEmpty ?? false) {
        imageCompanions.addAll(CardMapper.toDriftCardImagesCompanions(card.id, card.cardImages!));
      }
      if (card.cardPrices?.isNotEmpty ?? false) {
        priceCompanions.addAll(CardMapper.toDriftCardPricesCompanions(card.id, card.cardPrices!));
      }
      if (card.cardSets?.isNotEmpty ?? false) {
        setCompanions.addAll(CardMapper.toDriftCardSetsCompanions(card.id, card.cardSets!));
      }
      if (card.banlistInfo != null) {
        final banlist = CardMapper.toDriftBanlistInfoCompanion(card.id, card.banlistInfo);
        if (banlist != null) banlistCompanions.add(banlist);
      }
    }

    // 2. Execute ONE massive transaction (The "Second Plane" speed boost)
    await _db.transaction(() async {
      // Clear old related data (Since this is a full sync, it's faster to clear than to update row-by-row)
      await _db.delete(_db.cardImages).go();
      await _db.delete(_db.cardPrices).go();
      await _db.delete(_db.cardSets).go();
      await _db.delete(_db.banlistInfos).go();

      // Batch insert everything at once
      await _db.batch((batch) {
        batch.insertAll(_db.cards, cardCompanions, mode: InsertMode.insertOrReplace);
        batch.insertAll(_db.cardImages, imageCompanions);
        batch.insertAll(_db.cardPrices, priceCompanions);
        batch.insertAll(_db.cardSets, setCompanions);
        batch.insertAll(_db.banlistInfos, banlistCompanions);
      });
    });
  }

  Future<YgoCard?> getCardWithDetails(int cardId) async {
    final card = await _db.getCardById(cardId);
    if (card == null) return null;

    final images = await _db.getCardImages(cardId);
    final prices = await _db.getCardPrices(cardId);
    final sets = await _db.getCardSets(cardId);
    final banlist = await _db.getBanlistInfo(cardId);

    return CardMapper.toYgoCard(
      card,
      images: images,
      prices: prices,
      sets: sets,
      banlist: banlist,
    );
  }

  Future<List<YgoCard>> searchCards(String query) async {
    final cards = await _db.searchCards(query);

    return cards.map((card) => CardMapper.toYgoCard(card)).toList();
  }

  Future<List<YgoCard>> getCardsPage({
    required int offset,
    required int limit,
    String? searchQuery,
    String? typeFilter,
    String? attributeFilter,
    String? raceFilter,
    String? subTypeFilter,
    String? frameFilter,
    int? levelFilter,
    int? scaleFilter, // ✅ Added scale filter
  }) async {
    final driftCards = await _db.getCardsPage(
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
      typeFilter: typeFilter,
      attributeFilter: attributeFilter,
      raceFilter: raceFilter,
      subTypeFilter: subTypeFilter,
      frameFilter: frameFilter,
      levelFilter: levelFilter,
      scaleFilter: scaleFilter, // ✅ Passed scale filter
    );

    if (driftCards.isEmpty) return [];

    // Efficiently fetch all images and banlist info for these cards in one batch
    final cardIds = driftCards.map((c) => c.id).toList();
    
    final imagesFuture = (_db.select(_db.cardImages)
      ..where((t) => t.cardId.isIn(cardIds)))
        .get();
        
    final banlistFuture = (_db.select(_db.banlistInfos)
      ..where((t) => t.cardId.isIn(cardIds)))
        .get();

    final [allImages, allBanlists] = await Future.wait([imagesFuture, banlistFuture]);

    // Group images by cardId
    final imagesByCardId = <int, List<DriftCardImage>>{};
    for (final img in allImages as List<DriftCardImage>) {
      imagesByCardId.putIfAbsent(img.cardId, () => []).add(img);
    }
    
    // Group banlist by cardId
    final banlistByCardId = {
      for (final b in allBanlists as List<DriftBanlistInfo>) b.cardId: b
    };

    return driftCards.map((card) {
      return CardMapper.toYgoCard(
        card,
        images: imagesByCardId[card.id] ?? [],
        banlist: banlistByCardId[card.id],
      );
    }).toList();
  }

  Stream<List<YgoCard>> watchAllCards() {
    return _db.watchAllCards().map((cards) => cards.map((card) => CardMapper.toYgoCard(card)).toList());
  }

  Future<void> addCardToCollection({
    required int cardId,
    required String setCode,
    required String rarity,
    required int quantity,
    required int collectionNumber,
  }) async {
    final itemId = await _db.addToCollection(
      cardId: cardId,
      setCode: setCode,
      rarity: rarity,
      quantity: quantity,
      collectionNumber: collectionNumber,
    );

    // Sync to Cloud
    if (_syncRepo != null) {
      final updatedItem = await _db.getCollectionItemById(itemId);
      if (updatedItem != null) {
        await _syncRepo!.syncItem(updatedItem);
      }
    }
  }

  Future<void> removeCardFromCollection({
    required int collectionItemId,
    int quantity = 1,
  }) async {
    // We need to check if it still exists after removal for sync
    final existing = await _db.getCollectionItemById(collectionItemId);
    
    await _db.removeFromCollection(
      collectionItemId: collectionItemId,
      quantityToRemove: quantity,
    );

    // Sync to Cloud
    if (_syncRepo != null && existing != null) {
      final updatedItem = await _db.getCollectionItemById(collectionItemId);
      if (updatedItem != null) {
        // Still exists (decreased quantity)
        await _syncRepo!.syncItem(updatedItem);
      } else {
        // Completely removed
        await _syncRepo!.removeItem(existing);
      }
    }
  }

  Future<List<DriftCollectionItem>> getInventoryForCard(int cardId) {
    return _db.getCollectionItemsByCardId(cardId);
  }

  Stream<int> watchTotalCardCount() {
    return _db.watchTotalCardCount();
  }

  Stream<int> watchUniqueCardCount() {
    return _db.watchUniqueCardCount();
  }

  Stream<List<SetStat>> watchTopSets(int limit) {
    return _db.watchTopSets(limit);
  }

  Stream<List<CardStat>> watchTopCards(int limit) {
    return _db.watchTopCards(limit);
  }

  Future<int?> identifyCardFromText(List<String> lines) async {
    final idRegex = RegExp(r'\b\d{8}\b'); // Exactly 8 digits
    final setCodeRegex = RegExp(r'([A-Z0-9]{3,4})-([A-Z0-9]+)'); // Basic PREFIX-SUFFIX pattern

    final List<String> cleanLines = lines.map((l) => l.trim().toUpperCase()).where((l) => l.isNotEmpty).toList();

    // Priority 1: Card ID (Exact 8-digit match anywhere in the text)
    for (final line in cleanLines) {
      final match = idRegex.firstMatch(line);
      if (match != null) {
        final id = int.tryParse(match.group(0)!);
        if (id != null) {
          final card = await _db.getCardById(id);
          if (card != null) return card.id;
        }
      }
    }

    // Priority 2: Set Code (Fuzzy)
    for (final line in cleanLines) {
      final match = setCodeRegex.firstMatch(line);
      if (match != null) {
        final fullMatch = match.group(0)!;
        
        // Try exact match first
        final exactId = await _db.getCardIdBySetCode(fullMatch);
        if (exactId != null) return exactId;

        // Try fuzzy: Extract Prefix and trailing digits
        final prefix = match.group(1)!;
        final suffix = match.group(2)!;
        
        // Extract only the digits from the suffix (e.g. BNO38 -> 038)
        final digitsMatch = RegExp(r'\d+').firstMatch(suffix);
        if (digitsMatch != null) {
          final digits = digitsMatch.group(0)!;
          final fuzzyId = await _db.getCardIdByFuzzySetCode(prefix, digits);
          if (fuzzyId != null) return fuzzyId;
        }
      }
    }

    // Priority 3: Name (Exact match)
    for (final line in cleanLines) {
      final card = await _db.getCardByName(line);
      if (card != null) return card.id;
    }

    return null;
  }

  /// Checks if the database was already synced today.
  Future<bool> needsDailySync() async {
    final lastSyncStr = await _db.getSetting('last_sync_date');
    if (lastSyncStr == null) return true; // Never synced before

    final lastSync = DateTime.tryParse(lastSyncStr);
    if (lastSync == null) return true; // Invalid date

    final now = DateTime.now();

    // If the year, month, and day match, we already synced today!
    final isToday = lastSync.year == now.year &&
        lastSync.month == now.month &&
        lastSync.day == now.day;

    return !isToday;
  }
}