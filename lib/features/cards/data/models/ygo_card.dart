import 'package:freezed_annotation/freezed_annotation.dart';

part 'ygo_card.freezed.dart';
part 'ygo_card.g.dart';

// Prices
@freezed
abstract class CardPrice with _$CardPrice {
  const factory CardPrice({
    @JsonKey(name: 'cardmarket_price') double? cardMarketPrice,
    @JsonKey(name: 'tcgplayer_price') double? tcgPlayerPrice,
    @JsonKey(name: 'ebay_price') double? ebayPrice,
    @JsonKey(name: 'amazon_price') double? amazonPrice,
    @JsonKey(name: 'coolstuffinc_price') double? coolStuffIncPrice,
  }) = _CardPrice;

  factory CardPrice.fromJson(Map<String, dynamic> json) => _$CardPriceFromJson(json);
}

// Images
@freezed
abstract class CardImage with _$CardImage {
  const factory CardImage({
    required int id,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'image_url_small') required String imageUrlSmall,
    @JsonKey(name: 'image_url_cropped') required String imageUrlCropped,
  }) = _CardImage;

  factory CardImage.fromJson(Map<String, dynamic> json) => _$CardImageFromJson(json);
}

// CardSet
@freezed
abstract class CardSet with _$CardSet {
  const factory CardSet({
    @JsonKey(name: 'set_name') required String setName,
    @JsonKey(name: 'set_code') required String setCode,
    @JsonKey(name: 'set_rarity') required String setRarity,
    @JsonKey(name: 'set_rarity_code') required String setRarityCode,
    @JsonKey(name: 'set_price') double? setPrice,
  }) = _CardSet;

  factory CardSet.fromJson(Map<String, dynamic> json) => _$CardSetFromJson(json);
}

// Banlist
@freezed
abstract class BanlistInfo with _$BanlistInfo {
  const factory BanlistInfo({
    @JsonKey(name: 'ban_tcg') String? banTcg,
    @JsonKey(name: 'ban_ocg') String? banOcg,
    @JsonKey(name: 'ban_goat') String? banGoat,
  }) = _BanlistInfo;

  factory BanlistInfo.fromJson(Map<String, dynamic> json) => _$BanlistInfoFromJson(json);
}

// Card
@freezed
abstract class YgoCard with _$YgoCard {
  const factory YgoCard({
    required int id,
    required String name,
    @JsonKey(name: 'typeline') List<String>? typeLine,
    required String type,
    @JsonKey(name: 'humanReadableCardType') String? humanReadableCardType,
    @JsonKey(name: 'frameType') String? frameType,
    required String desc,
    required String race,
    @JsonKey(name: 'pend_desc') String? pendDesc,
    @JsonKey(name: 'monster_desc') String? monsterDesc,
    int? atk,
    int? def,
    int? level,
    String? attribute,
    String? archetype,
    int? scale,
    @JsonKey(name: 'linkval') int? linkVal,
    @JsonKey(name: 'linkmarkers') List<String>? linkMarkers,
    @JsonKey(name: 'ygoprodeck_url') required String ygoProDeckUrl,

    // Now Lists
    @JsonKey(name: 'card_sets') List<CardSet>? cardSets,
    @JsonKey(name: 'banlist_info') BanlistInfo? banlistInfo,
    @JsonKey(name: 'card_images') List<CardImage>? cardImages,
    @JsonKey(name: 'card_prices') List<CardPrice>? cardPrices,
  }) = _YgoCard;

  factory YgoCard.fromJson(Map<String, dynamic> json) => _$YgoCardFromJson(json);
}
