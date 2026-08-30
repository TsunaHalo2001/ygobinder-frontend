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

  // The specific printing info
  TextColumn get setCode => text()(); // e.g., 'LOB-001'
  TextColumn get rarity => text()(); // e.g., 'Ultra Rare'

  // User organization
  IntColumn get collectionNumber => integer().withDefault(const Constant(1))();

  // Inventory details
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get condition => text().withDefault(const Constant('Near Mint'))();
  TextColumn get language => text().withDefault(const Constant('EN'))();
  BoolColumn get isFirstEdition => boolean().withDefault(const Constant(false))();
  RealColumn get priceAtPurchase => real().nullable()();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Create new indexes for faster search using raw SQL
        await customStatement('CREATE INDEX IF NOT EXISTS cards_name_idx ON cards (name)');
        await customStatement('CREATE INDEX IF NOT EXISTS cards_archetype_idx ON cards (archetype)');
        await customStatement('CREATE INDEX IF NOT EXISTS card_sets_card_id_idx ON card_sets (card_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS card_sets_set_code_idx ON card_sets (set_code)');
      }
      if (from < 3) {
        // Add new columns to CollectionItems using Migrator
        await m.addColumn(collectionItems, collectionItems.setCode);
        await m.addColumn(collectionItems, collectionItems.rarity);
        await m.addColumn(collectionItems, collectionItems.collectionNumber);
        await m.addColumn(collectionItems, collectionItems.language);
        await m.addColumn(collectionItems, collectionItems.isFirstEdition);
        await m.addColumn(collectionItems, collectionItems.priceAtPurchase);
        
        // Add indexes for the new columns using raw SQL for simplicity
        await customStatement('CREATE INDEX IF NOT EXISTS collection_items_col_num_idx ON collection_items (collection_number)');
        await customStatement('CREATE INDEX IF NOT EXISTS collection_items_print_idx ON collection_items (card_id, set_code, rarity)');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
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

  Future<DriftCard?> getCardByName(String name) {
    return (select(cards)..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<int?> getCardIdBySetCode(String setCode) async {
    final query = selectOnly(cardSets)
      ..addColumns([cardSets.cardId])
      ..where(cardSets.setCode.equals(setCode))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.read(cardSets.cardId);
  }

  Future<int?> getCardIdByFuzzySetCode(String prefix, String digits) async {
    // Pattern: prefix-[any language/edition]digits
    // e.g. CRBR-%038 matches CRBR-EN038 or CRBR-JP038
    final fuzzyPattern = '$prefix-%$digits';
    
    final query = selectOnly(cardSets)
      ..addColumns([cardSets.cardId])
      ..where(cardSets.setCode.like(fuzzyPattern))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.read(cardSets.cardId);
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
    required String setCode,
    required String rarity,
    int collectionNumber = 1,
    int quantity = 1,
    String condition = 'Near Mint',
    String? notes,
  }) async {
    final existing = await (select(collectionItems)
      ..where((t) =>
          t.cardId.equals(cardId) &
          t.setCode.equals(setCode) &
          t.rarity.equals(rarity) &
          t.condition.equals(condition) &
          t.collectionNumber.equals(collectionNumber)))
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
          setCode: setCode,
          rarity: rarity,
          collectionNumber: Value(collectionNumber),
          quantity: Value(quantity),
          condition: Value(condition),
          notes: Value(notes),
        ),
      );
    }
  }

  Future<void> removeFromCollection({
    required int collectionItemId,
    int quantityToRemove = 1,
  }) async {
    final existing = await (select(collectionItems)..where((t) => t.id.equals(collectionItemId))).getSingleOrNull();
    if (existing == null) return;

    if (existing.quantity <= quantityToRemove) {
      // Remove entirely if quantity becomes 0 or less
      await (delete(collectionItems)..where((t) => t.id.equals(collectionItemId))).go();
    } else {
      // Just decrease quantity
      await (update(collectionItems)..where((t) => t.id.equals(collectionItemId))).write(
        CollectionItemsCompanion(
          quantity: Value(existing.quantity - quantityToRemove),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> clearCollection() async {
    await delete(collectionItems).go();
  }

  Future<int> getCollectionSize() async {
    final query = selectOnly(collectionItems)..addColumns([collectionItems.id.count()]);
    final result = await query.getSingle();
    return result.read(collectionItems.id.count()) ?? 0;
  }

  Stream<int> watchTotalCardCount() {
    final quantitySum = collectionItems.quantity.sum();
    final query = selectOnly(collectionItems)..addColumns([quantitySum]);
    return query.watchSingle().map((row) => row.read(quantitySum) ?? 0);
  }

  Stream<int> watchUniqueCardCount() {
    final countColumn = collectionItems.cardId.count(distinct: true);
    final query = selectOnly(collectionItems)..addColumns([countColumn]);
    return query.watchSingle().map((row) => row.read(countColumn) ?? 0);
  }

  Stream<List<SetStat>> watchTopSets(int limit) {
    final quantitySum = collectionItems.quantity.sum();
    
    // ✅ Fix: Join on cardId, setCode, AND rarity to prevent duplicates in sets with multiple rarities (like RA04)
    final query = selectOnly(collectionItems).join([
      innerJoin(
        cardSets, 
        cardSets.cardId.equalsExp(collectionItems.cardId) & 
        cardSets.setCode.equalsExp(collectionItems.setCode) &
        cardSets.setRarity.equalsExp(collectionItems.rarity)
      ),
    ]);

    query
      ..addColumns([cardSets.setName, cardSets.setCode, quantitySum])
      ..groupBy([cardSets.setName])
      ..orderBy([OrderingTerm.desc(quantitySum)])
      ..limit(limit);

    return query.watch().map((rows) {
      return rows.map((row) {
        return SetStat(
          setName: row.read(cardSets.setName)!,
          setCode: row.read(cardSets.setCode)!,
          count: row.read(quantitySum) ?? 0,
        );
      }).toList();
    });
  }

  Stream<List<CardStat>> watchTopCards(int limit) {
    final quantitySum = collectionItems.quantity.sum();

    final query = selectOnly(collectionItems).join([
      innerJoin(cards, cards.id.equalsExp(collectionItems.cardId)),
    ]);

    query
      ..addColumns([cards.name, quantitySum])
      ..groupBy([cards.id])
      ..orderBy([OrderingTerm.desc(quantitySum)])
      ..limit(limit);

    return query.watch().map((rows) {
      return rows.map((row) {
        return CardStat(
          cardName: row.read(cards.name)!,
          count: row.read(quantitySum) ?? 0,
        );
      }).toList();
    });
  }

  Future<List<DriftCollectionItem>> getCollectionItemsByCardId(int cardId) {
    return (select(collectionItems)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<DriftCollectionItem?> getCollectionItemById(int id) {
    return (select(collectionItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<DriftCollectionItem?> findCollectionItem({
    required int cardId,
    required String setCode,
    required String rarity,
    required int collectionNumber,
  }) {
    return (select(collectionItems)
          ..where((t) =>
              t.cardId.equals(cardId) &
              t.setCode.equals(setCode) &
              t.rarity.equals(rarity) &
              t.collectionNumber.equals(collectionNumber)))
        .getSingleOrNull();
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

  Stream<List<DriftCard>> watchCardsByName(String query) {
    final safeQuery = '%$query%';
    return (select(cards)
      ..where((t) => t.name.like(safeQuery))
      ..orderBy([(t) => OrderingTerm.asc(t.name)])  // ← Add this line!
      ..limit(100))
        .watch();
  }

  // Add this inside AppDatabase
  Future<List<DriftCard>> getCardsPage({
    required int offset,
    required int limit,
    String? searchQuery,
    String? typeFilter,
    String? attributeFilter,
    String? raceFilter,
    String? subTypeFilter, // ✅ Added sub-type filter
  }) {
    var query = select(cards);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final safeQuery = '%$searchQuery%';
      
      query = query..where((t) {
        // 1. Matches Name
        final nameMatch = t.name.like(safeQuery);
        // 2. Matches Archetype
        final archetypeMatch = t.archetype.like(safeQuery);
        
        // 3. Matches Set Code (LOB-001, etc.)
        final setCodeMatch = t.id.isInQuery(
          selectOnly(cardSets)
            ..addColumns([cardSets.cardId])
            ..where(cardSets.setCode.like(safeQuery))
        );

        return nameMatch | archetypeMatch | setCodeMatch;
      });
    }

    if (typeFilter != null && typeFilter.isNotEmpty) {
      query = query..where((t) => t.type.like('%$typeFilter%'));
    }

    if (attributeFilter != null && attributeFilter.isNotEmpty) {
      query = query..where((t) => t.attribute.equals(attributeFilter));
    }

    if (raceFilter != null && raceFilter.isNotEmpty) {
      query = query..where((t) => t.race.equals(raceFilter));
    }

    if (subTypeFilter != null && subTypeFilter.isNotEmpty) {
      query = query..where((t) => t.type.like('%$subTypeFilter%'));
    }

    // Order by name so pagination is consistent
    query = query..orderBy([(t) => OrderingTerm.asc(t.name)]);

    // LIMIT X OFFSET Y is the magic of pagination
    query.limit(limit, offset: offset);
    return query.get();
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

class SetStat {
  final String setCode;
  final String setName;
  final int count;

  SetStat({
    required this.setCode,
    required this.setName,
    required this.count,
  });
}

class CardStat {
  final String cardName;
  final int count;

  CardStat({
    required this.cardName,
    required this.count,
  });
}
