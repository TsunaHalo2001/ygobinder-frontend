import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/card_filters.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/services/card_cache_parser.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';
import 'package:ygobinder/features/cards/data/services/set_price_service.dart';
import 'package:ygobinder/features/cards/data/repositories/card_flag_sync_repository.dart';
import 'package:ygobinder/features/decks/data/repositories/deck_sync_repository.dart';
import 'package:ygobinder/features/inventory/data/repositories/inventory_sync_repository.dart';

class CardRepository {
  final AppDatabase _db;
  final CardDataService _dataService;
  final InventorySyncRepository? _syncRepo;
  final CardFlagSyncRepository? _favoriteSyncRepo;
  final CardFlagSyncRepository? _wantedSyncRepo;
  final DeckSyncRepository? _deckSyncRepo;

  CardRepository(
    this._db,
    this._dataService, [
    this._syncRepo,
    this._favoriteSyncRepo,
    this._wantedSyncRepo,
    this._deckSyncRepo,
  ]);

  static const _etagSettingKey = 'card_cache_etag';

  /// Downloads and stores the full card database.
  ///
  /// Unless [force] is true, the stored ETag is sent so an unchanged file is
  /// answered with 304 and the (expensive) parse + rewrite is skipped.
  Future<void> syncAllCards({
    void Function(String status, double? progress)? onStatusChange,
    bool force = false,
  }) async {
    onStatusChange?.call('Downloading card data...', 0.0);

    final etag = force ? null : await _usableCachedEtag();
    final download = await _dataService.downloadCardCache(
      etag: etag,
      onProgress: (received, total) {
        if (total > 0) {
          final progress = (received / total).clamp(0.0, 1.0);
          onStatusChange?.call('Downloading...', progress);
        }
      },
    );

    if (!download.notModified) {
      final parsed = await parseCardCacheInBackground(
        download.bytes!,
        onDecoded: (cardCount, setCount) =>
            onStatusChange?.call('Parsing $cardCount cards & $setCount sets...', null),
      );

      onStatusChange?.call('Saving database...', null);
      await saveParsedCardCache(parsed);
      if (download.etag != null) {
        await _db.saveSetting(_etagSettingKey, download.etag!);
      }
    }
    // Runs even when the card data is unchanged, so data left on retired ids
    // by an older app version is repaired on the next sync.
    await remapRetiredCardIds();
    await syncCurrencyRates();

    final todayString = DateTime.now().toIso8601String();
    await _db.saveSetting('last_sync_date', todayString);

    onStatusChange?.call('Sync complete!', 1.0);
  }

