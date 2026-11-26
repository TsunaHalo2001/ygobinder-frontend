import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ygobinder/core/database/app_database.dart';

CardsCompanion _card(int id, String name, {String type = 'Normal Monster'}) => CardsCompanion.insert(
      id: Value(id),
      name: name,
      type: type,
      desc: '',
      race: 'Dragon',
      ygoProDeckUrl: '',
    );

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.batch((b) {
      b.insertAll(db.cards, [
        _card(89631139, 'Blue-Eyes White Dragon'),
        _card(46986414, 'Dark Magician'),
      ]);
      b.insertAll(db.cardSets, [
        CardSetsCompanion.insert(cardId: 89631139, setName: 'LOB', setCode: 'LOB-EN001', setRarity: 'Ultra Rare', setRarityCode: '(UR)'),
        CardSetsCompanion.insert(cardId: 89631139, setName: 'SDK', setCode: 'SDK-001', setRarity: 'Ultra Rare', setRarityCode: '(UR)'),
        CardSetsCompanion.insert(cardId: 46986414, setName: 'LOB', setCode: 'LOB-EN005', setRarity: 'Ultra Rare', setRarityCode: '(UR)'),
      ]);
    });
  });

  tearDown(() => db.close());

  test('indexes are created on a fresh database', () async {
    final rows = await db.customSelect("SELECT name FROM sqlite_master WHERE type = 'index'").get();
    final names = rows.map((r) => r.read<String>('name')).toSet();
    expect(
      names,
      containsAll([
        'cards_name_idx',
        'card_sets_card_id_idx',
        'card_images_card_id_idx',
        'card_prices_card_id_idx',
        'collection_items_print_idx',
        'deck_cards_deck_id_idx',
        'set_card_prices_card_id_idx',
      ]),
    );
  });

  test('getCardPrintingsBySetPrefix returns one printing per card in the set', () async {
    final printings = await db.getCardPrintingsBySetPrefix('lob');
    final byCard = {for (final p in printings) p.cardId: p};
    expect(byCard.keys, unorderedEquals([89631139, 46986414]));
    expect(byCard[89631139]!.setCode, 'LOB-EN001');
    expect(byCard[89631139]!.cardName, 'Blue-Eyes White Dragon');
  });

  test('deleteOrphanSetCardPrices removes rows keyed by unknown card ids', () async {
    await db.saveSetCardPrices([
      SetCardPricesCompanion.insert(setId: 330, cardId: 89631139, printing: 'Ultra Rare'),
      SetCardPricesCompanion.insert(setId: 330, cardId: 21792, printing: 'Unlimited'), // product id
    ]);
    expect(await db.deleteOrphanSetCardPrices(), 1);
    final remaining = await db.getSetCardPricesForSet(330);
    expect(remaining.map((r) => r.cardId), [89631139]);
  });

  test('clearUserData wipes account data but keeps card data and settings', () async {
    await db.saveSetting('selected_currency', 'EUR');
    await db.addToCollection(cardId: 89631139, setCode: 'LOB-EN001', rarity: 'Ultra Rare');
    await db.saveDeck('Yugi', {'main': [46986414], 'extra': [], 'side': []});
    await db.toggleFavorite(89631139);
    await db.toggleWanted(46986414);

    await db.clearUserData();

    expect(await db.select(db.collectionItems).get(), isEmpty);
    expect(await db.select(db.decks).get(), isEmpty);
    expect(await db.select(db.deckCards).get(), isEmpty);
    expect(await db.select(db.favoriteCards).get(), isEmpty);
    expect(await db.select(db.wantedCards).get(), isEmpty);
    expect(await db.select(db.userOwnedSets).get(), isEmpty);
    expect(await db.select(db.cards).get(), hasLength(2));
    expect(await db.getSetting('selected_currency'), 'EUR');
  });

  test('collection value stream emits once on listen and once per change', () async {
    final values = <double>[];
    final sub = db.watchTotalCollectionValue().listen(values.add);
    await pumpEventQueue();
    expect(values, [0.0]);

    await db.batch((b) => b.insertAll(db.cardPrices, [
          CardPricesCompanion.insert(cardId: 89631139, tcgPlayerPrice: const Value(5.0)),
        ]));
    await db.addToCollection(cardId: 89631139, setCode: 'LOB-EN001', rarity: 'Ultra Rare', quantity: 2);
    await pumpEventQueue();
    expect(values.last, 10.0);
    expect(values.length, lessThanOrEqualTo(3));

    await db.saveSetCardPrices([
      SetCardPricesCompanion.insert(setId: 330, cardId: 89631139, setCode: const Value('LOB-EN001'), printing: 'Ultra Rare', marketPrice: const Value(7.0)),
    ]);
    await pumpEventQueue();
    expect(values.last, 14.0, reason: 'own printing price wins over global');
    await sub.cancel();
  });

  test('refreshUserOwnedSets names sets from card_sets when setInfos has no match', () async {
    await db.addToCollection(cardId: 89631139, setCode: 'LOB-EN001', rarity: 'Ultra Rare');
    await db.addToCollection(cardId: 46986414, setCode: 'LOB-EN005', rarity: 'Ultra Rare', quantity: 2);
    final owned = await db.getUserOwnedSets();
    expect(owned, hasLength(1));
    expect(owned.single.setCode, 'LOB');
    expect(owned.single.setName, 'LOB');
    expect(owned.single.totalCardsOwned, 3);
  });

  test('saveDeck stores cards in order and skips unknown ids', () async {
    final id = await db.saveDeck('Test', {
      'main': [46986414, 46986414, 123],
      'extra': [],
      'side': [89631139],
    });
    final cards = await db.getDeckCards(id);
    expect(cards.map((c) => (c.category, c.cardId)), [
      ('main', 46986414),
      ('main', 46986414),
      ('side', 89631139),
    ]);

    // Saving again with the same name replaces the cards
    await db.saveDeck('test', {'main': [89631139], 'extra': [], 'side': []});
    expect((await db.getDeckCards(id)).map((c) => c.cardId), [89631139]);
  });

  test('toggleFavorite / toggleWanted flip the flag', () async {
    expect(await db.toggleFavorite(89631139), isTrue);
    expect(await db.watchIsFavorite(89631139).first, isTrue);
    expect(await db.toggleFavorite(89631139), isFalse);
    expect(await db.watchIsFavorite(89631139).first, isFalse);
    expect(await db.toggleWanted(46986414), isTrue);
    expect(await db.watchIsWanted(46986414).first, isTrue);
  });
}
