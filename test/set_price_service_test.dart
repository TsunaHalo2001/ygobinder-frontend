import 'package:flutter_test/flutter_test.dart';
import 'package:ygobinder/features/cards/data/services/set_price_service.dart';

/// Trimmed from the real TCGTracking `/v1/2/sets/330/cards` and `/pricing`
/// responses (Legend of Blue Eyes White Dragon). Note that `/pricing` is keyed
/// by TCGplayer product id, not by card id.
final _setCards = <dynamic>[
  {'id': 22538, 'name': 'Tri-Horned Dragon (LOB-000)', 'clean_name': 'Tri Horned Dragon LOB 000', 'number': 'LOB-000', 'rarity': 'Secret Rare'},
  {'id': 21792, 'name': 'Blue-Eyes White Dragon', 'clean_name': 'Blue Eyes White Dragon', 'number': 'LOB-001', 'rarity': 'Ultra Rare'},
  {'id': 21876, 'name': 'Dark Magician', 'clean_name': 'Dark Magician', 'number': 'LOB-005', 'rarity': 'Ultra Rare'},
];

final _pricing = <String, dynamic>{
  'set_id': 330,
  'updated': '2026-11-26T09:00:32-05:00',
  'prices': {
    '22538': {
      'tcg': {
        '1st Edition': {'low': 267, 'market': 271.66},
        'Unlimited': {'low': 16.64, 'market': 19.73},
      },
    },
    '21792': {
      'tcg': {
        'Unlimited': {'low': 95, 'market': 119.14},
      },
    },
    '21876': {
      'tcg': {
        'Unlimited': {'low': 24.95, 'market': 42.86},
      },
    },
  },
};

void main() {
  group('SetPriceService.matchProducts', () {
    test('matches by prefix + digits across language codes (LOB-EN001 → LOB-001)', () {
      final matched = SetPriceService.matchProducts(
        _setCards,
        setCode: 'LOB-EN001',
        cardName: 'Blue-Eyes White Dragon',
      );
      expect(matched.map((p) => p['id']), [21792]);
    });

    test('exact code match', () {
      final matched = SetPriceService.matchProducts(
        _setCards,
        setCode: 'LOB-005',
        cardName: 'Dark Magician',
      );
      expect(matched.map((p) => p['id']), [21876]);
    });

    test('no match for a card outside the set', () {
      final matched = SetPriceService.matchProducts(
        _setCards,
        setCode: 'SDK-001',
        cardName: 'Kaiba',
      );
      expect(matched, isEmpty);
    });
  });

  group('SetPriceService.buildCompanions', () {
    test('resolves prices through product ids and names printings by rarity', () {
      final products = SetPriceService.matchProducts(
        _setCards,
        setCode: 'LOB-EN000',
        cardName: 'Tri-Horned Dragon',
      );
      final rows = SetPriceService.buildCompanions(
        pricingData: _pricing,
        fallbackSetId: 1,
        cardId: 39111158,
        setCode: 'LOB-EN000',
        products: products,
        previousPrices: {SetPriceService.previousPriceKey(330, 39111158, 'Secret Rare (Unlimited)'): 15.0},
      );

      expect(rows, hasLength(2));
      for (final r in rows) {
        expect(r.cardId.value, 39111158, reason: 'card id, never the product id');
        expect(r.setId.value, 330);
        expect(r.setCode.value, 'LOB-EN000');
      }
      final byPrinting = {for (final r in rows) r.printing.value: r};
      expect(byPrinting.keys, containsAll(['Secret Rare (1st Edition)', 'Secret Rare (Unlimited)']));
      expect(byPrinting['Secret Rare (Unlimited)']!.marketPrice.value, 19.73);
      expect(byPrinting['Secret Rare (Unlimited)']!.previousMarketPrice.value, 15.0);
      expect(byPrinting['Secret Rare (1st Edition)']!.previousMarketPrice.value, isNull);
    });

    test('returns nothing when no products match', () {
      final rows = SetPriceService.buildCompanions(
        pricingData: _pricing,
        fallbackSetId: 330,
        cardId: 1,
        setCode: 'LOB-EN999',
        products: const [],
      );
      expect(rows, isEmpty);
    });
  });
}
