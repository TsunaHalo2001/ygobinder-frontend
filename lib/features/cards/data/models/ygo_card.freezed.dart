// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ygo_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardPrice {

@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) double? get cardMarketPrice;@JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) double? get tcgPlayerPrice;@JsonKey(name: 'ebay_price', fromJson: _parseDouble) double? get ebayPrice;@JsonKey(name: 'amazon_price', fromJson: _parseDouble) double? get amazonPrice;@JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) double? get coolStuffIncPrice;
/// Create a copy of CardPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardPriceCopyWith<CardPrice> get copyWith => _$CardPriceCopyWithImpl<CardPrice>(this as CardPrice, _$identity);

  /// Serializes this CardPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardPrice&&(identical(other.cardMarketPrice, _this.cardMarketPrice) || other.cardMarketPrice == _this.cardMarketPrice)&&(identical(other.tcgPlayerPrice, _this.tcgPlayerPrice) || other.tcgPlayerPrice == _this.tcgPlayerPrice)&&(identical(other.ebayPrice, _this.ebayPrice) || other.ebayPrice == _this.ebayPrice)&&(identical(other.amazonPrice, _this.amazonPrice) || other.amazonPrice == _this.amazonPrice)&&(identical(other.coolStuffIncPrice, _this.coolStuffIncPrice) || other.coolStuffIncPrice == _this.coolStuffIncPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardPrice;
  return Object.hash(runtimeType,_this.cardMarketPrice,_this.tcgPlayerPrice,_this.ebayPrice,_this.amazonPrice,_this.coolStuffIncPrice);
}

@override
String toString() {
  final _this = this as CardPrice;
  return 'CardPrice(cardMarketPrice: ${_this.cardMarketPrice}, tcgPlayerPrice: ${_this.tcgPlayerPrice}, ebayPrice: ${_this.ebayPrice}, amazonPrice: ${_this.amazonPrice}, coolStuffIncPrice: ${_this.coolStuffIncPrice})';
}


}

/// @nodoc
abstract mixin class $CardPriceCopyWith<$Res>  {
  factory $CardPriceCopyWith(CardPrice value, $Res Function(CardPrice) _then) = _$CardPriceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) double? cardMarketPrice,@JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) double? tcgPlayerPrice,@JsonKey(name: 'ebay_price', fromJson: _parseDouble) double? ebayPrice,@JsonKey(name: 'amazon_price', fromJson: _parseDouble) double? amazonPrice,@JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) double? coolStuffIncPrice
});




}
/// @nodoc
class _$CardPriceCopyWithImpl<$Res>
    implements $CardPriceCopyWith<$Res> {
  _$CardPriceCopyWithImpl(this._self, this._then);

  final CardPrice _self;
  final $Res Function(CardPrice) _then;

/// Create a copy of CardPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardMarketPrice = freezed,Object? tcgPlayerPrice = freezed,Object? ebayPrice = freezed,Object? amazonPrice = freezed,Object? coolStuffIncPrice = freezed,}) {
  return _then(CardPrice(
cardMarketPrice: freezed == cardMarketPrice ? _self.cardMarketPrice : cardMarketPrice // ignore: cast_nullable_to_non_nullable
as double?,tcgPlayerPrice: freezed == tcgPlayerPrice ? _self.tcgPlayerPrice : tcgPlayerPrice // ignore: cast_nullable_to_non_nullable
as double?,ebayPrice: freezed == ebayPrice ? _self.ebayPrice : ebayPrice // ignore: cast_nullable_to_non_nullable
as double?,amazonPrice: freezed == amazonPrice ? _self.amazonPrice : amazonPrice // ignore: cast_nullable_to_non_nullable
as double?,coolStuffIncPrice: freezed == coolStuffIncPrice ? _self.coolStuffIncPrice : coolStuffIncPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardPrice].
extension CardPricePatterns on CardPrice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardPrice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardPrice value)  $default,){
final _that = this;
switch (_that) {
case _CardPrice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardPrice value)?  $default,){
final _that = this;
switch (_that) {
case _CardPrice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble)  double? cardMarketPrice, @JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble)  double? tcgPlayerPrice, @JsonKey(name: 'ebay_price', fromJson: _parseDouble)  double? ebayPrice, @JsonKey(name: 'amazon_price', fromJson: _parseDouble)  double? amazonPrice, @JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble)  double? coolStuffIncPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardPrice() when $default != null:
return $default(_that.cardMarketPrice,_that.tcgPlayerPrice,_that.ebayPrice,_that.amazonPrice,_that.coolStuffIncPrice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble)  double? cardMarketPrice, @JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble)  double? tcgPlayerPrice, @JsonKey(name: 'ebay_price', fromJson: _parseDouble)  double? ebayPrice, @JsonKey(name: 'amazon_price', fromJson: _parseDouble)  double? amazonPrice, @JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble)  double? coolStuffIncPrice)  $default,) {final _that = this;
switch (_that) {
case _CardPrice():
return $default(_that.cardMarketPrice,_that.tcgPlayerPrice,_that.ebayPrice,_that.amazonPrice,_that.coolStuffIncPrice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble)  double? cardMarketPrice, @JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble)  double? tcgPlayerPrice, @JsonKey(name: 'ebay_price', fromJson: _parseDouble)  double? ebayPrice, @JsonKey(name: 'amazon_price', fromJson: _parseDouble)  double? amazonPrice, @JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble)  double? coolStuffIncPrice)?  $default,) {final _that = this;
switch (_that) {
case _CardPrice() when $default != null:
return $default(_that.cardMarketPrice,_that.tcgPlayerPrice,_that.ebayPrice,_that.amazonPrice,_that.coolStuffIncPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardPrice implements CardPrice {
  const _CardPrice({@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) this.cardMarketPrice, @JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) this.tcgPlayerPrice, @JsonKey(name: 'ebay_price', fromJson: _parseDouble) this.ebayPrice, @JsonKey(name: 'amazon_price', fromJson: _parseDouble) this.amazonPrice, @JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) this.coolStuffIncPrice});
  factory _CardPrice.fromJson(Map<String, dynamic> json) => _$CardPriceFromJson(json);

@override@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) final  double? cardMarketPrice;
@override@JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) final  double? tcgPlayerPrice;
@override@JsonKey(name: 'ebay_price', fromJson: _parseDouble) final  double? ebayPrice;
@override@JsonKey(name: 'amazon_price', fromJson: _parseDouble) final  double? amazonPrice;
@override@JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) final  double? coolStuffIncPrice;

/// Create a copy of CardPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardPriceCopyWith<_CardPrice> get copyWith => __$CardPriceCopyWithImpl<_CardPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardPriceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardPrice&&(identical(other.cardMarketPrice, cardMarketPrice) || other.cardMarketPrice == cardMarketPrice)&&(identical(other.tcgPlayerPrice, tcgPlayerPrice) || other.tcgPlayerPrice == tcgPlayerPrice)&&(identical(other.ebayPrice, ebayPrice) || other.ebayPrice == ebayPrice)&&(identical(other.amazonPrice, amazonPrice) || other.amazonPrice == amazonPrice)&&(identical(other.coolStuffIncPrice, coolStuffIncPrice) || other.coolStuffIncPrice == coolStuffIncPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cardMarketPrice,tcgPlayerPrice,ebayPrice,amazonPrice,coolStuffIncPrice);
}

@override
String toString() {
    return 'CardPrice(cardMarketPrice: $cardMarketPrice, tcgPlayerPrice: $tcgPlayerPrice, ebayPrice: $ebayPrice, amazonPrice: $amazonPrice, coolStuffIncPrice: $coolStuffIncPrice)';
}


}

