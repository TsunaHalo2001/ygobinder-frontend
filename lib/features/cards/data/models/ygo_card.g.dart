// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ygo_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardPrice _$CardPriceFromJson(Map<String, dynamic> json) => _CardPrice(
  cardMarketPrice: (json['cardmarket_price'] as num?)?.toDouble(),
  tcgPlayerPrice: (json['tcgplayer_price'] as num?)?.toDouble(),
  ebayPrice: (json['ebay_price'] as num?)?.toDouble(),
  amazonPrice: (json['amazon_price'] as num?)?.toDouble(),
  coolStuffIncPrice: (json['coolstuffinc_price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CardPriceToJson(_CardPrice instance) =>
    <String, dynamic>{
      'cardmarket_price': instance.cardMarketPrice,
      'tcgplayer_price': instance.tcgPlayerPrice,
      'ebay_price': instance.ebayPrice,
      'amazon_price': instance.amazonPrice,
      'coolstuffinc_price': instance.coolStuffIncPrice,
    };

_CardImage _$CardImageFromJson(Map<String, dynamic> json) => _CardImage(
  id: (json['id'] as num).toInt(),
  imageUrl: json['image_url'] as String,
  imageUrlSmall: json['image_url_small'] as String,
  imageUrlCropped: json['image_url_cropped'] as String,
);

Map<String, dynamic> _$CardImageToJson(_CardImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'image_url_small': instance.imageUrlSmall,
      'image_url_cropped': instance.imageUrlCropped,
    };

_CardSet _$CardSetFromJson(Map<String, dynamic> json) => _CardSet(
  setName: json['set_name'] as String,
  setCode: json['set_code'] as String,
  setRarity: json['set_rarity'] as String,
  setRarityCode: json['set_rarity_code'] as String,
  setPrice: (json['set_price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CardSetToJson(_CardSet instance) => <String, dynamic>{
  'set_name': instance.setName,
  'set_code': instance.setCode,
  'set_rarity': instance.setRarity,
  'set_rarity_code': instance.setRarityCode,
  'set_price': instance.setPrice,
};

_BanlistInfo _$BanlistInfoFromJson(Map<String, dynamic> json) => _BanlistInfo(
  banTcg: json['ban_tcg'] as String?,
  banOcg: json['ban_ocg'] as String?,
  banGoat: json['ban_goat'] as String?,
);

Map<String, dynamic> _$BanlistInfoToJson(_BanlistInfo instance) =>
    <String, dynamic>{
      'ban_tcg': instance.banTcg,
      'ban_ocg': instance.banOcg,
      'ban_goat': instance.banGoat,
    };

_YgoCard _$YgoCardFromJson(Map<String, dynamic> json) => _YgoCard(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  typeLine: (json['typeline'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  type: json['type'] as String,
  humanReadableCardType: json['humanReadableCardType'] as String?,
  frameType: json['frameType'] as String?,
  desc: json['desc'] as String,
  race: json['race'] as String,
  pendDesc: json['pend_desc'] as String?,
  monsterDesc: json['monster_desc'] as String?,
  atk: (json['atk'] as num?)?.toInt(),
  def: (json['def'] as num?)?.toInt(),
  level: (json['level'] as num?)?.toInt(),
  attribute: json['attribute'] as String?,
  archetype: json['archetype'] as String?,
  scale: (json['scale'] as num?)?.toInt(),
  linkVal: (json['linkval'] as num?)?.toInt(),
  linkMarkers: (json['linkmarkers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  ygoProDeckUrl: json['ygoprodeck_url'] as String,
  cardSets: (json['card_sets'] as List<dynamic>?)
      ?.map((e) => CardSet.fromJson(e as Map<String, dynamic>))
      .toList(),
  banlistInfo: json['banlist_info'] == null
      ? null
      : BanlistInfo.fromJson(json['banlist_info'] as Map<String, dynamic>),
  cardImages: (json['card_images'] as List<dynamic>?)
      ?.map((e) => CardImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  cardPrices: (json['card_prices'] as List<dynamic>?)
      ?.map((e) => CardPrice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$YgoCardToJson(_YgoCard instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'typeline': instance.typeLine,
  'type': instance.type,
  'humanReadableCardType': instance.humanReadableCardType,
  'frameType': instance.frameType,
  'desc': instance.desc,
  'race': instance.race,
  'pend_desc': instance.pendDesc,
  'monster_desc': instance.monsterDesc,
  'atk': instance.atk,
  'def': instance.def,
  'level': instance.level,
  'attribute': instance.attribute,
  'archetype': instance.archetype,
  'scale': instance.scale,
  'linkval': instance.linkVal,
  'linkmarkers': instance.linkMarkers,
  'ygoprodeck_url': instance.ygoProDeckUrl,
  'card_sets': instance.cardSets,
  'banlist_info': instance.banlistInfo,
  'card_images': instance.cardImages,
  'card_prices': instance.cardPrices,
};
