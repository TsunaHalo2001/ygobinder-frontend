import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/services/card_cache_parser.dart';
import 'package:ygobinder/features/cards/data/services/price_resolver.dart';

DriftCollectionItem _item({int cardId = 1, String setCode = 'LOB-EN001', String rarity = 'Ultra Rare', double? purchase}) =>
    DriftCollectionItem(
      id: 1,
      cardId: cardId,
      setCode: setCode,
      rarity: rarity,
      collectionNumber: 1,
      quantity: 1,
      condition: 'Near Mint',
      language: 'EN',
      isFirstEdition: false,
      priceAtPurchase: purchase,
      addedAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

DriftSetCardPrice _setPrice(int cardId, String? code, String printing, double market) => DriftSetCardPrice(
      id: 0,
      setId: 1,
      cardId: cardId,
      setCode: code,
      printing: printing,
      marketPrice: market,
    );

DriftCardPrice _global(int cardId, double tcg) => DriftCardPrice(id: 0, cardId: cardId, tcgPlayerPrice: tcg);

void main() {
  group('PriceResolver', () {
    test('collection price prefers own printing, then max printing, global, purchase', () {
      final r = PriceResolver(
        globalPrices: [_global(1, 3.0), _global(2, 4.0)],
        setPrices: [
          _setPrice(1, 'LOB-EN001', 'Ultra Rare', 10.0),
          _setPrice(1, 'SDK-001', 'Ultra Rare', 25.0),
        ],
      );
      expect(r.collectionItemPrice(_item(setCode: 'lob-en001 ')), 10.0);
      expect(r.collectionItemPrice(_item(setCode: 'MRD-001')), 25.0, reason: 'falls back to max printing');
      expect(r.collectionItemPrice(_item(cardId: 2)), 4.0, reason: 'falls back to global');
      expect(r.collectionItemPrice(_item(cardId: 3, purchase: 1.5)), 1.5);
      expect(r.collectionItemPrice(_item(cardId: 3)), 0.0);
    });

    test('quote price prefers rarity printing, then code, purchase, global', () {
      final r = PriceResolver(
        globalPrices: [_global(1, 3.0)],
        setPrices: [
          _setPrice(1, 'LOB-EN001', 'Secret Rare', 50.0),
          _setPrice(1, 'LOB-EN001', 'Ultra Rare', 10.0),
        ],
      );
      expect(r.quoteItemPrice(_item(rarity: 'Ultra Rare')), 10.0);
      expect(r.quoteItemPrice(_item(setCode: 'MRD-001', purchase: 2.0)), 2.0);
      expect(r.quoteItemPrice(_item(setCode: 'MRD-001')), 3.0);
    });
  });

  group('parseCardCacheBytes', () {
    Uint8List encode(Object json) => Uint8List.fromList(utf8.encode(jsonEncode(json)));

    test('parses cards, related rows and sets; skips Skill cards', () {
      final bytes = encode({
        'data': [
          {
            'id': 89631139,
            'name': 'Blue-Eyes White Dragon',
            'type': 'Normal Monster',
            'frameType': 'normal',
            'desc': 'Legendary dragon.',
            'race': 'Dragon',
            'ygoprodeck_url': 'https://ygoprodeck.com/card/blue-eyes-white-dragon-4007',
            'card_sets': [
              {'set_name': 'LOB', 'set_code': 'LOB-EN001', 'set_rarity': 'Ultra Rare', 'set_rarity_code': '(UR)', 'set_price': '10.0'},
            ],
            'card_images': [
              {'id': 89631139, 'image_url': 'a', 'image_url_small': 'b', 'image_url_cropped': 'c'},
            ],
          },
          {
            'id': 300,
            'name': 'Skill',
            'type': 'Skill Card',
            'desc': '',
            'race': 'Kaiba',
            'ygoprodeck_url': '',
          },
        ],
        'sets': [
          {'id': 330, 'name': 'Legend of Blue Eyes White Dragon', 'abbreviation': 'LOB'},
        ],
        'version': '1.4.0+17',
      });

      int? decodedCards;
      final parsed = parseCardCacheBytes(bytes, onDecoded: (c, _) => decodedCards = c);

      expect(decodedCards, 2, reason: 'raw count reported before filtering');
      expect(parsed.cards, hasLength(1));
      expect(parsed.cards.single.id.value, 89631139);
      expect(parsed.cardSets.single.setCode.value, 'LOB-EN001');
      expect(parsed.images, hasLength(1));
      expect(parsed.setInfos.single.abbreviation.value, 'LOB');
    });

    test('rejects unexpected JSON', () {
      expect(() => parseCardCacheBytes(encode('nope')), throwsFormatException);
    });
  });
}