/// @nodoc
abstract mixin class _$CardPriceCopyWith<$Res> implements $CardPriceCopyWith<$Res> {
  factory _$CardPriceCopyWith(_CardPrice value, $Res Function(_CardPrice) _then) = __$CardPriceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'cardmarket_price', fromJson: _parseDouble) double? cardMarketPrice,@JsonKey(name: 'tcgplayer_price', fromJson: _parseDouble) double? tcgPlayerPrice,@JsonKey(name: 'ebay_price', fromJson: _parseDouble) double? ebayPrice,@JsonKey(name: 'amazon_price', fromJson: _parseDouble) double? amazonPrice,@JsonKey(name: 'coolstuffinc_price', fromJson: _parseDouble) double? coolStuffIncPrice
});




}
/// @nodoc
class __$CardPriceCopyWithImpl<$Res>
    implements _$CardPriceCopyWith<$Res> {
  __$CardPriceCopyWithImpl(this._self, this._then);

  final _CardPrice _self;
  final $Res Function(_CardPrice) _then;

/// Create a copy of CardPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardMarketPrice = freezed,Object? tcgPlayerPrice = freezed,Object? ebayPrice = freezed,Object? amazonPrice = freezed,Object? coolStuffIncPrice = freezed,}) {
  return _then(_CardPrice(
cardMarketPrice: freezed == cardMarketPrice ? _self.cardMarketPrice : cardMarketPrice // ignore: cast_nullable_to_non_nullable
as double?,tcgPlayerPrice: freezed == tcgPlayerPrice ? _self.tcgPlayerPrice : tcgPlayerPrice // ignore: cast_nullable_to_non_nullable
as double?,ebayPrice: freezed == ebayPrice ? _self.ebayPrice : ebayPrice // ignore: cast_nullable_to_non_nullable
as double?,amazonPrice: freezed == amazonPrice ? _self.amazonPrice : amazonPrice // ignore: cast_nullable_to_non_nullable
as double?,coolStuffIncPrice: freezed == coolStuffIncPrice ? _self.coolStuffIncPrice : coolStuffIncPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$CardImage {

@JsonKey(fromJson: _parseRequiredInt) int get id;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'image_url_small') String get imageUrlSmall;@JsonKey(name: 'image_url_cropped') String get imageUrlCropped;
/// Create a copy of CardImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardImageCopyWith<CardImage> get copyWith => _$CardImageCopyWithImpl<CardImage>(this as CardImage, _$identity);

  /// Serializes this CardImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardImage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardImage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.imageUrlSmall, _this.imageUrlSmall) || other.imageUrlSmall == _this.imageUrlSmall)&&(identical(other.imageUrlCropped, _this.imageUrlCropped) || other.imageUrlCropped == _this.imageUrlCropped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardImage;
  return Object.hash(runtimeType,_this.id,_this.imageUrl,_this.imageUrlSmall,_this.imageUrlCropped);
}

@override
String toString() {
  final _this = this as CardImage;
  return 'CardImage(id: ${_this.id}, imageUrl: ${_this.imageUrl}, imageUrlSmall: ${_this.imageUrlSmall}, imageUrlCropped: ${_this.imageUrlCropped})';
}


}

/// @nodoc
abstract mixin class $CardImageCopyWith<$Res>  {
  factory $CardImageCopyWith(CardImage value, $Res Function(CardImage) _then) = _$CardImageCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _parseRequiredInt) int id,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'image_url_small') String imageUrlSmall,@JsonKey(name: 'image_url_cropped') String imageUrlCropped
});




}
/// @nodoc
class _$CardImageCopyWithImpl<$Res>
    implements $CardImageCopyWith<$Res> {
  _$CardImageCopyWithImpl(this._self, this._then);

  final CardImage _self;
  final $Res Function(CardImage) _then;

/// Create a copy of CardImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageUrl = null,Object? imageUrlSmall = null,Object? imageUrlCropped = null,}) {
  return _then(CardImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrlSmall: null == imageUrlSmall ? _self.imageUrlSmall : imageUrlSmall // ignore: cast_nullable_to_non_nullable
as String,imageUrlCropped: null == imageUrlCropped ? _self.imageUrlCropped : imageUrlCropped // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CardImage].
extension CardImagePatterns on CardImage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardImage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardImage value)  $default,){
final _that = this;
switch (_that) {
case _CardImage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardImage value)?  $default,){
final _that = this;
switch (_that) {
case _CardImage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseRequiredInt)  int id, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'image_url_small')  String imageUrlSmall, @JsonKey(name: 'image_url_cropped')  String imageUrlCropped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardImage() when $default != null:
return $default(_that.id,_that.imageUrl,_that.imageUrlSmall,_that.imageUrlCropped);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseRequiredInt)  int id, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'image_url_small')  String imageUrlSmall, @JsonKey(name: 'image_url_cropped')  String imageUrlCropped)  $default,) {final _that = this;
switch (_that) {
case _CardImage():
return $default(_that.id,_that.imageUrl,_that.imageUrlSmall,_that.imageUrlCropped);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _parseRequiredInt)  int id, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'image_url_small')  String imageUrlSmall, @JsonKey(name: 'image_url_cropped')  String imageUrlCropped)?  $default,) {final _that = this;
switch (_that) {
case _CardImage() when $default != null:
return $default(_that.id,_that.imageUrl,_that.imageUrlSmall,_that.imageUrlCropped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardImage implements CardImage {
  const _CardImage({@JsonKey(fromJson: _parseRequiredInt) required this.id, @JsonKey(name: 'image_url') required this.imageUrl, @JsonKey(name: 'image_url_small') required this.imageUrlSmall, @JsonKey(name: 'image_url_cropped') required this.imageUrlCropped});
  factory _CardImage.fromJson(Map<String, dynamic> json) => _$CardImageFromJson(json);

@override@JsonKey(fromJson: _parseRequiredInt) final  int id;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'image_url_small') final  String imageUrlSmall;
@override@JsonKey(name: 'image_url_cropped') final  String imageUrlCropped;

/// Create a copy of CardImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardImageCopyWith<_CardImage> get copyWith => __$CardImageCopyWithImpl<_CardImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardImageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardImage&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUrlSmall, imageUrlSmall) || other.imageUrlSmall == imageUrlSmall)&&(identical(other.imageUrlCropped, imageUrlCropped) || other.imageUrlCropped == imageUrlCropped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,imageUrl,imageUrlSmall,imageUrlCropped);
}

@override
String toString() {
    return 'CardImage(id: $id, imageUrl: $imageUrl, imageUrlSmall: $imageUrlSmall, imageUrlCropped: $imageUrlCropped)';
}


}

/// @nodoc
abstract mixin class _$CardImageCopyWith<$Res> implements $CardImageCopyWith<$Res> {
  factory _$CardImageCopyWith(_CardImage value, $Res Function(_CardImage) _then) = __$CardImageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _parseRequiredInt) int id,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'image_url_small') String imageUrlSmall,@JsonKey(name: 'image_url_cropped') String imageUrlCropped
});




}
/// @nodoc
class __$CardImageCopyWithImpl<$Res>
    implements _$CardImageCopyWith<$Res> {
  __$CardImageCopyWithImpl(this._self, this._then);

  final _CardImage _self;
  final $Res Function(_CardImage) _then;

/// Create a copy of CardImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageUrl = null,Object? imageUrlSmall = null,Object? imageUrlCropped = null,}) {
  return _then(_CardImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrlSmall: null == imageUrlSmall ? _self.imageUrlSmall : imageUrlSmall // ignore: cast_nullable_to_non_nullable
as String,imageUrlCropped: null == imageUrlCropped ? _self.imageUrlCropped : imageUrlCropped // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CardSet {

@JsonKey(name: 'set_name') String get setName;@JsonKey(name: 'set_code') String get setCode;@JsonKey(name: 'set_rarity') String get setRarity;@JsonKey(name: 'set_rarity_code') String get setRarityCode;@JsonKey(name: 'set_price', fromJson: _parseDouble) double? get setPrice;
/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardSetCopyWith<CardSet> get copyWith => _$CardSetCopyWithImpl<CardSet>(this as CardSet, _$identity);

  /// Serializes this CardSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardSet&&(identical(other.setName, _this.setName) || other.setName == _this.setName)&&(identical(other.setCode, _this.setCode) || other.setCode == _this.setCode)&&(identical(other.setRarity, _this.setRarity) || other.setRarity == _this.setRarity)&&(identical(other.setRarityCode, _this.setRarityCode) || other.setRarityCode == _this.setRarityCode)&&(identical(other.setPrice, _this.setPrice) || other.setPrice == _this.setPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardSet;
  return Object.hash(runtimeType,_this.setName,_this.setCode,_this.setRarity,_this.setRarityCode,_this.setPrice);
}

@override
String toString() {
  final _this = this as CardSet;
  return 'CardSet(setName: ${_this.setName}, setCode: ${_this.setCode}, setRarity: ${_this.setRarity}, setRarityCode: ${_this.setRarityCode}, setPrice: ${_this.setPrice})';
}


}

