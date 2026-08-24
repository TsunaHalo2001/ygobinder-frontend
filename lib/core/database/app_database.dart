import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

part 'app_database.g.dart';

// Table definition for the 'cards' table
class Cards extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get desc => text()();
  TextColumn get race => text()();
  TextColumn get frameType => text().nullable()();
  TextColumn get humanReadableType => text().nullable()();
  IntColumn get atk => integer().nullable()();
  IntColumn get def => integer().nullable()();
  IntColumn get level => integer().nullable()();
  TextColumn get attribute => text().nullable()();
  TextColumn get archetype => text().nullable()();
  IntColumn get scale => integer().nullable()();
  IntColumn get linkVal => integer().nullable()();
  TextColumn get ygoProDeckUrl => text()();
  TextColumn get pendDesc => text().nullable()();
  TextColumn get monsterDesc => text().nullable()();
  TextColumn get typeLineJson => text().nullable()();
  TextColumn get linkMarkersJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CardImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  IntColumn get imageId => integer()();
  TextColumn get ImageUrl => text()();
  TextColumn get imageUrlSmall => text()();
  TextColumn get imageUrlCropped => text()();
}

class CardPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  TextColumn get cardMarketPrice => text().nullable()();
  TextColumn get tcgPlayerPrice => text().nullable()();
  TextColumn get ebayPrice => text().nullable()();
  TextColumn get amazonPrice => text().nullable()();
  TextColumn get coolStuffIncPrice => text().nullable()();
}

class CardSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  TextColumn get setName => text()();
  TextColumn get setCode => text()();
  TextColumn get setRarity => text()();
  TextColumn get setRarityCode => text()();
  TextColumn get setPrice => text().nullable()();
}

class BanlistInfos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get banTcg => text().nullable()();
  TextColumn get banOcg => text().nullable()();
  TextColumn get banGoat => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CollectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  IntColumn get quantity => integer()();
  TextColumn get condition => text()();
  TextColumn get notes => text().nullable()();
  DateTime get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTime get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Database Class
@DriftDatabase(tables: [
  Cards,
  CardImages,
  CardPrices,
  CardSets,
  BanlistInfos,
  CollectionItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
    MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle database upgrades here
      },
      beforeOpen: (details) async {
      },
    );

// Card Queries
  Future<Card?> getCardById(int cardId) {
    return (select(cards)..where((t) => t.id.equals(cardId))).getSingleOrNull();
  }

  Future<List<Card>> searchCards(String query) {
    return (select(cards)
      ..where((t) => t.name.like('%$query%'))
      ..limit(20))
    .get();
  }

  Future<List<Cards>> getCardsByArchetype(String archetype) {
    return (select(cards)
      ..where((t) => t.archetype.equals(archetype))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
    .get();
  }

  Stream <List<Cards>> watchAllCards() {
    return select(cards).watch();
  }

// Collection Queries
  Future<List<CollectionItemWithCard>> watchCollection() {
    final query = select(collectionItems).join([
      innerJoin(cards, cards.id.equalsExp(collectionItems.cardId)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return CollectionItemWithCard(
          collectionItem: row.readTable(collectionItems),
          card: row.readTable(cards),
        );
      }).toList();
    });
  }

  Future<int> addToCollection({
    required int cardId,
    int quantity = 1,
    String condition = 'Near Mint',
    String? notes,
  }) async {
    final existing = await (select(collectionItems)
      ..where((t) =>
        t.cardId.equals(cardId) & t.condition.equals(condition)))
    .getSingleOrNull();

    if (existing != null) {
      await (update(collectionItems)..where((t) => t.id.equals(existing.id)))
        .write(CollectionItemsCompanion(
          quantity: Value(existing.quantity + quantity),
          updatedAt: Value(DateTime.now()),
        ));
      return existing.id;
    } else {
      return await into(collectionItems).insert(
        CollectionItemsCompanion.insert(
          cardId: cardId,
          quantity: quantity,
          condition: condition,
          notes: Value(notes)
        ),
      );
    }
  }

  Future<void> removeFromCollection(int collectionItemId) async {
    await (delete(collectionItems)..where((t) => t.id.equals(collectionItemId))).go();
  }

  Future<int> getCollectionSize() async {
    final count = await collectionItems.count().get();
    return count;
  }

// Upsert operations
  Future<void> saveCard(Card card) async {
    await into(cards).insertOnConflictUpdate(card);
  }

  Future<void> saveCardImages(List<CardImage> images) async {
    await batch((batch) {
      batch.insertAll(cardImages, images, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveCardPrices(List<CardPrice> prices) async {
    await batch((batch) {
      batch.insertAll(cardPrices, prices, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveCardSets(List<CardSet> sets) async {
    await batch((batch) {
      batch.insertAll(cardSets, sets, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveBanlistInfo(BanlistInfo banlistInfo) async {
    await into(banlistInfos).insertOnConflictUpdate(banlistInfo);
  }

// Get Related Data
  Future<List<CardImage>> getCardImages(int cardId) {
    return (select(cardImages)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<List<CardPrice>> getCardPrices(int cardId) {
    return (select(cardPrices)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<List<CardSet>> getCardSets(int cardId) {
    return (select(cardSets)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<BanlistInfo?> getBanlistInfo(int cardId) {
    return (select(banlistInfos)..where((t) => t.id.equals(cardId))).getSingleOrNull();
  }
}

// Database Connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yugioh_inventory.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// Helper Classes
class CollectionItemWithCard {
  final CollectionItem collectionItem;
  final Card card;

  CollectionItemWithCard({
    required this.collectionItem,
    required this.card,
  });
}