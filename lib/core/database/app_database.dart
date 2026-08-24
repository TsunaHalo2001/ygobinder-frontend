import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ==========================================
// TABLE DEFINITIONS
// ==========================================
@DataClassName('DriftAppConfig')
class AppConfig extends Table {
  // Renamed from 'key' to avoid Dart reserved word conflicts during generation
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text().nullable()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

@DataClassName('DriftCard')
class Cards extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get desc => text()();
  TextColumn get race => text()();
  TextColumn get frameType => text().nullable()();
  TextColumn get humanReadableCardType => text().nullable()();
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

@DataClassName('DriftCardImage')
class CardImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  IntColumn get imageId => integer()();
  TextColumn get imageUrl => text()(); // ← Fixed: lowercase 'i'
  TextColumn get imageUrlSmall => text()();
  TextColumn get imageUrlCropped => text()();
}

@DataClassName('DriftCardPrice')
class CardPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  RealColumn get cardMarketPrice => real().nullable()(); // ← Fixed: RealColumn for math
  RealColumn get tcgPlayerPrice => real().nullable()();
  RealColumn get ebayPrice => real().nullable()();
  RealColumn get amazonPrice => real().nullable()();
  RealColumn get coolStuffIncPrice => real().nullable()();
}

@DataClassName('DriftCardSet')
class CardSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  TextColumn get setName => text()();
  TextColumn get setCode => text()();
  TextColumn get setRarity => text()();
  TextColumn get setRarityCode => text()();
  RealColumn get setPrice => real().nullable()();
}

@DataClassName('DriftBanlistInfo')
class BanlistInfos extends Table {
  IntColumn get cardId => integer().references(Cards, #id)();
  TextColumn get banTcg => text().nullable()();
  TextColumn get banOcg => text().nullable()();
  TextColumn get banGoat => text().nullable()();

  @override
  Set<Column> get primaryKey => {cardId};
}

@DataClassName('DriftCollectionItem')
class CollectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))(); // ← Fixed: added default
  TextColumn get condition => text().withDefault(const Constant('Near Mint'))(); // ← Fixed: added default
  TextColumn get notes => text().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)(); // ← Fixed: DateTimeColumn
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // ← Fixed: DateTimeColumn
}

// ==========================================
// DATABASE CLASS
// ==========================================

@DriftDatabase(tables: [
  Cards,
  CardImages,
  CardPrices,
  CardSets,
  BanlistInfos,
  CollectionItems,
  AppConfig,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database upgrades here
    },
    beforeOpen: (details) async {},
  );

  // ==========================================
  // SETTINGS / CONFIG QUERIES
  // ==========================================

  Future<String?> getSetting(String key) async {
    final query = select(appConfig)..where((t) => t.settingKey.equals(key));
    final result = await query.getSingleOrNull();
    return result?.settingValue;
  }

  Future<void> saveSetting(String key, String value) async {
    await into(appConfig).insertOnConflictUpdate(
      AppConfigCompanion(
        settingKey: Value(key),
        settingValue: Value(value),
      ),
    );
  }

  // ==========================================
  // CARD QUERIES
  // ==========================================

  Future<DriftCard?> getCardById(int cardId) { // ← Fixed: DriftCard
    return (select(cards)..where((t) => t.id.equals(cardId))).getSingleOrNull();
  }

  Future<List<DriftCard>> searchCards(String query) { // ← Fixed: DriftCard
    return (select(cards)..where((t) => t.name.like('%$query%'))..limit(20)).get();
  }

  Future<List<DriftCard>> getCardsByArchetype(String archetype) { // ← Fixed: DriftCard
    return (select(cards)
      ..where((t) => t.archetype.equals(archetype))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<DriftCard>> watchAllCards() { // ← Fixed: DriftCard
    return select(cards).watch();
  }

  // ==========================================
  // COLLECTION QUERIES
  // ==========================================

  Stream<List<CollectionItemWithCard>> watchCollection() { // ← Fixed: returns Stream, not Future
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
      ..where((t) => t.cardId.equals(cardId) & t.condition.equals(condition)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(collectionItems)..where((t) => t.id.equals(existing.id))).write(
        CollectionItemsCompanion(
          quantity: Value(existing.quantity + quantity),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return existing.id;
    } else {
      return await into(collectionItems).insert(
        CollectionItemsCompanion.insert(
          cardId: cardId,
          quantity: Value(quantity),
          condition: Value(condition),
          notes: Value(notes),
        ),
      );
    }
  }

  Future<void> removeFromCollection(int collectionItemId) async {
    await (delete(collectionItems)..where((t) => t.id.equals(collectionItemId))).go();
  }

  Future<int> getCollectionSize() async {
    final query = selectOnly(collectionItems)..addColumns([collectionItems.id.count()]);

    final result = await query.getSingle();

    return result.read(collectionItems.id.count()) ?? 0;
  }

  // ==========================================
  // UPSERT OPERATIONS
  // ==========================================

  // ← Fixed: Removed 'drift.' prefix. These classes are generated in this same file.
  Future<void> saveCard(CardsCompanion card) async {
    await into(cards).insertOnConflictUpdate(card);
  }

  Future<void> saveCardImages(List<CardImagesCompanion> images) async {
    await batch((batch) {
      batch.insertAll(cardImages, images, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveCardPrices(List<CardPricesCompanion> prices) async {
    await batch((batch) {
      batch.insertAll(cardPrices, prices, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveCardSets(List<CardSetsCompanion> sets) async {
    await batch((batch) {
      batch.insertAll(cardSets, sets, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveBanlistInfo(BanlistInfosCompanion banlistInfo) async {
    await into(banlistInfos).insertOnConflictUpdate(banlistInfo);
  }

  // ==========================================
  // GET RELATED DATA
  // ==========================================

  Future<List<DriftCardImage>> getCardImages(int cardId) { // ← Fixed: DriftCardImage
    return (select(cardImages)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<List<DriftCardPrice>> getCardPrices(int cardId) { // ← Fixed: DriftCardPrice
    return (select(cardPrices)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<List<DriftCardSet>> getCardSets(int cardId) { // ← Fixed: DriftCardSet
    return (select(cardSets)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<DriftBanlistInfo?> getBanlistInfo(int cardId) { // ← Fixed: DriftBanlistInfo
    return (select(banlistInfos)..where((t) => t.cardId.equals(cardId))).getSingleOrNull();
  }
}

// ==========================================
// DATABASE CONNECTION
// ==========================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yugioh_inventory.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// ==========================================
// HELPER CLASSES
// ==========================================

class CollectionItemWithCard {
  final DriftCollectionItem collectionItem; // ← Fixed: DriftCollectionItem
  final DriftCard card; // ← Fixed: DriftCard

  CollectionItemWithCard({
    required this.collectionItem,
    required this.card,
  });
}