/// @nodoc
abstract mixin class $CardSetCopyWith<$Res>  {
  factory $CardSetCopyWith(CardSet value, $Res Function(CardSet) _then) = _$CardSetCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'set_name') String setName,@JsonKey(name: 'set_code') String setCode,@JsonKey(name: 'set_rarity') String setRarity,@JsonKey(name: 'set_rarity_code') String setRarityCode,@JsonKey(name: 'set_price', fromJson: _parseDouble) double? setPrice
});




}
/// @nodoc
class _$CardSetCopyWithImpl<$Res>
    implements $CardSetCopyWith<$Res> {
  _$CardSetCopyWithImpl(this._self, this._then);

  final CardSet _self;
  final $Res Function(CardSet) _then;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setName = null,Object? setCode = null,Object? setRarity = null,Object? setRarityCode = null,Object? setPrice = freezed,}) {
  return _then(CardSet(
setName: null == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String,setCode: null == setCode ? _self.setCode : setCode // ignore: cast_nullable_to_non_nullable
as String,setRarity: null == setRarity ? _self.setRarity : setRarity // ignore: cast_nullable_to_non_nullable
as String,setRarityCode: null == setRarityCode ? _self.setRarityCode : setRarityCode // ignore: cast_nullable_to_non_nullable
as String,setPrice: freezed == setPrice ? _self.setPrice : setPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardSet].
extension CardSetPatterns on CardSet {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardSet value)  $default,){
final _that = this;
switch (_that) {
case _CardSet():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardSet value)?  $default,){
final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'set_name')  String setName, @JsonKey(name: 'set_code')  String setCode, @JsonKey(name: 'set_rarity')  String setRarity, @JsonKey(name: 'set_rarity_code')  String setRarityCode, @JsonKey(name: 'set_price', fromJson: _parseDouble)  double? setPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that.setName,_that.setCode,_that.setRarity,_that.setRarityCode,_that.setPrice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'set_name')  String setName, @JsonKey(name: 'set_code')  String setCode, @JsonKey(name: 'set_rarity')  String setRarity, @JsonKey(name: 'set_rarity_code')  String setRarityCode, @JsonKey(name: 'set_price', fromJson: _parseDouble)  double? setPrice)  $default,) {final _that = this;
switch (_that) {
case _CardSet():
return $default(_that.setName,_that.setCode,_that.setRarity,_that.setRarityCode,_that.setPrice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'set_name')  String setName, @JsonKey(name: 'set_code')  String setCode, @JsonKey(name: 'set_rarity')  String setRarity, @JsonKey(name: 'set_rarity_code')  String setRarityCode, @JsonKey(name: 'set_price', fromJson: _parseDouble)  double? setPrice)?  $default,) {final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that.setName,_that.setCode,_that.setRarity,_that.setRarityCode,_that.setPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardSet implements CardSet {
  const _CardSet({@JsonKey(name: 'set_name') required this.setName, @JsonKey(name: 'set_code') required this.setCode, @JsonKey(name: 'set_rarity') required this.setRarity, @JsonKey(name: 'set_rarity_code') required this.setRarityCode, @JsonKey(name: 'set_price', fromJson: _parseDouble) this.setPrice});
  factory _CardSet.fromJson(Map<String, dynamic> json) => _$CardSetFromJson(json);

@override@JsonKey(name: 'set_name') final  String setName;
@override@JsonKey(name: 'set_code') final  String setCode;
@override@JsonKey(name: 'set_rarity') final  String setRarity;
@override@JsonKey(name: 'set_rarity_code') final  String setRarityCode;
@override@JsonKey(name: 'set_price', fromJson: _parseDouble) final  double? setPrice;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardSetCopyWith<_CardSet> get copyWith => __$CardSetCopyWithImpl<_CardSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardSet&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.setCode, setCode) || other.setCode == setCode)&&(identical(other.setRarity, setRarity) || other.setRarity == setRarity)&&(identical(other.setRarityCode, setRarityCode) || other.setRarityCode == setRarityCode)&&(identical(other.setPrice, setPrice) || other.setPrice == setPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,setName,setCode,setRarity,setRarityCode,setPrice);
}

@override
String toString() {
    return 'CardSet(setName: $setName, setCode: $setCode, setRarity: $setRarity, setRarityCode: $setRarityCode, setPrice: $setPrice)';
}


}