  /// The stored ETag, only if the local card table is actually populated.
  Future<String?> _usableCachedEtag() async {
    final etag = await _db.getSetting(_etagSettingKey);
    if (etag == null || etag.isEmpty) return null;
    return await _db.hasCards() ? etag : null;
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

  /// Replaces all global card data with [parsed] in one transaction.
  Future<void> saveParsedCardCache(ParsedCardCache parsed) async {
    await _db.transaction(() async {
      // Full sync: clearing related tables is faster than row-by-row updates
      await _db.delete(_db.cardImages).go();
      await _db.delete(_db.cardPrices).go();
      await _db.delete(_db.cardSets).go();
      await _db.delete(_db.banlistInfos).go();
      await _db.delete(_db.setInfos).go();

      await _db.batch((batch) {
        batch.insertAll(_db.cards, parsed.cards, mode: InsertMode.insertOrReplace);
        batch.insertAll(_db.cardImages, parsed.images);
        batch.insertAll(_db.cardPrices, parsed.prices);
        batch.insertAll(_db.cardSets, parsed.cardSets);
        batch.insertAll(_db.banlistInfos, parsed.banlists);
        if (parsed.setInfos.isNotEmpty) {
          batch.insertAll(_db.setInfos, parsed.setInfos, mode: InsertMode.insertOrReplace);
        }
      });
    });

    // Cards that are no longer in the card data would otherwise stay forever
    // as empty duplicates. Rows still used by inventory or decks are kept
    // here; remapRetiredCardIds moves those that have a new id.
    final parsedIds = {for (final c in parsed.cards) c.id.value};
    final storedIds = await (_db.selectOnly(_db.cards)..addColumns([_db.cards.id]))
        .map((row) => row.read(_db.cards.id)!)
        .get();
    await _db.deleteUnreferencedCards(storedIds.where((id) => !parsedIds.contains(id)));
  }

  /// Moves the user's data off card ids that the card data has retired (see
  /// [AppDatabase.remapRetiredCardIds]) and pushes the corrections to the
  /// cloud, so other devices and later pulls don't bring the old ids back.
  Future<void> remapRetiredCardIds() async {
    final remap = await _db.remapRetiredCardIds();
    if (remap.removedCards > 0 || remap.hasUserDataChanges) {
      debugPrint('Retired card ids: moved ${remap.inventory.length} inventory, '
          '${remap.deckIds.length} decks, ${remap.favorites.length} favorites, '
          '${remap.wanted.length} wanted; removed ${remap.removedCards} cards');
    }
    if (!remap.hasUserDataChanges) return;

    final syncRepo = _syncRepo;
    if (syncRepo != null) {
      for (final change in remap.inventory) {
        _runCloudSync(() async {
          await syncRepo.removeItem(change.removed);
          await syncRepo.syncItem(change.kept);
        });
      }
    }
    for (final (repo, changes) in [(_favoriteSyncRepo, remap.favorites), (_wantedSyncRepo, remap.wanted)]) {
      if (repo == null) continue;
      for (final change in changes) {
        _runCloudSync(() async {
          await repo.syncFlag(change.oldId, false);
          await repo.syncFlag(change.newId, true, syncId: change.syncId);
        });
      }
    }
    final deckSyncRepo = _deckSyncRepo;
    if (deckSyncRepo != null) {
      for (final deckId in remap.deckIds) {
        _runCloudSync(() async {
          final deck = await _db.getDeckById(deckId);
          if (deck == null) return;
          await deckSyncRepo.syncDeck(deck, await _db.getDeckCards(deckId));
        });
      }
    }
  }

  Future<YgoCard?> getCardWithDetails(int cardId) async {
    final (card, images, prices, sets, banlist) = await (
      _db.getCardById(cardId),
      _db.getCardImages(cardId),
      _db.getCardPrices(cardId),
      _db.getCardSets(cardId),
      _db.getBanlistInfo(cardId),
    ).wait;
    if (card == null) return null;

    return CardMapper.toYgoCard(
      card,
      images: images,
      prices: prices,
      sets: sets,
      banlist: banlist,
    );
  }

  Future<List<YgoCard>> getCardsPage({
    required int offset,
    required int limit,
    CardFilters filters = const CardFilters(),
  }) async {
    final driftCards = await _db.getCardsPage(
      offset: offset,
      limit: limit,
      filters: filters,
    );

    return _attachRelations(driftCards);
  }

  Future<List<YgoCard>> getCardsByIds(List<int> cardIds) async {
    if (cardIds.isEmpty) return [];

    final driftCards = await (_db.select(_db.cards)..where((t) => t.id.isIn(cardIds))).get();
    return _attachRelations(driftCards, withPricesAndSets: true);
  }

  /// Maps [driftCards] to [YgoCard]s, loading images and banlist info (and
  /// optionally prices and sets) for all of them in a few batched queries.
  Future<List<YgoCard>> _attachRelations(List<DriftCard> driftCards, {bool withPricesAndSets = false}) async {
    if (driftCards.isEmpty) return [];
    final cardIds = driftCards.map((c) => c.id).toList();

    final (images, banlists, prices, sets) = await (
      (_db.select(_db.cardImages)..where((t) => t.cardId.isIn(cardIds))).get(),
      (_db.select(_db.banlistInfos)..where((t) => t.cardId.isIn(cardIds))).get(),
      withPricesAndSets
          ? (_db.select(_db.cardPrices)..where((t) => t.cardId.isIn(cardIds))).get()
          : Future.value(const <DriftCardPrice>[]),
      withPricesAndSets
          ? (_db.select(_db.cardSets)..where((t) => t.cardId.isIn(cardIds))).get()
          : Future.value(const <DriftCardSet>[]),
    ).wait;

    final imagesByCardId = _groupBy(images, (DriftCardImage i) => i.cardId);
    final pricesByCardId = _groupBy(prices, (DriftCardPrice p) => p.cardId);
    final setsByCardId = _groupBy(sets, (DriftCardSet s) => s.cardId);
    final banlistByCardId = {for (final b in banlists) b.cardId: b};

    return driftCards.map((card) {
      return CardMapper.toYgoCard(
        card,
        images: imagesByCardId[card.id] ?? const [],
        banlist: banlistByCardId[card.id],
        prices: pricesByCardId[card.id] ?? const [],
        sets: setsByCardId[card.id] ?? const [],
      );
    }).toList();
  }

  static Map<int, List<T>> _groupBy<T>(Iterable<T> rows, int Function(T) key) {
    final grouped = <int, List<T>>{};
    for (final row in rows) {
      grouped.putIfAbsent(key(row), () => []).add(row);
    }
    return grouped;
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

    // Sync to Cloud. Not awaited: Firestore only completes on server ack, so
    // awaiting would block the UI while offline. Firestore queues the write.
    final syncRepo = _syncRepo;
    if (syncRepo != null) {
      final updatedItem = await _db.getCollectionItemById(itemId);
      if (updatedItem != null) {
        _runCloudSync(() => syncRepo.syncItem(updatedItem));
      }
    }
  }

  void _runCloudSync(Future<void> Function() action) {
    unawaited(Future(action).catchError((Object e) {
      debugPrint('Cloud sync failed: $e');
    }));
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

    // Sync to Cloud (not awaited, see addCardToCollection)
    final syncRepo = _syncRepo;
    if (syncRepo != null && existing != null) {
      final updatedItem = await _db.getCollectionItemById(collectionItemId);
      if (updatedItem != null) {
        // Still exists (decreased quantity)
        _runCloudSync(() => syncRepo.syncItem(updatedItem));
      } else {
        // Completely removed
        _runCloudSync(() => syncRepo.removeItem(existing));
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

    // Remove rows written by older versions that keyed prices by TCGplayer
    // product id instead of card id (they never match any card).
    await _db.deleteOrphanSetCardPrices();

    // Printing codes the user actually owns, preferred over other codes of
    // the same card in a set (e.g. LOB-EN001 over LOB-001).
    final ownedCodesByCard = <int, Set<String>>{};
    for (final item in await _db.select(_db.collectionItems).get()) {
      ownedCodesByCard.putIfAbsent(item.cardId, () => {}).add(item.setCode.trim().toUpperCase());
    }

    final totalSets = setsToSync.length;

    for (var i = 0; i < totalSets; i++) {
      if (isCancelled()) break;

      final task = setsToSync[i];
      onProgress(i + 1, totalSets, task.setName);

      try {
        await _updateSetPrices(task, ownedCodesByCard, isCancelled);
      } catch (e) {
        // Allow sync to proceed for remaining sets
        debugPrint('Error updating prices for set ${task.setId}: $e');
      }

      if (i < totalSets - 1 && !isCancelled()) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// Fetches `/cards` + `/pricing` for one set and stores per-printing prices
  /// for every local card that has a printing in that set.
  Future<void> _updateSetPrices(
    _SetSyncTask task,
    Map<int, Set<String>> ownedCodesByCard,
    bool Function() isCancelled,
  ) async {
    final setCards = await _dataService.fetchSetCards(task.setId);
    if (setCards == null || setCards.isEmpty) return;

    // One printing code per card in this set (e.g. LOB-EN001 for card 89631139).
    final printings = await _db.getCardPrintingsBySetPrefix(task.setCode);
    if (printings.isEmpty) return;

    if (isCancelled()) return;
    await Future.delayed(const Duration(seconds: 1)); // Respect API rate limit

    final pricingData = await _dataService.fetchSetPricing(task.setId);
    if (pricingData == null) return;

    final previousPrices = SetPriceService.previousPricesFrom(
      await _db.getSetCardPricesForSet(task.setId),
    );

    final companions = <SetCardPricesCompanion>[];
    final prefix = '${task.setCode.toUpperCase()}-';
    for (final printing in printings) {
      final ownedCode = ownedCodesByCard[printing.cardId]?.firstWhereOrNull((c) => c.startsWith(prefix));
      final setCode = ownedCode ?? printing.setCode;
      final products = SetPriceService.matchProducts(
        setCards,
        setCode: setCode,
        cardName: printing.cardName,
      );
      if (products.isEmpty) continue;
      companions.addAll(SetPriceService.buildCompanions(
        pricingData: pricingData,
        fallbackSetId: task.setId,
        cardId: printing.cardId,
        setCode: setCode,
        products: products,
        previousPrices: previousPrices,
      ));
    }

    if (companions.isNotEmpty) {
      await _db.saveSetCardPrices(companions);
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