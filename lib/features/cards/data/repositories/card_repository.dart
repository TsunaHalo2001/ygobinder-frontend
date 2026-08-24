import 'dart:convert';
import 'dart:isolate';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

class CardRepository {
  final AppDatabase _db;

  CardRepository(this._db);

  Future<List<YgoCard>> fetchAndParseCards(List<dynamic> apiData) async {
    return Isolate.run(() {
      final validData = apiData.where((item) => item['type'] != 'Skill Card').toList();

      return validData.map((item) => YgoCard.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<void> saveCards(List<YgoCard> cards) async {
    await _db.transaction(() async {
      for (final card in cards) {
        await _db.saveCard(CardMapper.toDriftCard(card));

        if (card.cardImages.isNotEmpty) {
          await _db.saveCardImages(
            CardMapper.toDriftCardImages(card.id, card.cardImages),
          );
        }

        if (card.cardPrices.isNotEmpty) {
          await _db.saveCardPrices(
            CardMapper.toDriftCardPrices(card.id, card.cardPrices),
          );
        }

        if (card.cardSets != null && card.cardSets!.isNotEmpty) {
          await _db.saveCardSets(
            CardMapper.toDriftCardSets(card.id, card.cardSets!),
          );
        }

        if (card.banlistInfo != null) {
          final banlist = CardMapper.toDriftBanlistInfo(card.id, card.banlistInfo);
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

    final images = await _db.getCardImagesByCardId(cardId);
    final prices = await _db.getCardPricesByCardId(cardId);
    final sets = await _db.getCardSetsByCardId(cardId);
    final banlistInfo = await _db.getBanlistInfoByCardId(cardId);

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
}