/// @nodoc
abstract mixin class _$CardSetCopyWith<$Res> implements $CardSetCopyWith<$Res> {
  factory _$CardSetCopyWith(_CardSet value, $Res Function(_CardSet) _then) = __$CardSetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'set_name') String setName,@JsonKey(name: 'set_code') String setCode,@JsonKey(name: 'set_rarity') String setRarity,@JsonKey(name: 'set_rarity_code') String setRarityCode,@JsonKey(name: 'set_price', fromJson: _parseDouble) double? setPrice
});




}
/// @nodoc
class __$CardSetCopyWithImpl<$Res>
    implements _$CardSetCopyWith<$Res> {
  __$CardSetCopyWithImpl(this._self, this._then);

  final _CardSet _self;
  final $Res Function(_CardSet) _then;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setName = null,Object? setCode = null,Object? setRarity = null,Object? setRarityCode = null,Object? setPrice = freezed,}) {
  return _then(_CardSet(
setName: null == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String,setCode: null == setCode ? _self.setCode : setCode // ignore: cast_nullable_to_non_nullable
as String,setRarity: null == setRarity ? _self.setRarity : setRarity // ignore: cast_nullable_to_non_nullable
as String,setRarityCode: null == setRarityCode ? _self.setRarityCode : setRarityCode // ignore: cast_nullable_to_non_nullable
as String,setPrice: freezed == setPrice ? _self.setPrice : setPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$BanlistInfo {

@JsonKey(name: 'ban_tcg') String? get banTcg;@JsonKey(name: 'ban_ocg') String? get banOcg;@JsonKey(name: 'ban_goat') String? get banGoat;@JsonKey(name: 'ban_edison') String? get banEdison;
/// Create a copy of BanlistInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BanlistInfoCopyWith<BanlistInfo> get copyWith => _$BanlistInfoCopyWithImpl<BanlistInfo>(this as BanlistInfo, _$identity);

  /// Serializes this BanlistInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BanlistInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BanlistInfo&&(identical(other.banTcg, _this.banTcg) || other.banTcg == _this.banTcg)&&(identical(other.banOcg, _this.banOcg) || other.banOcg == _this.banOcg)&&(identical(other.banGoat, _this.banGoat) || other.banGoat == _this.banGoat)&&(identical(other.banEdison, _this.banEdison) || other.banEdison == _this.banEdison));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BanlistInfo;
  return Object.hash(runtimeType,_this.banTcg,_this.banOcg,_this.banGoat,_this.banEdison);
}

@override
String toString() {
  final _this = this as BanlistInfo;
  return 'BanlistInfo(banTcg: ${_this.banTcg}, banOcg: ${_this.banOcg}, banGoat: ${_this.banGoat}, banEdison: ${_this.banEdison})';
}


}

/// @nodoc
abstract mixin class $BanlistInfoCopyWith<$Res>  {
  factory $BanlistInfoCopyWith(BanlistInfo value, $Res Function(BanlistInfo) _then) = _$BanlistInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ban_tcg') String? banTcg,@JsonKey(name: 'ban_ocg') String? banOcg,@JsonKey(name: 'ban_goat') String? banGoat,@JsonKey(name: 'ban_edison') String? banEdison
});




}
/// @nodoc
class _$BanlistInfoCopyWithImpl<$Res>
    implements $BanlistInfoCopyWith<$Res> {
  _$BanlistInfoCopyWithImpl(this._self, this._then);

  final BanlistInfo _self;
  final $Res Function(BanlistInfo) _then;

/// Create a copy of BanlistInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banTcg = freezed,Object? banOcg = freezed,Object? banGoat = freezed,Object? banEdison = freezed,}) {
  return _then(BanlistInfo(
banTcg: freezed == banTcg ? _self.banTcg : banTcg // ignore: cast_nullable_to_non_nullable
as String?,banOcg: freezed == banOcg ? _self.banOcg : banOcg // ignore: cast_nullable_to_non_nullable
as String?,banGoat: freezed == banGoat ? _self.banGoat : banGoat // ignore: cast_nullable_to_non_nullable
as String?,banEdison: freezed == banEdison ? _self.banEdison : banEdison // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BanlistInfo].
extension BanlistInfoPatterns on BanlistInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BanlistInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BanlistInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BanlistInfo value)  $default,){
final _that = this;
switch (_that) {
case _BanlistInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BanlistInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BanlistInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ban_tcg')  String? banTcg, @JsonKey(name: 'ban_ocg')  String? banOcg, @JsonKey(name: 'ban_goat')  String? banGoat, @JsonKey(name: 'ban_edison')  String? banEdison)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BanlistInfo() when $default != null:
return $default(_that.banTcg,_that.banOcg,_that.banGoat,_that.banEdison);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ban_tcg')  String? banTcg, @JsonKey(name: 'ban_ocg')  String? banOcg, @JsonKey(name: 'ban_goat')  String? banGoat, @JsonKey(name: 'ban_edison')  String? banEdison)  $default,) {final _that = this;
switch (_that) {
case _BanlistInfo():
return $default(_that.banTcg,_that.banOcg,_that.banGoat,_that.banEdison);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ban_tcg')  String? banTcg, @JsonKey(name: 'ban_ocg')  String? banOcg, @JsonKey(name: 'ban_goat')  String? banGoat, @JsonKey(name: 'ban_edison')  String? banEdison)?  $default,) {final _that = this;
switch (_that) {
case _BanlistInfo() when $default != null:
return $default(_that.banTcg,_that.banOcg,_that.banGoat,_that.banEdison);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BanlistInfo implements BanlistInfo {
  const _BanlistInfo({@JsonKey(name: 'ban_tcg') this.banTcg, @JsonKey(name: 'ban_ocg') this.banOcg, @JsonKey(name: 'ban_goat') this.banGoat, @JsonKey(name: 'ban_edison') this.banEdison});
  factory _BanlistInfo.fromJson(Map<String, dynamic> json) => _$BanlistInfoFromJson(json);

@override@JsonKey(name: 'ban_tcg') final  String? banTcg;
@override@JsonKey(name: 'ban_ocg') final  String? banOcg;
@override@JsonKey(name: 'ban_goat') final  String? banGoat;
@override@JsonKey(name: 'ban_edison') final  String? banEdison;

/// Create a copy of BanlistInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BanlistInfoCopyWith<_BanlistInfo> get copyWith => __$BanlistInfoCopyWithImpl<_BanlistInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BanlistInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BanlistInfo&&(identical(other.banTcg, banTcg) || other.banTcg == banTcg)&&(identical(other.banOcg, banOcg) || other.banOcg == banOcg)&&(identical(other.banGoat, banGoat) || other.banGoat == banGoat)&&(identical(other.banEdison, banEdison) || other.banEdison == banEdison));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,banTcg,banOcg,banGoat,banEdison);
}

@override
String toString() {
    return 'BanlistInfo(banTcg: $banTcg, banOcg: $banOcg, banGoat: $banGoat, banEdison: $banEdison)';
}


}

/// @nodoc
abstract mixin class _$BanlistInfoCopyWith<$Res> implements $BanlistInfoCopyWith<$Res> {
  factory _$BanlistInfoCopyWith(_BanlistInfo value, $Res Function(_BanlistInfo) _then) = __$BanlistInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ban_tcg') String? banTcg,@JsonKey(name: 'ban_ocg') String? banOcg,@JsonKey(name: 'ban_goat') String? banGoat,@JsonKey(name: 'ban_edison') String? banEdison
});




}
/// @nodoc
class __$BanlistInfoCopyWithImpl<$Res>
    implements _$BanlistInfoCopyWith<$Res> {
  __$BanlistInfoCopyWithImpl(this._self, this._then);

  final _BanlistInfo _self;
  final $Res Function(_BanlistInfo) _then;

/// Create a copy of BanlistInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banTcg = freezed,Object? banOcg = freezed,Object? banGoat = freezed,Object? banEdison = freezed,}) {
  return _then(_BanlistInfo(
banTcg: freezed == banTcg ? _self.banTcg : banTcg // ignore: cast_nullable_to_non_nullable
as String?,banOcg: freezed == banOcg ? _self.banOcg : banOcg // ignore: cast_nullable_to_non_nullable
as String?,banGoat: freezed == banGoat ? _self.banGoat : banGoat // ignore: cast_nullable_to_non_nullable
as String?,banEdison: freezed == banEdison ? _self.banEdison : banEdison // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MiscInfo {

@JsonKey(name: 'tcg_date') String? get tcgDate;@JsonKey(name: 'ocg_date') String? get ocgDate;
/// Create a copy of MiscInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiscInfoCopyWith<MiscInfo> get copyWith => _$MiscInfoCopyWithImpl<MiscInfo>(this as MiscInfo, _$identity);

  /// Serializes this MiscInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MiscInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiscInfo&&(identical(other.tcgDate, _this.tcgDate) || other.tcgDate == _this.tcgDate)&&(identical(other.ocgDate, _this.ocgDate) || other.ocgDate == _this.ocgDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MiscInfo;
  return Object.hash(runtimeType,_this.tcgDate,_this.ocgDate);
}

@override
String toString() {
  final _this = this as MiscInfo;
  return 'MiscInfo(tcgDate: ${_this.tcgDate}, ocgDate: ${_this.ocgDate})';
}


}

/// @nodoc
abstract mixin class $MiscInfoCopyWith<$Res>  {
  factory $MiscInfoCopyWith(MiscInfo value, $Res Function(MiscInfo) _then) = _$MiscInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tcg_date') String? tcgDate,@JsonKey(name: 'ocg_date') String? ocgDate
});




}
/// @nodoc
class _$MiscInfoCopyWithImpl<$Res>
    implements $MiscInfoCopyWith<$Res> {
  _$MiscInfoCopyWithImpl(this._self, this._then);

  final MiscInfo _self;
  final $Res Function(MiscInfo) _then;

/// Create a copy of MiscInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tcgDate = freezed,Object? ocgDate = freezed,}) {
  return _then(MiscInfo(
tcgDate: freezed == tcgDate ? _self.tcgDate : tcgDate // ignore: cast_nullable_to_non_nullable
as String?,ocgDate: freezed == ocgDate ? _self.ocgDate : ocgDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiscInfo].
extension MiscInfoPatterns on MiscInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiscInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiscInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiscInfo value)  $default,){
final _that = this;
switch (_that) {
case _MiscInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiscInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MiscInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tcg_date')  String? tcgDate, @JsonKey(name: 'ocg_date')  String? ocgDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiscInfo() when $default != null:
return $default(_that.tcgDate,_that.ocgDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tcg_date')  String? tcgDate, @JsonKey(name: 'ocg_date')  String? ocgDate)  $default,) {final _that = this;
switch (_that) {
case _MiscInfo():
return $default(_that.tcgDate,_that.ocgDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tcg_date')  String? tcgDate, @JsonKey(name: 'ocg_date')  String? ocgDate)?  $default,) {final _that = this;
switch (_that) {
case _MiscInfo() when $default != null:
return $default(_that.tcgDate,_that.ocgDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiscInfo implements MiscInfo {
  const _MiscInfo({@JsonKey(name: 'tcg_date') this.tcgDate, @JsonKey(name: 'ocg_date') this.ocgDate});
  factory _MiscInfo.fromJson(Map<String, dynamic> json) => _$MiscInfoFromJson(json);

@override@JsonKey(name: 'tcg_date') final  String? tcgDate;
@override@JsonKey(name: 'ocg_date') final  String? ocgDate;

/// Create a copy of MiscInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiscInfoCopyWith<_MiscInfo> get copyWith => __$MiscInfoCopyWithImpl<_MiscInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiscInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiscInfo&&(identical(other.tcgDate, tcgDate) || other.tcgDate == tcgDate)&&(identical(other.ocgDate, ocgDate) || other.ocgDate == ocgDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tcgDate,ocgDate);
}

@override
String toString() {
    return 'MiscInfo(tcgDate: $tcgDate, ocgDate: $ocgDate)';
}


}

/// @nodoc
abstract mixin class _$MiscInfoCopyWith<$Res> implements $MiscInfoCopyWith<$Res> {
  factory _$MiscInfoCopyWith(_MiscInfo value, $Res Function(_MiscInfo) _then) = __$MiscInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tcg_date') String? tcgDate,@JsonKey(name: 'ocg_date') String? ocgDate
});




}
/// @nodoc
class __$MiscInfoCopyWithImpl<$Res>
    implements _$MiscInfoCopyWith<$Res> {
  __$MiscInfoCopyWithImpl(this._self, this._then);

  final _MiscInfo _self;
  final $Res Function(_MiscInfo) _then;

/// Create a copy of MiscInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tcgDate = freezed,Object? ocgDate = freezed,}) {
  return _then(_MiscInfo(
tcgDate: freezed == tcgDate ? _self.tcgDate : tcgDate // ignore: cast_nullable_to_non_nullable
as String?,ocgDate: freezed == ocgDate ? _self.ocgDate : ocgDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$YgoCard {

@JsonKey(fromJson: _parseRequiredInt) int get id; String get name;@JsonKey(name: 'typeline') List<String>? get typeLine; String get type;@JsonKey(name: 'humanReadableCardType') String? get humanReadableCardType;@JsonKey(name: 'frameType') String? get frameType; String get desc; String get race;@JsonKey(name: 'pend_desc') String? get pendDesc;@JsonKey(name: 'monster_desc') String? get monsterDesc;@JsonKey(fromJson: _parseInt) int? get atk;@JsonKey(fromJson: _parseInt) int? get def;@JsonKey(fromJson: _parseInt) int? get level; String? get attribute; String? get archetype;@JsonKey(fromJson: _parseInt) int? get scale;@JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt) int? get linkVal;@JsonKey(name: 'linkmarkers') List<String>? get linkMarkers;@JsonKey(name: 'ygoprodeck_url') String get ygoProDeckUrl;@JsonKey(name: 'card_sets') List<CardSet>? get cardSets;@JsonKey(name: 'banlist_info') BanlistInfo? get banlistInfo;@JsonKey(name: 'card_images') List<CardImage>? get cardImages;@JsonKey(name: 'card_prices') List<CardPrice>? get cardPrices;@JsonKey(name: 'misc_info') List<MiscInfo>? get miscInfo;
/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YgoCardCopyWith<YgoCard> get copyWith => _$YgoCardCopyWithImpl<YgoCard>(this as YgoCard, _$identity);

  /// Serializes this YgoCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as YgoCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YgoCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.typeLine, _this.typeLine)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.humanReadableCardType, _this.humanReadableCardType) || other.humanReadableCardType == _this.humanReadableCardType)&&(identical(other.frameType, _this.frameType) || other.frameType == _this.frameType)&&(identical(other.desc, _this.desc) || other.desc == _this.desc)&&(identical(other.race, _this.race) || other.race == _this.race)&&(identical(other.pendDesc, _this.pendDesc) || other.pendDesc == _this.pendDesc)&&(identical(other.monsterDesc, _this.monsterDesc) || other.monsterDesc == _this.monsterDesc)&&(identical(other.atk, _this.atk) || other.atk == _this.atk)&&(identical(other.def, _this.def) || other.def == _this.def)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.attribute, _this.attribute) || other.attribute == _this.attribute)&&(identical(other.archetype, _this.archetype) || other.archetype == _this.archetype)&&(identical(other.scale, _this.scale) || other.scale == _this.scale)&&(identical(other.linkVal, _this.linkVal) || other.linkVal == _this.linkVal)&&const DeepCollectionEquality().equals(other.linkMarkers, _this.linkMarkers)&&(identical(other.ygoProDeckUrl, _this.ygoProDeckUrl) || other.ygoProDeckUrl == _this.ygoProDeckUrl)&&const DeepCollectionEquality().equals(other.cardSets, _this.cardSets)&&(identical(other.banlistInfo, _this.banlistInfo) || other.banlistInfo == _this.banlistInfo)&&const DeepCollectionEquality().equals(other.cardImages, _this.cardImages)&&const DeepCollectionEquality().equals(other.cardPrices, _this.cardPrices)&&const DeepCollectionEquality().equals(other.miscInfo, _this.miscInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as YgoCard;
  return Object.hashAll([runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.typeLine),_this.type,_this.humanReadableCardType,_this.frameType,_this.desc,_this.race,_this.pendDesc,_this.monsterDesc,_this.atk,_this.def,_this.level,_this.attribute,_this.archetype,_this.scale,_this.linkVal,const DeepCollectionEquality().hash(_this.linkMarkers),_this.ygoProDeckUrl,const DeepCollectionEquality().hash(_this.cardSets),_this.banlistInfo,const DeepCollectionEquality().hash(_this.cardImages),const DeepCollectionEquality().hash(_this.cardPrices),const DeepCollectionEquality().hash(_this.miscInfo)]);
}

@override
String toString() {
  final _this = this as YgoCard;
  return 'YgoCard(id: ${_this.id}, name: ${_this.name}, typeLine: ${_this.typeLine}, type: ${_this.type}, humanReadableCardType: ${_this.humanReadableCardType}, frameType: ${_this.frameType}, desc: ${_this.desc}, race: ${_this.race}, pendDesc: ${_this.pendDesc}, monsterDesc: ${_this.monsterDesc}, atk: ${_this.atk}, def: ${_this.def}, level: ${_this.level}, attribute: ${_this.attribute}, archetype: ${_this.archetype}, scale: ${_this.scale}, linkVal: ${_this.linkVal}, linkMarkers: ${_this.linkMarkers}, ygoProDeckUrl: ${_this.ygoProDeckUrl}, cardSets: ${_this.cardSets}, banlistInfo: ${_this.banlistInfo}, cardImages: ${_this.cardImages}, cardPrices: ${_this.cardPrices}, miscInfo: ${_this.miscInfo})';
}


}

/// @nodoc
abstract mixin class $YgoCardCopyWith<$Res>  {
  factory $YgoCardCopyWith(YgoCard value, $Res Function(YgoCard) _then) = _$YgoCardCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _parseRequiredInt) int id, String name,@JsonKey(name: 'typeline') List<String>? typeLine, String type,@JsonKey(name: 'humanReadableCardType') String? humanReadableCardType,@JsonKey(name: 'frameType') String? frameType, String desc, String race,@JsonKey(name: 'pend_desc') String? pendDesc,@JsonKey(name: 'monster_desc') String? monsterDesc,@JsonKey(fromJson: _parseInt) int? atk,@JsonKey(fromJson: _parseInt) int? def,@JsonKey(fromJson: _parseInt) int? level, String? attribute, String? archetype,@JsonKey(fromJson: _parseInt) int? scale,@JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt) int? linkVal,@JsonKey(name: 'linkmarkers') List<String>? linkMarkers,@JsonKey(name: 'ygoprodeck_url') String ygoProDeckUrl,@JsonKey(name: 'card_sets') List<CardSet>? cardSets,@JsonKey(name: 'banlist_info') BanlistInfo? banlistInfo,@JsonKey(name: 'card_images') List<CardImage>? cardImages,@JsonKey(name: 'card_prices') List<CardPrice>? cardPrices,@JsonKey(name: 'misc_info') List<MiscInfo>? miscInfo
});


$BanlistInfoCopyWith<$Res>? get banlistInfo;

}
/// @nodoc
class _$YgoCardCopyWithImpl<$Res>
    implements $YgoCardCopyWith<$Res> {
  _$YgoCardCopyWithImpl(this._self, this._then);

  final YgoCard _self;
  final $Res Function(YgoCard) _then;

/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? typeLine = freezed,Object? type = null,Object? humanReadableCardType = freezed,Object? frameType = freezed,Object? desc = null,Object? race = null,Object? pendDesc = freezed,Object? monsterDesc = freezed,Object? atk = freezed,Object? def = freezed,Object? level = freezed,Object? attribute = freezed,Object? archetype = freezed,Object? scale = freezed,Object? linkVal = freezed,Object? linkMarkers = freezed,Object? ygoProDeckUrl = null,Object? cardSets = freezed,Object? banlistInfo = freezed,Object? cardImages = freezed,Object? cardPrices = freezed,Object? miscInfo = freezed,}) {
  return _then(YgoCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,typeLine: freezed == typeLine ? _self.typeLine : typeLine // ignore: cast_nullable_to_non_nullable
as List<String>?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,humanReadableCardType: freezed == humanReadableCardType ? _self.humanReadableCardType : humanReadableCardType // ignore: cast_nullable_to_non_nullable
as String?,frameType: freezed == frameType ? _self.frameType : frameType // ignore: cast_nullable_to_non_nullable
as String?,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,race: null == race ? _self.race : race // ignore: cast_nullable_to_non_nullable
as String,pendDesc: freezed == pendDesc ? _self.pendDesc : pendDesc // ignore: cast_nullable_to_non_nullable
as String?,monsterDesc: freezed == monsterDesc ? _self.monsterDesc : monsterDesc // ignore: cast_nullable_to_non_nullable
as String?,atk: freezed == atk ? _self.atk : atk // ignore: cast_nullable_to_non_nullable
as int?,def: freezed == def ? _self.def : def // ignore: cast_nullable_to_non_nullable
as int?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,attribute: freezed == attribute ? _self.attribute : attribute // ignore: cast_nullable_to_non_nullable
as String?,archetype: freezed == archetype ? _self.archetype : archetype // ignore: cast_nullable_to_non_nullable
as String?,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int?,linkVal: freezed == linkVal ? _self.linkVal : linkVal // ignore: cast_nullable_to_non_nullable
as int?,linkMarkers: freezed == linkMarkers ? _self.linkMarkers : linkMarkers // ignore: cast_nullable_to_non_nullable
as List<String>?,ygoProDeckUrl: null == ygoProDeckUrl ? _self.ygoProDeckUrl : ygoProDeckUrl // ignore: cast_nullable_to_non_nullable
as String,cardSets: freezed == cardSets ? _self.cardSets : cardSets // ignore: cast_nullable_to_non_nullable
as List<CardSet>?,banlistInfo: freezed == banlistInfo ? _self.banlistInfo : banlistInfo // ignore: cast_nullable_to_non_nullable
as BanlistInfo?,cardImages: freezed == cardImages ? _self.cardImages : cardImages // ignore: cast_nullable_to_non_nullable
as List<CardImage>?,cardPrices: freezed == cardPrices ? _self.cardPrices : cardPrices // ignore: cast_nullable_to_non_nullable
as List<CardPrice>?,miscInfo: freezed == miscInfo ? _self.miscInfo : miscInfo // ignore: cast_nullable_to_non_nullable
as List<MiscInfo>?,
  ));
}
/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BanlistInfoCopyWith<$Res>? get banlistInfo {
    if (_self.banlistInfo == null) {
    return null;
  }

  return $BanlistInfoCopyWith<$Res>(_self.banlistInfo!, (value) {
    return _then(_self.copyWith(banlistInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [YgoCard].
extension YgoCardPatterns on YgoCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YgoCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YgoCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YgoCard value)  $default,){
final _that = this;
switch (_that) {
case _YgoCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YgoCard value)?  $default,){
final _that = this;
switch (_that) {
case _YgoCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseRequiredInt)  int id,  String name, @JsonKey(name: 'typeline')  List<String>? typeLine,  String type, @JsonKey(name: 'humanReadableCardType')  String? humanReadableCardType, @JsonKey(name: 'frameType')  String? frameType,  String desc,  String race, @JsonKey(name: 'pend_desc')  String? pendDesc, @JsonKey(name: 'monster_desc')  String? monsterDesc, @JsonKey(fromJson: _parseInt)  int? atk, @JsonKey(fromJson: _parseInt)  int? def, @JsonKey(fromJson: _parseInt)  int? level,  String? attribute,  String? archetype, @JsonKey(fromJson: _parseInt)  int? scale, @JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt)  int? linkVal, @JsonKey(name: 'linkmarkers')  List<String>? linkMarkers, @JsonKey(name: 'ygoprodeck_url')  String ygoProDeckUrl, @JsonKey(name: 'card_sets')  List<CardSet>? cardSets, @JsonKey(name: 'banlist_info')  BanlistInfo? banlistInfo, @JsonKey(name: 'card_images')  List<CardImage>? cardImages, @JsonKey(name: 'card_prices')  List<CardPrice>? cardPrices, @JsonKey(name: 'misc_info')  List<MiscInfo>? miscInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YgoCard() when $default != null:
return $default(_that.id,_that.name,_that.typeLine,_that.type,_that.humanReadableCardType,_that.frameType,_that.desc,_that.race,_that.pendDesc,_that.monsterDesc,_that.atk,_that.def,_that.level,_that.attribute,_that.archetype,_that.scale,_that.linkVal,_that.linkMarkers,_that.ygoProDeckUrl,_that.cardSets,_that.banlistInfo,_that.cardImages,_that.cardPrices,_that.miscInfo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseRequiredInt)  int id,  String name, @JsonKey(name: 'typeline')  List<String>? typeLine,  String type, @JsonKey(name: 'humanReadableCardType')  String? humanReadableCardType, @JsonKey(name: 'frameType')  String? frameType,  String desc,  String race, @JsonKey(name: 'pend_desc')  String? pendDesc, @JsonKey(name: 'monster_desc')  String? monsterDesc, @JsonKey(fromJson: _parseInt)  int? atk, @JsonKey(fromJson: _parseInt)  int? def, @JsonKey(fromJson: _parseInt)  int? level,  String? attribute,  String? archetype, @JsonKey(fromJson: _parseInt)  int? scale, @JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt)  int? linkVal, @JsonKey(name: 'linkmarkers')  List<String>? linkMarkers, @JsonKey(name: 'ygoprodeck_url')  String ygoProDeckUrl, @JsonKey(name: 'card_sets')  List<CardSet>? cardSets, @JsonKey(name: 'banlist_info')  BanlistInfo? banlistInfo, @JsonKey(name: 'card_images')  List<CardImage>? cardImages, @JsonKey(name: 'card_prices')  List<CardPrice>? cardPrices, @JsonKey(name: 'misc_info')  List<MiscInfo>? miscInfo)  $default,) {final _that = this;
switch (_that) {
case _YgoCard():
return $default(_that.id,_that.name,_that.typeLine,_that.type,_that.humanReadableCardType,_that.frameType,_that.desc,_that.race,_that.pendDesc,_that.monsterDesc,_that.atk,_that.def,_that.level,_that.attribute,_that.archetype,_that.scale,_that.linkVal,_that.linkMarkers,_that.ygoProDeckUrl,_that.cardSets,_that.banlistInfo,_that.cardImages,_that.cardPrices,_that.miscInfo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _parseRequiredInt)  int id,  String name, @JsonKey(name: 'typeline')  List<String>? typeLine,  String type, @JsonKey(name: 'humanReadableCardType')  String? humanReadableCardType, @JsonKey(name: 'frameType')  String? frameType,  String desc,  String race, @JsonKey(name: 'pend_desc')  String? pendDesc, @JsonKey(name: 'monster_desc')  String? monsterDesc, @JsonKey(fromJson: _parseInt)  int? atk, @JsonKey(fromJson: _parseInt)  int? def, @JsonKey(fromJson: _parseInt)  int? level,  String? attribute,  String? archetype, @JsonKey(fromJson: _parseInt)  int? scale, @JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt)  int? linkVal, @JsonKey(name: 'linkmarkers')  List<String>? linkMarkers, @JsonKey(name: 'ygoprodeck_url')  String ygoProDeckUrl, @JsonKey(name: 'card_sets')  List<CardSet>? cardSets, @JsonKey(name: 'banlist_info')  BanlistInfo? banlistInfo, @JsonKey(name: 'card_images')  List<CardImage>? cardImages, @JsonKey(name: 'card_prices')  List<CardPrice>? cardPrices, @JsonKey(name: 'misc_info')  List<MiscInfo>? miscInfo)?  $default,) {final _that = this;
switch (_that) {
case _YgoCard() when $default != null:
return $default(_that.id,_that.name,_that.typeLine,_that.type,_that.humanReadableCardType,_that.frameType,_that.desc,_that.race,_that.pendDesc,_that.monsterDesc,_that.atk,_that.def,_that.level,_that.attribute,_that.archetype,_that.scale,_that.linkVal,_that.linkMarkers,_that.ygoProDeckUrl,_that.cardSets,_that.banlistInfo,_that.cardImages,_that.cardPrices,_that.miscInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YgoCard implements YgoCard {
  const _YgoCard({@JsonKey(fromJson: _parseRequiredInt) required this.id, required this.name, @JsonKey(name: 'typeline')  List<String>? typeLine, required this.type, @JsonKey(name: 'humanReadableCardType') this.humanReadableCardType, @JsonKey(name: 'frameType') this.frameType, required this.desc, required this.race, @JsonKey(name: 'pend_desc') this.pendDesc, @JsonKey(name: 'monster_desc') this.monsterDesc, @JsonKey(fromJson: _parseInt) this.atk, @JsonKey(fromJson: _parseInt) this.def, @JsonKey(fromJson: _parseInt) this.level, this.attribute, this.archetype, @JsonKey(fromJson: _parseInt) this.scale, @JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt) this.linkVal, @JsonKey(name: 'linkmarkers')  List<String>? linkMarkers, @JsonKey(name: 'ygoprodeck_url') required this.ygoProDeckUrl, @JsonKey(name: 'card_sets')  List<CardSet>? cardSets, @JsonKey(name: 'banlist_info') this.banlistInfo, @JsonKey(name: 'card_images')  List<CardImage>? cardImages, @JsonKey(name: 'card_prices')  List<CardPrice>? cardPrices, @JsonKey(name: 'misc_info')  List<MiscInfo>? miscInfo}): _typeLine = typeLine,_linkMarkers = linkMarkers,_cardSets = cardSets,_cardImages = cardImages,_cardPrices = cardPrices,_miscInfo = miscInfo;
  factory _YgoCard.fromJson(Map<String, dynamic> json) => _$YgoCardFromJson(json);

@override@JsonKey(fromJson: _parseRequiredInt) final  int id;
@override final  String name;
 final  List<String>? _typeLine;
@override@JsonKey(name: 'typeline') List<String>? get typeLine {
  final value = _typeLine;
  if (value == null) return null;
  if (_typeLine is EqualUnmodifiableListView) return _typeLine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String type;
@override@JsonKey(name: 'humanReadableCardType') final  String? humanReadableCardType;
@override@JsonKey(name: 'frameType') final  String? frameType;
@override final  String desc;
@override final  String race;
@override@JsonKey(name: 'pend_desc') final  String? pendDesc;
@override@JsonKey(name: 'monster_desc') final  String? monsterDesc;
@override@JsonKey(fromJson: _parseInt) final  int? atk;
@override@JsonKey(fromJson: _parseInt) final  int? def;
@override@JsonKey(fromJson: _parseInt) final  int? level;
@override final  String? attribute;
@override final  String? archetype;
@override@JsonKey(fromJson: _parseInt) final  int? scale;
@override@JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt) final  int? linkVal;
 final  List<String>? _linkMarkers;
@override@JsonKey(name: 'linkmarkers') List<String>? get linkMarkers {
  final value = _linkMarkers;
  if (value == null) return null;
  if (_linkMarkers is EqualUnmodifiableListView) return _linkMarkers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'ygoprodeck_url') final  String ygoProDeckUrl;
 final  List<CardSet>? _cardSets;
@override@JsonKey(name: 'card_sets') List<CardSet>? get cardSets {
  final value = _cardSets;
  if (value == null) return null;
  if (_cardSets is EqualUnmodifiableListView) return _cardSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'banlist_info') final  BanlistInfo? banlistInfo;
 final  List<CardImage>? _cardImages;
@override@JsonKey(name: 'card_images') List<CardImage>? get cardImages {
  final value = _cardImages;
  if (value == null) return null;
  if (_cardImages is EqualUnmodifiableListView) return _cardImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<CardPrice>? _cardPrices;
@override@JsonKey(name: 'card_prices') List<CardPrice>? get cardPrices {
  final value = _cardPrices;
  if (value == null) return null;
  if (_cardPrices is EqualUnmodifiableListView) return _cardPrices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<MiscInfo>? _miscInfo;
@override@JsonKey(name: 'misc_info') List<MiscInfo>? get miscInfo {
  final value = _miscInfo;
  if (value == null) return null;
  if (_miscInfo is EqualUnmodifiableListView) return _miscInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YgoCardCopyWith<_YgoCard> get copyWith => __$YgoCardCopyWithImpl<_YgoCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YgoCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YgoCard&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.typeLine, _typeLine)&&(identical(other.type, type) || other.type == type)&&(identical(other.humanReadableCardType, humanReadableCardType) || other.humanReadableCardType == humanReadableCardType)&&(identical(other.frameType, frameType) || other.frameType == frameType)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.race, race) || other.race == race)&&(identical(other.pendDesc, pendDesc) || other.pendDesc == pendDesc)&&(identical(other.monsterDesc, monsterDesc) || other.monsterDesc == monsterDesc)&&(identical(other.atk, atk) || other.atk == atk)&&(identical(other.def, def) || other.def == def)&&(identical(other.level, level) || other.level == level)&&(identical(other.attribute, attribute) || other.attribute == attribute)&&(identical(other.archetype, archetype) || other.archetype == archetype)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.linkVal, linkVal) || other.linkVal == linkVal)&&const DeepCollectionEquality().equals(other.linkMarkers, _linkMarkers)&&(identical(other.ygoProDeckUrl, ygoProDeckUrl) || other.ygoProDeckUrl == ygoProDeckUrl)&&const DeepCollectionEquality().equals(other.cardSets, _cardSets)&&(identical(other.banlistInfo, banlistInfo) || other.banlistInfo == banlistInfo)&&const DeepCollectionEquality().equals(other.cardImages, _cardImages)&&const DeepCollectionEquality().equals(other.cardPrices, _cardPrices)&&const DeepCollectionEquality().equals(other.miscInfo, _miscInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,const DeepCollectionEquality().hash(_typeLine),type,humanReadableCardType,frameType,desc,race,pendDesc,monsterDesc,atk,def,level,attribute,archetype,scale,linkVal,const DeepCollectionEquality().hash(_linkMarkers),ygoProDeckUrl,const DeepCollectionEquality().hash(_cardSets),banlistInfo,const DeepCollectionEquality().hash(_cardImages),const DeepCollectionEquality().hash(_cardPrices),const DeepCollectionEquality().hash(_miscInfo)]);
}

