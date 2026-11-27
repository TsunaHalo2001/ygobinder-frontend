import 'package:ygobinder/core/database/app_database.dart';

/// Price lookups for collection items, built once from the stored global
/// card prices (YGOPRODeck) and per-set printing prices (TCGTracking).
class PriceResolver {
  PriceResolver({
    required Iterable<DriftCardPrice> globalPrices,
    required Iterable<DriftSetCardPrice> setPrices,
  }) {
    for (final p in globalPrices) {
      _globalByCard[p.cardId] = p.tcgPlayerPrice ?? p.cardMarketPrice ?? 0.0;
    }
    for (final sp in setPrices) {
      final price = sp.marketPrice ?? sp.lowPrice ?? 0.0;
      final code = sp.setCode;
      if (code != null && code.isNotEmpty) {
        final codeKey = _codeKey(sp.cardId, code);
        _bySetCode[codeKey] = price;
        _bySetCodeAndPrinting['${codeKey}_${sp.printing.trim().toLowerCase()}'] = price;
      }
      if (price > (_maxByCard[sp.cardId] ?? 0.0)) {
        _maxByCard[sp.cardId] = price;
      }
    }
  }

  final _globalByCard = <int, double>{};
  final _bySetCode = <String, double>{};
  final _bySetCodeAndPrinting = <String, double>{};
  final _maxByCard = <int, double>{};

  static String _codeKey(int cardId, String setCode) => '${cardId}_${setCode.trim().toUpperCase()}';

  /// Global (non-printing specific) price of a card.
  double? globalPrice(int cardId) => _globalByCard[cardId];

  /// Price of the printing [setCode] of [cardId]; when [rarity] is given the
  /// rarity-specific printing is preferred.
  double? setPrice(int cardId, String setCode, {String? rarity}) {
    final codeKey = _codeKey(cardId, setCode);
    if (rarity != null) {
      final byPrinting = _bySetCodeAndPrinting['${codeKey}_${rarity.trim().toLowerCase()}'];
      if (byPrinting != null) return byPrinting;
    }
    return _bySetCode[codeKey];
  }

  /// Highest known printing price of [cardId] (only positive prices).
  double? maxSetPrice(int cardId) => _maxByCard[cardId];

  /// Unit price used for collection statistics:
  /// own printing → most expensive printing → global price → purchase price.
  double collectionItemPrice(DriftCollectionItem item) {
    var price = setPrice(item.cardId, item.setCode) ?? maxSetPrice(item.cardId) ?? 0.0;
    if (price <= 0.0) price = globalPrice(item.cardId) ?? 0.0;
    if (price <= 0.0) price = item.priceAtPurchase ?? 0.0;
    return price;
  }

  /// Unit price used for quote estimates:
  /// own printing (rarity first) → purchase price → global price.
  double quoteItemPrice(DriftCollectionItem item) {
    var price = setPrice(item.cardId, item.setCode, rarity: item.rarity) ?? item.priceAtPurchase ?? 0.0;
    if (price <= 0.0) price = globalPrice(item.cardId) ?? 0.0;
    return price;
  }
}
