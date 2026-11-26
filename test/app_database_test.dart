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
}