@override
String toString() {
    return 'YgoCard(id: $id, name: $name, typeLine: $typeLine, type: $type, humanReadableCardType: $humanReadableCardType, frameType: $frameType, desc: $desc, race: $race, pendDesc: $pendDesc, monsterDesc: $monsterDesc, atk: $atk, def: $def, level: $level, attribute: $attribute, archetype: $archetype, scale: $scale, linkVal: $linkVal, linkMarkers: $linkMarkers, ygoProDeckUrl: $ygoProDeckUrl, cardSets: $cardSets, banlistInfo: $banlistInfo, cardImages: $cardImages, cardPrices: $cardPrices, miscInfo: $miscInfo)';
}


}

/// @nodoc
abstract mixin class _$YgoCardCopyWith<$Res> implements $YgoCardCopyWith<$Res> {
  factory _$YgoCardCopyWith(_YgoCard value, $Res Function(_YgoCard) _then) = __$YgoCardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _parseRequiredInt) int id, String name,@JsonKey(name: 'typeline') List<String>? typeLine, String type,@JsonKey(name: 'humanReadableCardType') String? humanReadableCardType,@JsonKey(name: 'frameType') String? frameType, String desc, String race,@JsonKey(name: 'pend_desc') String? pendDesc,@JsonKey(name: 'monster_desc') String? monsterDesc,@JsonKey(fromJson: _parseInt) int? atk,@JsonKey(fromJson: _parseInt) int? def,@JsonKey(fromJson: _parseInt) int? level, String? attribute, String? archetype,@JsonKey(fromJson: _parseInt) int? scale,@JsonKey(name: 'linkval')@JsonKey(fromJson: _parseInt) int? linkVal,@JsonKey(name: 'linkmarkers') List<String>? linkMarkers,@JsonKey(name: 'ygoprodeck_url') String ygoProDeckUrl,@JsonKey(name: 'card_sets') List<CardSet>? cardSets,@JsonKey(name: 'banlist_info') BanlistInfo? banlistInfo,@JsonKey(name: 'card_images') List<CardImage>? cardImages,@JsonKey(name: 'card_prices') List<CardPrice>? cardPrices,@JsonKey(name: 'misc_info') List<MiscInfo>? miscInfo
});


