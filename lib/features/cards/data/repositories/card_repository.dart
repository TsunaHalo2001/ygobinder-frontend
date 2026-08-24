import 'dart:isolate';
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
    await _db.transaction(() async {
      for (final card in cards) {
        await _db.saveCard(CardMapper.toDriftCardCompanion(card));

        await (_db.delete(_db.cardImages)
            ..where((tbl) => tbl.cardId.equals(card.id)))
            .go();
        await (_db.delete(_db.cardPrices)
            ..where((tbl) => tbl.cardId.equals(card.id)))
            .go();
        await (_db.delete(_db.cardSets)
            ..where((tbl) => tbl.cardId.equals(card.id)))
            .go();
        await (_db.delete(_db.banlistInfos)
            ..where((tbl) => tbl.cardId.equals(card.id)))
            .go();

        if (card.cardImages?.isNotEmpty ?? false) {
          await _db.saveCardImages(
            CardMapper.toDriftCardImagesCompanions(card.id, card.cardImages!),
          );
        }

        if (card.cardPrices?.isNotEmpty ?? false) {
          await _db.saveCardPrices(
            CardMapper.toDriftCardPricesCompanions(card.id, card.cardPrices!),
          );
        }

        if (card.cardSets != null && card.cardSets!.isNotEmpty) {
          await _db.saveCardSets(
            CardMapper.toDriftCardSetsCompanions(card.id, card.cardSets!),
          );
        }

        if (card.banlistInfo != null) {
          final banlist = CardMapper.toDriftBanlistInfoCompanion(card.id, card.banlistInfo);
          if (banlist != null) {
            await _db.saveBanlistInfo(banlist);
          }
        }
      }
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