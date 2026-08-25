import 'dart:isolate';
import 'package:drift/drift.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';

class CardRepository {
  final AppDatabase _db;
  final CardDataService _dataService;

  CardRepository(this._db, this._dataService);

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
  }) async {
    final driftCards = await _db.getCardsPage(
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
    );

    if (driftCards.isEmpty) return [];

    // Efficiently fetch all images for these cards in one query
    final cardIds = driftCards.map((c) => c.id).toList();
    final allImages = await (_db.select(_db.cardImages)
      ..where((t) => t.cardId.isIn(cardIds)))
        .get();

    // Group images by cardId
    final imagesByCardId = <int, List<DriftCardImage>>{};
    for (final img in allImages) {
      imagesByCardId.putIfAbsent(img.cardId, () => []).add(img);
    }

    return driftCards.map((card) {
      return CardMapper.toYgoCard(
        card,
        images: imagesByCardId[card.id] ?? [],
      );
    }).toList();
  }

  Stream<List<YgoCard>> watchAllCards() {
    return _db.watchAllCards().map((cards) => cards.map((card) => CardMapper.toYgoCard(card)).toList());
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