@override $BanlistInfoCopyWith<$Res>? get banlistInfo;

}
/// @nodoc
class __$YgoCardCopyWithImpl<$Res>
    implements _$YgoCardCopyWith<$Res> {
  __$YgoCardCopyWithImpl(this._self, this._then);

  final _YgoCard _self;
  final $Res Function(_YgoCard) _then;

/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? typeLine = freezed,Object? type = null,Object? humanReadableCardType = freezed,Object? frameType = freezed,Object? desc = null,Object? race = null,Object? pendDesc = freezed,Object? monsterDesc = freezed,Object? atk = freezed,Object? def = freezed,Object? level = freezed,Object? attribute = freezed,Object? archetype = freezed,Object? scale = freezed,Object? linkVal = freezed,Object? linkMarkers = freezed,Object? ygoProDeckUrl = null,Object? cardSets = freezed,Object? banlistInfo = freezed,Object? cardImages = freezed,Object? cardPrices = freezed,Object? miscInfo = freezed,}) {
  return _then(_YgoCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,typeLine: freezed == typeLine ? _self._typeLine : typeLine // ignore: cast_nullable_to_non_nullable
as List<String>?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,humanReadableCardType: freezed == humanReadableCardType ? _self.humanReadableCardType : humanReadableCardType // ignore: cast_nullable_to_non_nullable
as String?,frameType: freezed == frameType ? _self.frameType : frameType // ignore: cast_nullable_to_non_nullable
as String?,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,race: null == race ? _self.race : race // ignore: cast_nullable_to_non_nullable
as String,pendDesc: freezed == pendDesc ? _self.pendDesc : pendDesc // ignore: cast_nullable_to_non_nullable
as String?,monsterDesc: freezed == monsterDesc ? _self.monsterDesc : monsterDesc // ignore: cast_nullable_to_non_nullable
as String?,atk: freezed == atk ? _self.atk : atk // ignore: cast_nullable_to_non_nullable
as int?,def: freezed == def ? _self.def : def // ignore: cast_nullable_to_non_nullable
as int?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,attribute: freezed == attribute ? _self.attribute : attribute // ignore: cast_nullable_to_non_nullable
as String?,archetype: freezed == archetype ? _self.archetype : archetype // ignore: cast_nullable_to_non_nullable
as String?,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int?,linkVal: freezed == linkVal ? _self.linkVal : linkVal // ignore: cast_nullable_to_non_nullable
as int?,linkMarkers: freezed == linkMarkers ? _self._linkMarkers : linkMarkers // ignore: cast_nullable_to_non_nullable
as List<String>?,ygoProDeckUrl: null == ygoProDeckUrl ? _self.ygoProDeckUrl : ygoProDeckUrl // ignore: cast_nullable_to_non_nullable
as String,cardSets: freezed == cardSets ? _self._cardSets : cardSets // ignore: cast_nullable_to_non_nullable
as List<CardSet>?,banlistInfo: freezed == banlistInfo ? _self.banlistInfo : banlistInfo // ignore: cast_nullable_to_non_nullable
as BanlistInfo?,cardImages: freezed == cardImages ? _self._cardImages : cardImages // ignore: cast_nullable_to_non_nullable
as List<CardImage>?,cardPrices: freezed == cardPrices ? _self._cardPrices : cardPrices // ignore: cast_nullable_to_non_nullable
as List<CardPrice>?,miscInfo: freezed == miscInfo ? _self._miscInfo : miscInfo // ignore: cast_nullable_to_non_nullable
as List<MiscInfo>?,
  ));
}

/// Create a copy of YgoCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BanlistInfoCopyWith<$Res>? get banlistInfo {
    if (_self.banlistInfo == null) {
    return null;
  }

  return $BanlistInfoCopyWith<$Res>(_self.banlistInfo!, (value) {
    return _then(_self.copyWith(banlistInfo: value));
  });
}
}

// dart format on
