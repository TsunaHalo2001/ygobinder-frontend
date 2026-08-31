import 'package:freezed_annotation/freezed_annotation.dart';

part 'ygo_card.freezed.dart';
part 'ygo_card.g.dart';

// Parse int
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) {
    return value.toInt();
  }
  return null;
}

int _parseRequiredInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  return 0;
}

// Parse double
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

// Prices
@freezed
abstract class CardPrice with _$CardPrice {
  const factory CardPrice({
    @JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) double? cardMarketPrice,
    @JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) double? tcgPlayerPrice,
    @JsonKey(name: 'ebay_price', fromJson: _parseDouble) double? ebayPrice,
    @JsonKey(name: 'amazon_price', fromJson: _parseDouble) double? amazonPrice,
    @JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) double? coolStuffIncPrice,
  }) = _CardPrice;

  factory CardPrice.fromJson(Map<String, dynamic> json) => _$CardPriceFromJson(json);
}

// Images
@freezed
abstract class CardImage with _$CardImage {
  const factory CardImage({
    @JsonKey(fromJson: _parseRequiredInt) required int id,
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
    @JsonKey(name: 'set_price', fromJson: _parseDouble) double? setPrice,
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
    @JsonKey(name: 'ban_edison') String? banEdison, // ✅ Added Edison
  }) = _BanlistInfo;

  factory BanlistInfo.fromJson(Map<String, dynamic> json) => _$BanlistInfoFromJson(json);
}

// Misc Info
@freezed
abstract class MiscInfo with _$MiscInfo {
  const factory MiscInfo({
    @JsonKey(name: 'tcg_date') String? tcgDate,
    @JsonKey(name: 'ocg_date') String? ocgDate,
  }) = _MiscInfo;

  factory MiscInfo.fromJson(Map<String, dynamic> json) => _$MiscInfoFromJson(json);
}

// Card
@freezed
abstract class YgoCard with _$YgoCard {
  const factory YgoCard({
    @JsonKey(fromJson: _parseRequiredInt) required int id,
    required String name,
    @JsonKey(name: 'typeline') List<String>? typeLine,
    required String type,
    @JsonKey(name: 'humanReadableCardType') String? humanReadableCardType,
    @JsonKey(name: 'frameType') String? frameType,
    required String desc,
    required String race,
    @JsonKey(name: 'pend_desc') String? pendDesc,
    @JsonKey(name: 'monster_desc') String? monsterDesc,
    @JsonKey(fromJson: _parseInt) int? atk,
    @JsonKey(fromJson: _parseInt) int? def,
    @JsonKey(fromJson: _parseInt) int? level,
    String? attribute,
    String? archetype,
    @JsonKey(fromJson: _parseInt) int? scale,
    @JsonKey(name: 'linkval') @JsonKey(fromJson: _parseInt) int? linkVal,
    @JsonKey(name: 'linkmarkers') List<String>? linkMarkers,
    @JsonKey(name: 'ygoprodeck_url') required String ygoProDeckUrl,

    // Now Lists
    @JsonKey(name: 'card_sets') List<CardSet>? cardSets,
    @JsonKey(name: 'banlist_info') BanlistInfo? banlistInfo,
    @JsonKey(name: 'card_images') List<CardImage>? cardImages,
    @JsonKey(name: 'card_prices') List<CardPrice>? cardPrices,
    @JsonKey(name: 'misc_info') List<MiscInfo>? miscInfo, // ✅ Added misc_info
  }) = _YgoCard;

  factory YgoCard.fromJson(Map<String, dynamic> json) => _$YgoCardFromJson(json);
}
