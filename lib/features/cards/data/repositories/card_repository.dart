import 'dart:isolate';
import 'package:flutter/foundation.dart';
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

    final rawCache = await _dataService.fetchRawCardData(
      onProgress: (received, total) {
        if (total > 0) {
          final progress = (received / total).clamp(0.0, 1.0);
          onStatusChange?.call('Downloading...', progress);
        }
      },
    );

    onStatusChange?.call(
        'Parsing ${rawCache.cards.length} cards & ${rawCache.sets.length} sets...', null);
    final cards = await fetchAndParseCards(rawCache.cards);
    final setInfos = await fetchAndParseSets(rawCache.sets);

    onStatusChange?.call('Saving database...', null);
    await saveCardsAndSets(cards, setInfos);
    await syncCurrencyRates();

    final todayString = DateTime.now().toIso8601String();
    await _db.saveSetting('last_sync_date', todayString);

    onStatusChange?.call('Sync complete!', 1.0);
  }

  Future<void> syncCurrencyRates() async {
    try {
      final rates = await _dataService.fetchCurrencyRates();
      if (rates != null && rates.isNotEmpty) {
        final now = DateTime.now();
        final companions = rates.entries.map((e) {
          return CurrencyRatesCompanion.insert(
            currencyCode: e.key,
            rateToUsd: e.value,
            lastUpdated: Value(now),
          );
        }).toList();

        await _db.saveCurrencyRates(companions);
        await _db.saveSetting('last_currency_sync_date', now.toIso8601String());
      }
    } catch (e) {
      debugPrint('Error syncing currency rates: $e');
    }
  }

  Future<void> syncCurrencyRatesIfNeeded() async {
    final lastSyncStr = await _db.getSetting('last_currency_sync_date');
    if (lastSyncStr != null) {
      final lastSync = DateTime.tryParse(lastSyncStr);
      if (lastSync != null) {
        final now = DateTime.now();
        if (lastSync.year == now.year && lastSync.month == now.month && lastSync.day == now.day) {
          return; // Already synced currency rates today!
        }
      }
    }
    await syncCurrencyRates();
  }

  Future<List<YgoCard>> fetchAndParseCards(List<dynamic> apiData) async {
    return Isolate.run(() {
      final validData = apiData.where((item) => item['type'] != 'Skill Card').toList();

      return validData.map((item) => YgoCard.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<SetInfosCompanion>> fetchAndParseSets(List<dynamic> apiSets) async {
    if (apiSets.isEmpty) return [];
    return Isolate.run(() {
      return apiSets.map((item) {
        final json = item as Map<String, dynamic>;
        return SetInfosCompanion.insert(
          id: Value(json['id'] as int),
          name: json['name'] as String,
          abbreviation: Value(json['abbreviation'] as String?),
          setType: Value(json['type'] as String?),
          isSupplemental: Value(json['is_supplemental'] as bool? ?? false),
          publishedOn: Value(json['published_on'] as String?),
          modifiedOn: Value(json['modified_on'] as String?),
          productCount: Value(json['product_count'] as int?),
          skuCount: Value(json['sku_count'] as int?),
          setSymbolUrl: Value(json['set_symbol_url'] as String?),
          setSymbolCached: Value(json['set_symbol_cached'] as bool? ?? false),
          apiUrl: Value(json['api_url'] as String?),
          cardsUrl: Value(json['cards_url'] as String?),
          sealedUrl: Value(json['sealed_url'] as String?),
          pricingUrl: Value(json['pricing_url'] as String?),
          skusUrl: Value(json['skus_url'] as String?),
        );
      }).toList();
    });
  }

  Future<void> saveCardsAndSets(List<YgoCard> cards, List<SetInfosCompanion> setInfos) async {
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
      await _db.delete(_db.setInfos).go();

      // Batch insert everything at once
      await _db.batch((batch) {
        batch.insertAll(_db.cards, cardCompanions, mode: InsertMode.insertOrReplace);
        batch.insertAll(_db.cardImages, imageCompanions);
        batch.insertAll(_db.cardPrices, priceCompanions);
        batch.insertAll(_db.cardSets, setCompanions);
        batch.insertAll(_db.banlistInfos, banlistCompanions);
        if (setInfos.isNotEmpty) {
          batch.insertAll(_db.setInfos, setInfos, mode: InsertMode.insertOrReplace);
        }
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
    int? scaleFilter,
    int? linkValFilter,
    int? atkFilter,
    String? atkOperator,
    bool? atkShowQuestionMark, // ✅ Added
    int? defFilter,
    String? defOperator,
    bool? defShowQuestionMark,
    String? sortBy, // ✅ Added sort field
    bool sortDescending = false, // ✅ Added sort direction
    bool onlyEdison = false, // ✅ Added only Edison filter
    bool onlyFavorites = false, // ✅ Added only Favorites filter
    bool onlyWanted = false, // ✅ Added only Wanted filter
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
      scaleFilter: scaleFilter,
      linkValFilter: linkValFilter,
      atkFilter: atkFilter,
      atkOperator: atkOperator,
      atkShowQuestionMark: atkShowQuestionMark,
      defFilter: defFilter,
      defOperator: defOperator,
      defShowQuestionMark: defShowQuestionMark,
      sortBy: sortBy, // ✅ Passed sortBy
      sortDescending: sortDescending, // ✅ Passed sortDescending
      onlyEdison: onlyEdison, // ✅ Passed onlyEdison
      onlyFavorites: onlyFavorites,
      onlyWanted: onlyWanted,
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

  Future<List<YgoCard>> getCardsByIds(List<int> cardIds) async {
    if (cardIds.isEmpty) return [];

    final driftCards = await (_db.select(_db.cards)..where((t) => t.id.isIn(cardIds))).get();

    if (driftCards.isEmpty) return [];

    final imagesFuture = (_db.select(_db.cardImages)..where((t) => t.cardId.isIn(cardIds))).get();
    final banlistFuture = (_db.select(_db.banlistInfos)..where((t) => t.cardId.isIn(cardIds))).get();
    final pricesFuture = (_db.select(_db.cardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
    final setsFuture = (_db.select(_db.cardSets)..where((t) => t.cardId.isIn(cardIds))).get();

    final [allImages, allBanlists, allPrices, allSets] = await Future.wait([
      imagesFuture,
      banlistFuture,
      pricesFuture,
      setsFuture,
    ]);

    final imagesByCardId = <int, List<DriftCardImage>>{};
    for (final img in allImages as List<DriftCardImage>) {
      imagesByCardId.putIfAbsent(img.cardId, () => []).add(img);
    }

    final banlistByCardId = {for (final b in allBanlists as List<DriftBanlistInfo>) b.cardId: b};

    final pricesByCardId = <int, List<DriftCardPrice>>{};
    for (final p in allPrices as List<DriftCardPrice>) {
      pricesByCardId.putIfAbsent(p.cardId, () => []).add(p);
    }

    final setsByCardId = <int, List<DriftCardSet>>{};
    for (final s in allSets as List<DriftCardSet>) {
      setsByCardId.putIfAbsent(s.cardId, () => []).add(s);
    }

    return driftCards.map((card) {
      return CardMapper.toYgoCard(
        card,
        images: imagesByCardId[card.id] ?? [],
        banlist: banlistByCardId[card.id],
        prices: pricesByCardId[card.id] ?? [],
        sets: setsByCardId[card.id] ?? [],
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
        await _syncRepo.syncItem(updatedItem);
      }
    }
  }

  Future<int> clearQuoteCollection() async {
    return _db.deleteQuoteCollection();
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
        await _syncRepo.syncItem(updatedItem);
      } else {
        // Completely removed
        await _syncRepo.removeItem(existing);
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

  Stream<List<CardPriceStat>> watchTopExpensiveCards(int limit) {
    return _db.watchTopExpensiveCards(limit);
  }

  Stream<double> watchTotalCollectionValue() {
    return _db.watchTotalCollectionValue();
  }

  Stream<double> watchQuoteCollectionValue() {
    return _db.watchQuoteCollectionValue();
  }

  Stream<YgoCard?> watchNewestCard() {
    return _db.watchNewestCard();
  }

  Stream<YgoCard?> watchOldestCard() {
    return _db.watchOldestCard();
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

  /// Fetches latest pricing for all owned sets from TCGTracking API (1 set/sec)
  Future<void> updateOwnedSetCardPrices({
    required void Function(int processed, int total, String currentSetName) onProgress,
    required bool Function() isCancelled,
  }) async {
    final ownedSets = await _db.getUserOwnedSets();
    if (ownedSets.isEmpty) {
      throw Exception('No owned sets found in your collection.');
    }

    final allSetInfos = await _db.getAllSetInfos();
    final setInfoByAbbr = {
      for (final info in allSetInfos)
        if (info.abbreviation != null && info.abbreviation!.isNotEmpty)
          info.abbreviation!.toUpperCase(): info
    };
    final setInfoByName = {
      for (final info in allSetInfos) info.name.toUpperCase(): info
    };

    final setsToSync = <_SetSyncTask>[];
    final addedSetIds = <int>{};

    for (final owned in ownedSets) {
      final baseCode = owned.setCode.toUpperCase();
      final setInfo = setInfoByAbbr[baseCode] ??
          setInfoByName[owned.setName?.toUpperCase() ?? ''];

      if (setInfo != null && !addedSetIds.contains(setInfo.id)) {
        addedSetIds.add(setInfo.id);
        setsToSync.add(_SetSyncTask(
          setId: setInfo.id,
          setName: setInfo.name,
          setCode: baseCode,
        ));
      }
    }

    if (setsToSync.isEmpty) {
      throw Exception('Could not match set IDs for owned sets.');
    }

    final totalSets = setsToSync.length;

    for (var i = 0; i < totalSets; i++) {
      if (isCancelled()) break;

      final task = setsToSync[i];
      onProgress(i + 1, totalSets, task.setName);

      try {
        final pricingData = await _dataService.fetchSetPricing(task.setId);
        if (pricingData != null) {
          final setId = pricingData['set_id'] as int? ?? task.setId;
          final updatedStr = pricingData['updated'] as String? ?? DateTime.now().toIso8601String();
          final pricesMap = pricingData['prices'] as Map<String, dynamic>?;

          if (pricesMap != null && pricesMap.isNotEmpty) {
            final companions = <SetCardPricesCompanion>[];

            for (final entry in pricesMap.entries) {
              final cardId = int.tryParse(entry.key);
              if (cardId == null) continue;

              final cardData = entry.value as Map<String, dynamic>?;
              final tcgData = cardData?['tcg'] as Map<String, dynamic>?;

              if (tcgData != null) {
                for (final printingEntry in tcgData.entries) {
                  final printing = printingEntry.key;
                  final pMap = printingEntry.value as Map<String, dynamic>?;

                  final low = (pMap?['low'] as num?)?.toDouble();
                  final market = (pMap?['market'] as num?)?.toDouble();

                  companions.add(
                    SetCardPricesCompanion.insert(
                      setId: setId,
                      cardId: cardId,
                      printing: printing,
                      lowPrice: Value(low),
                      marketPrice: Value(market),
                      lastUpdated: Value(updatedStr),
                    ),
                  );
                }
              }
            }

            if (companions.isNotEmpty) {
              await _db.saveSetCardPrices(companions);
            }
          }
        }
      } catch (e) {
        // Allow sync to proceed for remaining sets
      }

      if (i < totalSets - 1 && !isCancelled()) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
}

class _SetSyncTask {
  final int setId;
  final String setName;
  final String setCode;

  _SetSyncTask({
    required this.setId,
    required this.setName,
    required this.setCode,
  });
}