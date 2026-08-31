// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ygo_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardPrice _$CardPriceFromJson(Map<String, dynamic> json) => _CardPrice(
  cardMarketPrice: _parseDouble(json['cardmarket_price']),
  tcgPlayerPrice: _parseDouble(json['tcgplayer_price']),
  ebayPrice: _parseDouble(json['ebay_price']),
  amazonPrice: _parseDouble(json['amazon_price']),
  coolStuffIncPrice: _parseDouble(json['coolstuffinc_price']),
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
  id: _parseRequiredInt(json['id']),
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
  setPrice: _parseDouble(json['set_price']),
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
  banEdison: json['ban_edison'] as String?,
);

Map<String, dynamic> _$BanlistInfoToJson(_BanlistInfo instance) =>
    <String, dynamic>{
      'ban_tcg': instance.banTcg,
      'ban_ocg': instance.banOcg,
      'ban_goat': instance.banGoat,
      'ban_edison': instance.banEdison,
    };

_MiscInfo _$MiscInfoFromJson(Map<String, dynamic> json) => _MiscInfo(
  tcgDate: json['tcg_date'] as String?,
  ocgDate: json['ocg_date'] as String?,
);

Map<String, dynamic> _$MiscInfoToJson(_MiscInfo instance) => <String, dynamic>{
  'tcg_date': instance.tcgDate,
  'ocg_date': instance.ocgDate,
};

_YgoCard _$YgoCardFromJson(Map<String, dynamic> json) => _YgoCard(
  id: _parseRequiredInt(json['id']),
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
  atk: _parseInt(json['atk']),
  def: _parseInt(json['def']),
  level: _parseInt(json['level']),
  attribute: json['attribute'] as String?,
  archetype: json['archetype'] as String?,
  scale: _parseInt(json['scale']),
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
  miscInfo: (json['misc_info'] as List<dynamic>?)
      ?.map((e) => MiscInfo.fromJson(e as Map<String, dynamic>))
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
  'misc_info': instance.miscInfo,
};
