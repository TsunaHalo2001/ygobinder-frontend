import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:ygobinder/core/database/app_database.dart' as drift;
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

class CardMapper {
  // ==========================================
  // YgoCard → Drift Companions (for saving)
  // ==========================================

  static drift.CardsCompanion toDriftCardCompanion(YgoCard card) {
    return drift.CardsCompanion(
      id: Value(card.id),
      name: Value(card.name),
      type: Value(card.type),
      desc: Value(card.desc),
      race: Value(card.race),
      frameType: Value(card.frameType),
      humanReadableCardType: Value(card.humanReadableCardType),
      atk: Value(card.atk),
      def: Value(card.def),
      level: Value(card.level),
      attribute: Value(card.attribute),
      archetype: Value(card.archetype),
      scale: Value(card.scale),
      linkVal: Value(card.linkVal),
      ygoProDeckUrl: Value(card.ygoProDeckUrl),
      pendDesc: Value(card.pendDesc),
      monsterDesc: Value(card.monsterDesc),
      typeLineJson: Value(card.typeLine != null ? jsonEncode(card.typeLine) : null),
      linkMarkersJson: Value(card.linkMarkers != null ? jsonEncode(card.linkMarkers) : null),
      tcgDate: Value(card.miscInfo != null && card.miscInfo!.isNotEmpty 
          ? DateTime.tryParse(card.miscInfo!.first.tcgDate ?? '') 
          : null),
      ocgDate: Value(card.miscInfo != null && card.miscInfo!.isNotEmpty 
          ? DateTime.tryParse(card.miscInfo!.first.ocgDate ?? '') 
          : null),
    );
  }

  static List<drift.CardImagesCompanion> toDriftCardImagesCompanions(
      int cardId,
      List<CardImage> images,
      ) {
    return images
        .map((image) => drift.CardImagesCompanion(
      cardId: Value(cardId),
      imageId: Value(image.id),
      imageUrl: Value(image.imageUrl),
      imageUrlSmall: Value(image.imageUrlSmall),
      imageUrlCropped: Value(image.imageUrlCropped),
    ))
        .toList();
  }

  static List<drift.CardPricesCompanion> toDriftCardPricesCompanions(
      int cardId,
      List<CardPrice> prices,
      ) {
    return prices
        .map((price) => drift.CardPricesCompanion(
      cardId: Value(cardId),
      // Note: Drift uses 'cardmarketPrice', Freezed uses 'cardMarketPrice'
      cardMarketPrice: Value(price.cardMarketPrice),
      tcgPlayerPrice: Value(price.tcgPlayerPrice),
      ebayPrice: Value(price.ebayPrice),
      amazonPrice: Value(price.amazonPrice),
      coolStuffIncPrice: Value(price.coolStuffIncPrice),
    ))
        .toList();
  }

  static List<drift.CardSetsCompanion> toDriftCardSetsCompanions(
      int cardId,
      List<CardSet> sets,
      ) {
    return sets
        .map((set) => drift.CardSetsCompanion(
      cardId: Value(cardId),
      setName: Value(set.setName),
      setCode: Value(set.setCode),
      setRarity: Value(set.setRarity),
      setRarityCode: Value(set.setRarityCode),
      setPrice: Value(set.setPrice),
    ))
        .toList();
  }

  static drift.BanlistInfosCompanion? toDriftBanlistInfoCompanion(
      int cardId,
      BanlistInfo? banlist,
      ) {
    if (banlist == null) return null;

    return drift.BanlistInfosCompanion(
      cardId: Value(cardId),
      banTcg: Value(banlist.banTcg),
      banOcg: Value(banlist.banOcg),
      banGoat: Value(banlist.banGoat),
      banEdison: Value(banlist.banEdison),
    );
  }

  // ==========================================
  // Drift Data Classes → YgoCard (for reading)
  // ==========================================

  static YgoCard toYgoCard(
      drift.DriftCard card, {
        List<drift.DriftCardImage> images = const [],
        List<drift.DriftCardPrice> prices = const [],
        List<drift.DriftCardSet> sets = const [],
        drift.DriftBanlistInfo? banlist,
      }) {
    return YgoCard(
      id: card.id,
      name: card.name,
      type: card.type,
      desc: card.desc,
      race: card.race,
      frameType: card.frameType,
      humanReadableCardType: card.humanReadableCardType,
      atk: card.atk,
      def: card.def,
      level: card.level,
      attribute: card.attribute,
      archetype: card.archetype,
      scale: card.scale,
      linkVal: card.linkVal,
      ygoProDeckUrl: card.ygoProDeckUrl,
      pendDesc: card.pendDesc,
      monsterDesc: card.monsterDesc,
      typeLine: _decodeStringList(card.typeLineJson),
      linkMarkers: _decodeStringList(card.linkMarkersJson),
      cardImages: images.map(_toCardImage).toList(),
      cardPrices: prices.map(_toCardPrice).toList(),
      cardSets: sets.map(_toCardSet).toList(),
      banlistInfo: banlist != null ? _toBanlistInfo(banlist) : null,
      miscInfo: (card.tcgDate != null || card.ocgDate != null)
          ? [
              MiscInfo(
                tcgDate: card.tcgDate?.toIso8601String().split('T').first,
                ocgDate: card.ocgDate?.toIso8601String().split('T').first,
              )
            ]
          : null,
    );
  }

  // ==========================================
  // Private Helpers
  // ==========================================

  static List<String>? _decodeStringList(String? json) {
    if (json == null || json.isEmpty) return null;
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static CardImage _toCardImage(drift.DriftCardImage image) {
    return CardImage(
      id: image.imageId,
      imageUrl: image.imageUrl,
      imageUrlSmall: image.imageUrlSmall,
      imageUrlCropped: image.imageUrlCropped,
    );
  }

  static CardPrice _toCardPrice(drift.DriftCardPrice price) {
    return CardPrice(
      cardMarketPrice: price.cardMarketPrice, // Maps Drift snake_case to Freezed camelCase
      tcgPlayerPrice: price.tcgPlayerPrice,
      ebayPrice: price.ebayPrice,
      amazonPrice: price.amazonPrice,
      coolStuffIncPrice: price.coolStuffIncPrice,
    );
  }

  static CardSet _toCardSet(drift.DriftCardSet set) {
    return CardSet(
      setName: set.setName,
      setCode: set.setCode,
      setRarity: set.setRarity,
      setRarityCode: set.setRarityCode,
      setPrice: set.setPrice,
    );
  }

  static BanlistInfo _toBanlistInfo(drift.DriftBanlistInfo banlist) {
    return BanlistInfo(
      banTcg: banlist.banTcg,
      banOcg: banlist.banOcg,
      banGoat: banlist.banGoat,
      banEdison: banlist.banEdison,
    );
  }
}
