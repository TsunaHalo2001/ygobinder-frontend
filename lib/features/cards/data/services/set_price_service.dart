import 'package:drift/drift.dart' show Value;
import 'package:ygobinder/core/database/app_database.dart';

final _nonAlnum = RegExp(r'[^A-Z0-9]');
final _nonDigit = RegExp(r'[^0-9]');

/// Pure helpers shared by every flow that turns TCGTracking set data
/// (`/sets/{id}/cards` + `/sets/{id}/pricing`) into [SetCardPricesCompanion]s.
///
/// The `/pricing` payload is keyed by TCGplayer **product id**, so prices must
/// always be resolved through the products returned by `/cards`.
class SetPriceService {
  const SetPriceService._();

  /// Returns the products of [setCards] that correspond to the printing
  /// [setCode] (e.g. `LOB-EN001`) of the card called [cardName].
  static List<Map<String, dynamic>> matchProducts(
    List<dynamic> setCards, {
    required String setCode,
    required String cardName,
  }) {
    final cleanTargetCode = setCode.trim().toUpperCase();
    final normCardName = cardName.trim().toUpperCase().replaceAll(_nonAlnum, '');
    final targetPrefix = cleanTargetCode.contains('-') ? cleanTargetCode.split('-').first : cleanTargetCode;
    final targetDigits = cleanTargetCode.replaceAll(_nonDigit, '');

    final matched = <Map<String, dynamic>>[];
    for (final item in setCards) {
      if (item is! Map<String, dynamic>) continue;
      final number = (item['number'] as String?)?.trim().toUpperCase() ?? '';
      final cleanName = (item['clean_name'] as String?)?.trim().toUpperCase() ??
          (item['name'] as String?)?.trim().toUpperCase() ??
          '';
      final normApiName = cleanName.replaceAll(_nonAlnum, '');
      final itemPrefix = number.contains('-') ? number.split('-').first : number;
      final itemDigits = number.replaceAll(_nonDigit, '');

      bool isMatch = false;
      // Strategy 1: exact set code match (e.g. "PGD-070" == "PGD-070")
      if (number.isNotEmpty && number == cleanTargetCode) {
        isMatch = true;
      }
      // Strategy 2: same prefix and digits (e.g. "PGD-EN070" vs "PGD-070")
      else if (targetPrefix.isNotEmpty &&
          itemPrefix == targetPrefix &&
          targetDigits.isNotEmpty &&
          itemDigits == targetDigits) {
        isMatch = true;
      }
      // Strategy 3: same name and (when both known) same digits
      else if (normApiName == normCardName) {
        isMatch = targetDigits.isEmpty || itemDigits.isEmpty || targetDigits == itemDigits;
      }

      if (isMatch) matched.add(item);
    }
    return matched;
  }

  /// Key used to look up the previous market price of a printing.
  static String previousPriceKey(int setId, int cardId, String printing) =>
      '${setId}_${cardId}_${printing.trim().toLowerCase()}';

  /// Builds the rows to store for [cardId] from the matched [products] and the
  /// raw `/pricing` response.
  ///
  /// [previousPrices] maps [previousPriceKey] → last known market price and is
  /// used to fill `previousMarketPrice` when the price changed.
  static List<SetCardPricesCompanion> buildCompanions({
    required Map<String, dynamic> pricingData,
    required int fallbackSetId,
    required int cardId,
    required String setCode,
    required List<Map<String, dynamic>> products,
    Map<String, double> previousPrices = const {},
  }) {
    final setId = pricingData['set_id'] as int? ?? fallbackSetId;
    final updatedStr = pricingData['updated'] as String? ?? DateTime.now().toIso8601String();
    final pricesMap = pricingData['prices'] as Map<String, dynamic>?;
    if (pricesMap == null || pricesMap.isEmpty) return const [];

    final companions = <SetCardPricesCompanion>[];
    for (final product in products) {
      final productId = product['id']?.toString();
      if (productId == null) continue;
      final cardData = pricesMap[productId] as Map<String, dynamic>?;
      final tcgData = cardData?['tcg'] as Map<String, dynamic>?;
      if (tcgData == null) continue;

      final productRarity = product['rarity'] as String? ?? '';
      for (final entry in tcgData.entries) {
        final subPrinting = entry.key; // e.g. "Normal", "1st Edition", "Unlimited"
        final pMap = entry.value as Map<String, dynamic>?;
        final low = (pMap?['low'] as num?)?.toDouble();
        final market = (pMap?['market'] as num?)?.toDouble();

        final printingName = productRarity.isNotEmpty
            ? (subPrinting == 'Normal' ? productRarity : '$productRarity ($subPrinting)')
            : subPrinting;

        final oldPrice = previousPrices[previousPriceKey(setId, cardId, printingName)];
        final prevPrice =
            (oldPrice != null && market != null && (oldPrice - market).abs() >= 0.01) ? oldPrice : null;

        companions.add(
          SetCardPricesCompanion.insert(
            setId: setId,
            cardId: cardId,
            setCode: Value(setCode),
            printing: printingName,
            lowPrice: Value(low),
            marketPrice: Value(market),
            previousMarketPrice: Value(prevPrice),
            lastUpdated: Value(updatedStr),
          ),
        );
      }
    }
    return companions;
  }

  /// Builds the [previousPriceKey] map from already stored rows.
  static Map<String, double> previousPricesFrom(Iterable<DriftSetCardPrice> rows) {
    return {
      for (final r in rows)
        if (r.marketPrice != null && r.marketPrice! > 0.0)
          previousPriceKey(r.setId, r.cardId, r.printing): r.marketPrice!,
    };
  }
}
