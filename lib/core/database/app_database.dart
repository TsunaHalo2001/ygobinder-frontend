import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ygobinder/features/cards/data/models/card_filters.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/services/price_resolver.dart';

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
  DateTimeColumn get tcgDate => dateTime().nullable()();
  DateTimeColumn get ocgDate => dateTime().nullable()();

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
  TextColumn get banEdison => text().nullable()();
  TextColumn get banHat => text().nullable()();

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

@DataClassName('DriftDeck')
class Decks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DriftDeckCard')
class DeckCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deckId => integer().references(Decks, #id, onDelete: KeyAction.cascade)();
  IntColumn get cardId => integer().references(Cards, #id)();
  // category: 'main', 'extra', 'side'
  TextColumn get category => text()();
}

@DataClassName('DriftFavoriteCard')
class FavoriteCards extends Table {
  IntColumn get cardId => integer()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {cardId};
}

@DataClassName('DriftWantedCard')
class WantedCards extends Table {
  IntColumn get cardId => integer()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {cardId};
}

@DataClassName('DriftSetInfo')
class SetInfos extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text().nullable()();
  TextColumn get setType => text().nullable()();
  BoolColumn get isSupplemental => boolean().withDefault(const Constant(false))();
  TextColumn get publishedOn => text().nullable()();
  TextColumn get modifiedOn => text().nullable()();
  IntColumn get productCount => integer().nullable()();
  IntColumn get skuCount => integer().nullable()();
  TextColumn get setSymbolUrl => text().nullable()();
  BoolColumn get setSymbolCached => boolean().withDefault(const Constant(false))();
  TextColumn get apiUrl => text().nullable()();
  TextColumn get cardsUrl => text().nullable()();
  TextColumn get sealedUrl => text().nullable()();
  TextColumn get pricingUrl => text().nullable()();
  TextColumn get skusUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DriftUserOwnedSet')
class UserOwnedSets extends Table {
  TextColumn get setCode => text()(); // e.g. "LOB" or "CRBR"
  TextColumn get setName => text().nullable()(); // e.g. "Legend of Blue Eyes White Dragon"
  IntColumn get totalCardsOwned => integer().withDefault(const Constant(0))();
  TextColumn get setSymbolUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {setCode};
}

@DataClassName('DriftSetCardPrice')
class SetCardPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get setId => integer()();
  IntColumn get cardId => integer()();
  TextColumn get setCode => text().nullable()();
  TextColumn get printing => text()();
  RealColumn get lowPrice => real().nullable()();
  RealColumn get marketPrice => real().nullable()();
  RealColumn get previousMarketPrice => real().nullable()();
  TextColumn get lastUpdated => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {setId, cardId, printing}
      ];
}

@DataClassName('DriftCurrencyRate')
class CurrencyRates extends Table {
  TextColumn get currencyCode => text()(); // e.g. "EUR", "MXN", "JPY"
  RealColumn get rateToUsd => real()(); // e.g. 19.85 MXN per 1 USD
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {currencyCode};
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
  Decks,
  DeckCards,
  FavoriteCards,
  WantedCards,
  SetInfos,
  UserOwnedSets,
  SetCardPrices,
  CurrencyRates,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Opens the database with a custom executor (used by tests).
  AppDatabase.forTesting(super.executor);

  static const _indexStatements = [
    'CREATE INDEX IF NOT EXISTS cards_name_idx ON cards (name)',
    'CREATE INDEX IF NOT EXISTS cards_archetype_idx ON cards (archetype)',
    'CREATE INDEX IF NOT EXISTS card_sets_card_id_idx ON card_sets (card_id)',
    'CREATE INDEX IF NOT EXISTS card_sets_set_code_idx ON card_sets (set_code)',
    'CREATE INDEX IF NOT EXISTS card_images_card_id_idx ON card_images (card_id)',
    'CREATE INDEX IF NOT EXISTS card_prices_card_id_idx ON card_prices (card_id)',
    'CREATE INDEX IF NOT EXISTS collection_items_col_num_idx ON collection_items (collection_number)',
    'CREATE INDEX IF NOT EXISTS collection_items_print_idx ON collection_items (card_id, set_code, rarity)',
    'CREATE INDEX IF NOT EXISTS deck_cards_deck_id_idx ON deck_cards (deck_id)',
    'CREATE INDEX IF NOT EXISTS set_card_prices_card_id_idx ON set_card_prices (card_id)',
  ];

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // v2 only added indexes; they are now ensured in beforeOpen.
      if (from < 3) {
        // Add new columns to CollectionItems using Migrator
        await m.addColumn(collectionItems, collectionItems.setCode);
        await m.addColumn(collectionItems, collectionItems.rarity);
        await m.addColumn(collectionItems, collectionItems.collectionNumber);
        await m.addColumn(collectionItems, collectionItems.language);
        await m.addColumn(collectionItems, collectionItems.isFirstEdition);
        await m.addColumn(collectionItems, collectionItems.priceAtPurchase);
      }
      if (from < 5) {
        // Ensure columns exist with correct DateTime type (Handles both v4 and v5)
        await m.addColumn(cards, cards.tcgDate);
        await m.addColumn(cards, cards.ocgDate);
      }
      if (from < 6) {
        // Add Edison banlist to BanlistInfos table
        await m.addColumn(banlistInfos, banlistInfos.banEdison);
      }
      if (from < 7) {
        // Add Deck tables
        await m.createTable(decks);
        await m.createTable(deckCards);
      } else if (from < 8) {
        // Only add syncId if the table already existed (v7)
        // If from < 7, the table was created above with the syncId column included.
        await m.addColumn(decks, decks.syncId);
      }
      if (from < 9) {
        await m.createTable(favoriteCards);
      }
      if (from < 10) {
        await m.createTable(wantedCards);
      }
      if (from < 11) {
        await m.createTable(setInfos);
      }
      if (from < 12) {
        await m.createTable(userOwnedSets);
        // Automatically scan existing collection and populate userOwnedSets for upgrading users!
        await refreshUserOwnedSets();
      }
      if (from < 13) {
        await m.createTable(setCardPrices);
      }
      if (from < 14) {
        await customStatement('ALTER TABLE set_card_prices ADD COLUMN set_code TEXT').catchError((_) {});
      }
      if (from < 15) {
        await customStatement('ALTER TABLE set_card_prices ADD COLUMN previous_market_price REAL').catchError((_) {});
      }
      if (from < 16) {
        await m.createTable(currencyRates);
      }
      if (from < 17) {
        await m.addColumn(banlistInfos, banlistInfos.banHat);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (!details.wasCreated) {
        await customStatement('ALTER TABLE set_card_prices ADD COLUMN set_code TEXT').catchError((_) {});
        await customStatement('ALTER TABLE set_card_prices ADD COLUMN previous_market_price REAL').catchError((_) {});
      }
      // Indexes are (re)ensured on every open: older versions only created
      // them in onUpgrade, so fresh installs never had them.
      for (final statement in _indexStatements) {
        await customStatement(statement).catchError((_) {});
      }
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

  /// Whether the global card table has any rows.
  Future<bool> hasCards() async {
    final row = await (selectOnly(cards)
          ..addColumns([cards.id])
          ..limit(1))
        .getSingleOrNull();
    return row != null;
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

  // ==========================================
  // COLLECTION QUERIES
  // ==========================================

  /// Fast query for deck builder: watches only collectionItems to map cardId -> totalQuantity
  Stream<Map<int, int>> watchCollectionCardQuantities() {
    return select(collectionItems).watch().map((items) {
      final counts = <int, int>{};
      for (final item in items) {
        counts[item.cardId] = (counts[item.cardId] ?? 0) + item.quantity;
      }
      return counts;
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

    int resultId;
    if (existing != null) {
      await (update(collectionItems)..where((t) => t.id.equals(existing.id))).write(
        CollectionItemsCompanion(
          quantity: Value(existing.quantity + quantity),
          updatedAt: Value(DateTime.now()),
        ),
      );
      resultId = existing.id;
    } else {
      resultId = await into(collectionItems).insert(
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
    await refreshUserOwnedSets();
    return resultId;
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
    await refreshUserOwnedSets();
  }

  /// Removes every account-specific row (collection, decks, favorites,
  /// wanted, owned sets). Global card data and settings are kept.
  Future<void> clearUserData() async {
    await transaction(() async {
      await delete(collectionItems).go();
      await delete(deckCards).go();
      await delete(decks).go();
      await delete(favoriteCards).go();
      await delete(wantedCards).go();
      await delete(userOwnedSets).go();
    });
  }

  Future<int> deleteQuoteCollection() async {
    final deletedCount = await (delete(collectionItems)..where((t) => t.collectionNumber.equals(0))).go();
    await refreshUserOwnedSets();
    return deletedCount;
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

  Stream<List<CardPriceStat>> watchTopExpensiveCards(int limit) {
    return _watchDerived({collectionItems, setCardPrices}, () => _topExpensiveCards(limit));
  }

  Stream<double> watchTotalCollectionValue() {
    return _watchDerived({collectionItems, setCardPrices}, () => _collectionValue(quote: false));
  }

  Stream<double> watchQuoteCollectionValue() {
    return _watchDerived({collectionItems, setCardPrices}, () => _collectionValue(quote: true));
  }

  /// Emits [compute] on listen and again whenever any of [tables] changes.
  ///
  /// Uses drift's table-update notifications (no query just to detect
  /// changes) and coalesces bursts: while a computation runs, further
  /// changes schedule exactly one more run, so results are never emitted
  /// out of order.
  Stream<T> _watchDerived<T>(Set<TableInfo> tables, Future<T> Function() compute) {
    late StreamController<T> controller;
    StreamSubscription<Set<TableUpdate>>? updatesSub;
    var running = false;
    var dirty = false;

    Future<void> run() async {
      if (running) {
        dirty = true;
        return;
      }
      running = true;
      do {
        dirty = false;
        try {
          final value = await compute();
          if (!dirty && !controller.isClosed) controller.add(value);
        } catch (e, stack) {
          if (!dirty && !controller.isClosed) controller.addError(e, stack);
        }
      } while (dirty && !controller.isClosed);
      running = false;
    }

    controller = StreamController<T>(
      onListen: () {
        run();
        updatesSub = tableUpdates(TableUpdateQuery.onAllTables(tables)).listen((_) => run());
      },
      onCancel: () async {
        await updatesSub?.cancel();
        await controller.close();
      },
    );
    return controller.stream;
  }

  /// Loads every price needed to value the given cards.
  Future<PriceResolver> _loadPriceResolver(List<int> cardIds) async {
    final (globalPrices, setPrices) = await (
      (select(cardPrices)..where((t) => t.cardId.isIn(cardIds))).get(),
      (select(setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get(),
    ).wait;
    return PriceResolver(globalPrices: globalPrices, setPrices: setPrices);
  }

  /// Total value of the real collections ([quote] false) or of the quote
  /// collection #0 ([quote] true).
  Future<double> _collectionValue({required bool quote}) async {
    final items = await (select(collectionItems)
          ..where((t) => quote ? t.collectionNumber.equals(0) : t.collectionNumber.isNotValue(0)))
        .get();
    if (items.isEmpty) return 0.0;

    final resolver = await _loadPriceResolver(items.map((i) => i.cardId).toSet().toList());
    var totalValue = 0.0;
    for (final item in items) {
      totalValue += resolver.collectionItemPrice(item) * item.quantity;
    }
    return totalValue;
  }

  Future<List<CardPriceStat>> _topExpensiveCards(int limit) async {
    final items = await select(collectionItems).get();
    if (items.isEmpty) return [];

    final itemsByCard = <int, List<DriftCollectionItem>>{};
    for (final item in items) {
      itemsByCard.putIfAbsent(item.cardId, () => []).add(item);
    }
    final cardIds = itemsByCard.keys.toList();

    final (namesRows, resolver) = await (
      (selectOnly(cards)
            ..addColumns([cards.id, cards.name])
            ..where(cards.id.isIn(cardIds)))
          .get(),
      _loadPriceResolver(cardIds),
    ).wait;
    final cardNameById = {for (final r in namesRows) r.read(cards.id)!: r.read(cards.name)!};

    final stats = <CardPriceStat>[];
    for (final entry in itemsByCard.entries) {
      final name = cardNameById[entry.key];
      if (name == null) continue;

      var maxOwnedCardPrice = 0.0;
      for (final item in entry.value) {
        final itemPrice = resolver.collectionItemPrice(item);
        if (itemPrice > maxOwnedCardPrice) maxOwnedCardPrice = itemPrice;
      }

      if (maxOwnedCardPrice > 0.0) {
        stats.add(CardPriceStat(cardId: entry.key, cardName: name, price: maxOwnedCardPrice));
      }
    }

    stats.sort((a, b) => b.price.compareTo(a.price));
    return stats.take(limit).toList();
  }

  Stream<YgoCard?> watchNewestCard() {
    final query = select(cards).join([
      innerJoin(collectionItems, collectionItems.cardId.equalsExp(cards.id)),
    ]);

    query
      ..where(cards.tcgDate.isNotNull())
      ..orderBy([OrderingTerm.desc(cards.tcgDate), OrderingTerm.asc(cards.name)])
      ..limit(1);

    return query.watch().asyncMap((rows) async {
      if (rows.isEmpty) return null;
      final driftCard = rows.first.readTable(cards);
      final images = await getCardImages(driftCard.id);
      return CardMapper.toYgoCard(driftCard, images: images);
    });
  }

  Stream<YgoCard?> watchOldestCard() {
    final query = select(cards).join([
      innerJoin(collectionItems, collectionItems.cardId.equalsExp(cards.id)),
    ]);

    query
      ..where(cards.tcgDate.isNotNull())
      ..orderBy([OrderingTerm.asc(cards.tcgDate), OrderingTerm.asc(cards.name)])
      ..limit(1);

    return query.watch().asyncMap((rows) async {
      if (rows.isEmpty) return null;
      final driftCard = rows.first.readTable(cards);
      final images = await getCardImages(driftCard.id);
      return CardMapper.toYgoCard(driftCard, images: images);
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

  Future<List<DriftCard>> getCardsPage({
    required int offset,
    required int limit,
    CardFilters filters = const CardFilters(),
  }) {
    final searchQuery = filters.search;
    final typeFilter = filters.type;
    final attributeFilter = filters.attribute;
    final raceFilter = filters.race;
    final subTypeFilter = filters.subType;
    final frameFilter = filters.frame;
    final levelFilter = filters.level;
    final scaleFilter = filters.scale;
    final linkValFilter = filters.linkVal;
    final atkFilter = filters.atk;
    final atkOperator = filters.atkOperator;
    final atkShowQuestionMark = filters.atkShowQuestionMark;
    final defFilter = filters.def;
    final defOperator = filters.defOperator;
    final defShowQuestionMark = filters.defShowQuestionMark;
    final sortBy = filters.sortBy;
    final sortDescending = filters.sortDescending;

    var query = select(cards);

    if (searchQuery.isNotEmpty) {
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

    if (frameFilter != null && frameFilter.isNotEmpty) {
      // ✅ Use LIKE to include hybrids (e.g. 'fusion' matches 'fusion_pendulum')
      query = query..where((t) => t.frameType.like('%$frameFilter%'));
    }

    if (levelFilter != null) {
      if (levelFilter == 0) {
        // ✅ If level is 0, exclude Link monsters (which technically have no level)
        query = query..where((t) => t.level.equals(0) & t.type.like('%Link%').not());
      } else {
        query = query..where((t) => t.level.equals(levelFilter));
      }
    }

    if (scaleFilter != null) {
      query = query..where((t) => t.scale.equals(scaleFilter));
    }

    if (linkValFilter != null) {
      query = query..where((t) => t.linkVal.equals(linkValFilter));
    }

    if (atkFilter != null) {
      if (atkOperator == '>=') {
        query = query..where((t) => t.atk.isBiggerOrEqualValue(atkFilter));
      } else if (atkOperator == '<=') {
        query = query..where((t) => t.atk.isSmallerOrEqualValue(atkFilter));
      } else {
        query = query..where((t) => t.atk.equals(atkFilter));
      }
    }

    if (atkShowQuestionMark != null) {
      if (atkShowQuestionMark) {
        query = query..where((t) => t.atk.equals(-1));
      } else {
        query = query..where((t) => t.atk.equals(-1).not());
      }
    }

    if (defFilter != null) {
      if (defOperator == '>=') {
        query = query..where((t) => t.def.isBiggerOrEqualValue(defFilter));
      } else if (defOperator == '<=') {
        query = query..where((t) => t.def.isSmallerOrEqualValue(defFilter));
      } else {
        query = query..where((t) => t.def.equals(defFilter));
      }
    }

    if (defShowQuestionMark != null) {
      if (defShowQuestionMark) {
        query = query..where((t) => t.def.equals(-1));
      } else {
        query = query..where((t) => t.def.equals(-1).not());
      }
    }

    if (filters.onlyGoat) {
      final goatCutoff = DateTime(2005, 8, 17, 23, 59, 59);
      query = query..where((t) => t.tcgDate.isNotNull() & t.tcgDate.isSmallerOrEqualValue(goatCutoff));
      query = query..where((t) => t.frameType.like('%synchro%').not() &
                                  t.frameType.like('%xyz%').not() &
                                  t.frameType.like('%pendulum%').not() &
                                  t.frameType.like('%link%').not() &
                                  t.type.like('%Tuner%').not() &
                                  t.type.like('%Link%').not() &
                                  t.type.like('%Synchro%').not() &
                                  t.type.like('%XYZ%').not());
      query = query..where((t) {
        final bannedInGoat = selectOnly(banlistInfos)
          ..addColumns([banlistInfos.cardId])
          ..where(
            banlistInfos.banGoat.equals('Banned') |
            banlistInfos.banGoat.equals('Forbidden') |
            banlistInfos.banGoat.equals('0')
          );
        return t.id.isInQuery(bannedInGoat).not();
      });
    }

    if (filters.onlyEdison) {
      // ✅ Filter for cards available in Edison
      query = query..where((t) {
        return t.id.isInQuery(
          selectOnly(banlistInfos)
            ..addColumns([banlistInfos.cardId])
            ..where(banlistInfos.banEdison.isNotNull())
        );
      });
    }

    if (filters.onlyHat) {
      final hatCutoff = DateTime(2014, 5, 16, 23, 59, 59);
      query = query..where((t) => t.tcgDate.isNotNull() & t.tcgDate.isSmallerOrEqualValue(hatCutoff));
      query = query..where((t) => t.frameType.like('%pendulum%').not() &
                                  t.frameType.like('%link%').not() &
                                  t.type.like('%Link%').not());
      query = query..where((t) {
        final bannedInHat = selectOnly(banlistInfos)
          ..addColumns([banlistInfos.cardId])
          ..where(
            banlistInfos.banHat.equals('Banned') |
            banlistInfos.banHat.equals('Forbidden') |
            banlistInfos.banHat.equals('0')
          );
        return t.id.isInQuery(bannedInHat).not();
      });
    }

    if (filters.onlyFavorites) {
      query = query..where((t) {
        return t.id.isInQuery(
          selectOnly(favoriteCards)..addColumns([favoriteCards.cardId])
        );
      });
    }

    if (filters.onlyWanted) {
      query = query..where((t) {
        return t.id.isInQuery(
          selectOnly(wantedCards)..addColumns([wantedCards.cardId])
        );
      });
    }

    // ✅ Dynamic Ordering
    query = query..orderBy([
      (t) {
        final mode = sortDescending ? OrderingMode.desc : OrderingMode.asc;
        switch (sortBy) {
          case 'atk':
            // Monsters with stats first, then sort by value, Spells/Traps last
            return OrderingTerm(expression: t.atk, mode: mode, nulls: NullsOrder.last);
          case 'def':
            return OrderingTerm(expression: t.def, mode: mode, nulls: NullsOrder.last);
          case 'tcgDate':
            return OrderingTerm(expression: t.tcgDate, mode: mode, nulls: NullsOrder.last);
          case 'name':
          default:
            return OrderingTerm(expression: t.name, mode: mode);
        }
      }
    ]);

    // LIMIT X OFFSET Y is the magic of pagination
    query.limit(limit, offset: offset);
    return query.get();
  }

  // ==========================================
  // DECK QUERIES
  // ==========================================

  Future<int> saveDeck(String name, Map<String, List<int>> categorizedCards, {String? syncId}) async {
    return transaction(() async {
      // Check if a deck with the same name already exists (case-insensitive)
      final existing = await (select(decks)
            ..where((t) => t.name.lower().equals(name.toLowerCase())))
          .getSingleOrNull();

      int deckId;
      String currentSyncId;

      if (existing != null) {
        deckId = existing.id;
        currentSyncId = existing.syncId ?? syncId ?? const Uuid().v4();

        // Replace/update deck details and timestamp
        await (update(decks)..where((t) => t.id.equals(deckId))).write(
          DecksCompanion(
            name: Value(name),
            syncId: Value(currentSyncId),
            updatedAt: Value(DateTime.now()),
          ),
        );

        // Delete old cards for this deck
        await (delete(deckCards)..where((t) => t.deckId.equals(deckId))).go();
      } else {
        currentSyncId = syncId ?? const Uuid().v4();
        deckId = await into(decks).insert(
          DecksCompanion.insert(
            name: name,
            syncId: Value(currentSyncId),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      await _insertDeckCards(deckId, categorizedCards);
      return deckId;
    });
  }

  // ==========================================
  // FAVORITES / WANTED QUERIES
  // ==========================================
  // Both tables share the same shape (cardId PK, syncId, timestamps), so the
  // logic lives in the generic helpers below.

  Stream<bool> watchIsFavorite(int cardId) => _watchFlag(favoriteCards, favoriteCards.cardId, cardId);

  Future<bool> toggleFavorite(int cardId, {String? syncId}) {
    return _toggleFlag(
      favoriteCards,
      favoriteCards.cardId,
      cardId,
      (id, now) => FavoriteCardsCompanion.insert(
        cardId: Value(cardId),
        syncId: Value(syncId ?? id),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Inserts or replaces favorites pulled from the cloud in one batch.
  Future<void> upsertFavoriteCards(List<CardFlagRecord> records) {
    return batch((b) => b.insertAll(
          favoriteCards,
          [
            for (final r in records)
              FavoriteCardsCompanion.insert(
                cardId: Value(r.cardId),
                syncId: Value(r.syncId),
                createdAt: Value(r.updatedAt),
                updatedAt: Value(r.updatedAt),
              ),
          ],
          mode: InsertMode.insertOrReplace,
        ));
  }

  Stream<bool> watchIsWanted(int cardId) => _watchFlag(wantedCards, wantedCards.cardId, cardId);

  Future<bool> toggleWanted(int cardId, {String? syncId}) {
    return _toggleFlag(
      wantedCards,
      wantedCards.cardId,
      cardId,
      (id, now) => WantedCardsCompanion.insert(
        cardId: Value(cardId),
        syncId: Value(syncId ?? id),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Inserts or replaces wanted cards pulled from the cloud in one batch.
  Future<void> upsertWantedCards(List<CardFlagRecord> records) {
    return batch((b) => b.insertAll(
          wantedCards,
          [
            for (final r in records)
              WantedCardsCompanion.insert(
                cardId: Value(r.cardId),
                syncId: Value(r.syncId),
                createdAt: Value(r.updatedAt),
                updatedAt: Value(r.updatedAt),
              ),
          ],
          mode: InsertMode.insertOrReplace,
        ));
  }

  Stream<bool> _watchFlag<T extends Table, D>(TableInfo<T, D> table, GeneratedColumn<int> cardIdColumn, int cardId) {
    return (select(table)..where((_) => cardIdColumn.equals(cardId))).watch().map((rows) => rows.isNotEmpty);
  }

  /// Removes the flag if present, otherwise inserts [buildRow] (with a fresh
  /// sync id). Returns the new flag state.
  Future<bool> _toggleFlag<T extends Table, D>(
    TableInfo<T, D> table,
    GeneratedColumn<int> cardIdColumn,
    int cardId,
    Insertable<D> Function(String newSyncId, DateTime now) buildRow,
  ) {
    return transaction(() async {
      final removed = await (delete(table)..where((_) => cardIdColumn.equals(cardId))).go();
      if (removed > 0) return false;
      await into(table).insert(buildRow(const Uuid().v4(), DateTime.now()));
      return true;
    });
  }

  // ==========================================
  // SET INFOS QUERIES
  // ==========================================

  Future<List<DriftSetInfo>> getAllSetInfos() {
    return (select(setInfos)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Future<void> upsertDeck(String syncId, String name, Map<String, List<int>> categorizedCards, DateTime updatedAt) async {
    await transaction(() async {
      final existing = await (select(decks)..where((t) => t.syncId.equals(syncId))).getSingleOrNull();
      
      int deckId;
      if (existing != null) {
        deckId = existing.id;
        await (update(decks)..where((t) => t.id.equals(deckId))).write(
          DecksCompanion(
            name: Value(name),
            updatedAt: Value(updatedAt),
          ),
        );
        // Clear old cards
        await (delete(deckCards)..where((t) => t.deckId.equals(deckId))).go();
      } else {
        deckId = await into(decks).insert(
          DecksCompanion.insert(
            name: name,
            syncId: Value(syncId),
            createdAt: Value(updatedAt),
            updatedAt: Value(updatedAt),
          ),
        );
      }

      await _insertDeckCards(deckId, categorizedCards);
    });
  }

  /// Inserts the deck's cards in one batch, skipping card ids that are not in
  /// the local database (they would violate the foreign key, error 787).
  Future<void> _insertDeckCards(int deckId, Map<String, List<int>> categorizedCards) async {
    final allCardIds = categorizedCards.values.expand((e) => e).toSet().toList();
    if (allCardIds.isEmpty) return;

    final existingRows = await (selectOnly(cards)
          ..addColumns([cards.id])
          ..where(cards.id.isIn(allCardIds)))
        .get();
    final existingCardIds = existingRows.map((r) => r.read(cards.id)).toSet();

    final rows = [
      for (final entry in categorizedCards.entries)
        for (final cardId in entry.value)
          if (existingCardIds.contains(cardId))
            DeckCardsCompanion.insert(deckId: deckId, cardId: cardId, category: entry.key),
    ];
    if (rows.isEmpty) return;
    await batch((b) => b.insertAll(deckCards, rows));
  }

  Future<DriftDeck?> getDeckBySyncId(String syncId) {
    return (select(decks)..where((t) => t.syncId.equals(syncId))).getSingleOrNull();
  }

  Stream<List<DriftDeck>> watchAllDecks() {
    return select(decks).watch();
  }

  Future<DriftDeck?> getDeckById(int deckId) {
    return (select(decks)..where((t) => t.id.equals(deckId))).getSingleOrNull();
  }

  Future<List<DriftDeckCard>> getDeckCards(int deckId) {
    return (select(deckCards)..where((t) => t.deckId.equals(deckId))).get();
  }

  Future<void> deleteDeck(int deckId) async {
    await (delete(decks)..where((t) => t.id.equals(deckId))).go();
  }

  // ==========================================
  // RETIRED CARD IDS
  // ==========================================
  // The card data sometimes changes a card's id and keeps the old id only as
  // one of its alternate artworks (Dark Magician 46986414 -> 46986420). The
  // full sync never deletes card rows, so the old row stays behind without
  // images, sets or prices, while the user's data still points at it.

  /// Maps each retired card id to the card that now owns it: an artwork id
  /// that is not itself a current card (current cards always have images).
  /// Empty until the card data has been synced.
  Future<Map<int, int>> getRetiredCardIdAliases() async {
    final rows = await customSelect(
      'SELECT ci.image_id AS old_id, ci.card_id AS new_id FROM card_images ci '
      'WHERE ci.image_id != ci.card_id '
      'AND NOT EXISTS (SELECT 1 FROM card_images live WHERE live.card_id = ci.image_id)',
      readsFrom: {cardImages},
    ).get();
    return {for (final r in rows) r.read<int>('old_id'): r.read<int>('new_id')};
  }

  /// Moves inventory, deck, favorite and wanted entries from retired card ids
  /// to their current ids, then deletes the retired card rows nothing points
  /// at any more. Returns what changed so it can be pushed to the cloud.
  Future<RetiredCardIdRemap> remapRetiredCardIds() async {
    final aliases = await getRetiredCardIdAliases();
    return transaction(() async {
      final inventory = <({DriftCollectionItem removed, DriftCollectionItem kept})>[];
      final deckIds = <int>{};
      var favorites = <CardIdChange>[];
      var wanted = <CardIdChange>[];

      if (aliases.isNotEmpty) {
        final oldItems = await (select(collectionItems)..where((t) => t.cardId.isIn(aliases.keys))).get();
        for (final item in oldItems) {
          final newId = aliases[item.cardId]!;
          final target = await findCollectionItem(
            cardId: newId,
            setCode: item.setCode,
            rarity: item.rarity,
            collectionNumber: item.collectionNumber,
          );
          final int keptId;
          if (target != null) {
            // The same printing is already stored under the current id: merge.
            await (update(collectionItems)..where((t) => t.id.equals(target.id))).write(
              CollectionItemsCompanion(
                quantity: Value(target.quantity + item.quantity),
                updatedAt: Value(DateTime.now()),
              ),
            );
            await (delete(collectionItems)..where((t) => t.id.equals(item.id))).go();
            keptId = target.id;
          } else {
            await (update(collectionItems)..where((t) => t.id.equals(item.id)))
                .write(CollectionItemsCompanion(cardId: Value(newId)));
            keptId = item.id;
          }
          inventory.add((removed: item, kept: (await getCollectionItemById(keptId))!));
        }

        final oldDeckCards = await (select(deckCards)..where((t) => t.cardId.isIn(aliases.keys))).get();
        for (final row in oldDeckCards) {
          await (update(deckCards)..where((t) => t.id.equals(row.id)))
              .write(DeckCardsCompanion(cardId: Value(aliases[row.cardId]!)));
          deckIds.add(row.deckId);
        }

        favorites = await _remapFlagCardIds(favoriteCards, favoriteCards.cardId, favoriteCards.syncId, aliases);
        wanted = await _remapFlagCardIds(wantedCards, wantedCards.cardId, wantedCards.syncId, aliases);
      }

      final removedCards = await deleteUnreferencedCards(aliases.keys);

      return RetiredCardIdRemap(
        inventory: inventory,
        deckIds: deckIds,
        favorites: favorites,
        wanted: wanted,
        removedCards: removedCards,
      );
    });
  }

  /// Deletes the card rows in [cardIds] that no inventory or deck entry
  /// points at, together with their related rows. Returns how many cards
  /// were deleted.
  Future<int> deleteUnreferencedCards(Iterable<int> cardIds) async {
    final ids = cardIds.toList();
    if (ids.isEmpty) return 0;
    return transaction(() async {
      var removed = 0;
      // Chunked to stay under SQLite's bound-variable limit.
      for (var i = 0; i < ids.length; i += 500) {
        final chunk = ids.sublist(i, i + 500 > ids.length ? ids.length : i + 500);
        final unreferenced = (await (select(cards)
                  ..where((t) =>
                      t.id.isIn(chunk) &
                      t.id.isNotInQuery(selectOnly(collectionItems)..addColumns([collectionItems.cardId])) &
                      t.id.isNotInQuery(selectOnly(deckCards)..addColumns([deckCards.cardId]))))
                .get())
            .map((c) => c.id)
            .toList();
        if (unreferenced.isEmpty) continue;
        await (delete(cardImages)..where((t) => t.cardId.isIn(unreferenced))).go();
        await (delete(cardPrices)..where((t) => t.cardId.isIn(unreferenced))).go();
        await (delete(cardSets)..where((t) => t.cardId.isIn(unreferenced))).go();
        await (delete(banlistInfos)..where((t) => t.cardId.isIn(unreferenced))).go();
        removed += await (delete(cards)..where((t) => t.id.isIn(unreferenced))).go();
      }
      return removed;
    });
  }

  /// Moves favorite/wanted flags off retired ids. When the current id is
  /// already flagged, the old flag is just dropped.
  Future<List<CardIdChange>> _remapFlagCardIds<T extends Table, D>(
    TableInfo<T, D> table,
    GeneratedColumn<int> cardIdColumn,
    GeneratedColumn<String> syncIdColumn,
    Map<int, int> aliases,
  ) async {
    final rows = await (selectOnly(table)
          ..addColumns([cardIdColumn])
          ..where(cardIdColumn.isIn(aliases.keys)))
        .get();
    final changes = <CardIdChange>[];
    for (final row in rows) {
      final oldId = row.read(cardIdColumn)!;
      final newId = aliases[oldId]!;
      final existing = await (selectOnly(table)
            ..addColumns([syncIdColumn])
            ..where(cardIdColumn.equals(newId)))
          .getSingleOrNull();
      if (existing != null) {
        await (delete(table)..where((_) => cardIdColumn.equals(oldId))).go();
      } else {
        await (update(table)..where((_) => cardIdColumn.equals(oldId)))
            .write(RawValuesInsertable<D>({cardIdColumn.name: Variable.withInt(newId)}));
      }
      final current = await (selectOnly(table)
            ..addColumns([syncIdColumn])
            ..where(cardIdColumn.equals(newId)))
          .getSingle();
      changes.add((oldId: oldId, newId: newId, syncId: current.read(syncIdColumn)));
    }
    return changes;
  }

  // ==========================================
  // USER OWNED SETS QUERIES
  // ==========================================

  Future<List<DriftUserOwnedSet>> getUserOwnedSets() {
    return (select(userOwnedSets)..orderBy([(t) => OrderingTerm.desc(t.totalCardsOwned)])).get();
  }

  Future<void> refreshUserOwnedSets() async {
    await transaction(() async {
      final items = await select(collectionItems).get();
      if (items.isEmpty) {
        await delete(userOwnedSets).go();
        return;
      }

      final ownedSetCounts = <String, int>{};
      for (final item in items) {
        final rawSetCode = item.setCode.trim();
        if (rawSetCode.isEmpty) continue;

        final baseCode = rawSetCode.contains('-') ? rawSetCode.split('-').first.toUpperCase() : rawSetCode.toUpperCase();
        ownedSetCounts[baseCode] = (ownedSetCounts[baseCode] ?? 0) + item.quantity;
      }

      if (ownedSetCounts.isEmpty) {
        await delete(userOwnedSets).go();
        return;
      }

      final allSetInfos = await select(setInfos).get();
      final setInfoByAbbr = {
        for (final info in allSetInfos)
          if (info.abbreviation != null && info.abbreviation!.isNotEmpty)
            info.abbreviation!.toUpperCase(): info
      };
      final setInfoByName = {
        for (final info in allSetInfos) info.name.toUpperCase(): info
      };

      // Only codes unknown to setInfos need a name from card_sets; look those
      // up individually instead of loading the whole (100k+ rows) table.
      final setNameByAbbr = <String, String>{};
      for (final baseCode in ownedSetCounts.keys) {
        if (setInfoByAbbr.containsKey(baseCode)) continue;
        final row = await (selectOnly(cardSets)
              ..addColumns([cardSets.setName])
              ..where(cardSets.setCode.like('$baseCode-%') | cardSets.setCode.equals(baseCode))
              ..orderBy([OrderingTerm.asc(cardSets.id)])
              ..limit(1))
            .getSingleOrNull();
        final name = row?.read(cardSets.setName);
        if (name != null) setNameByAbbr[baseCode] = name;
      }

      final companions = <UserOwnedSetsCompanion>[];
      final now = DateTime.now();

      for (final entry in ownedSetCounts.entries) {
        final baseCode = entry.key;
        final totalOwned = entry.value;

        final setInfo = setInfoByAbbr[baseCode] ??
            setInfoByName[setNameByAbbr[baseCode]?.toUpperCase() ?? ''];

        final name = setInfo?.name ?? setNameByAbbr[baseCode] ?? baseCode;
        final symbolUrl = setInfo?.setSymbolUrl;

        companions.add(
          UserOwnedSetsCompanion.insert(
            setCode: baseCode,
            setName: Value(name),
            totalCardsOwned: Value(totalOwned),
            setSymbolUrl: Value(symbolUrl),
            updatedAt: Value(now),
          ),
        );
      }

      await delete(userOwnedSets).go();
      await batch((b) {
        b.insertAll(userOwnedSets, companions, mode: InsertMode.insertOrReplace);
      });
    });
  }

  // ==========================================
  // SET CARD PRICES QUERIES
  // ==========================================

  Future<List<DriftSetCardPrice>> getPricesForCard(int cardId) {
    return (select(setCardPrices)..where((t) => t.cardId.equals(cardId))).get();
  }

  Future<void> deleteSetCardPricesForCard(int cardId) async {
    await (delete(setCardPrices)..where((t) => t.cardId.equals(cardId))).go();
  }

  Future<void> saveSetCardPrices(List<SetCardPricesCompanion> prices) async {
    try {
      await batch((b) {
        b.insertAll(setCardPrices, prices, mode: InsertMode.insertOrReplace);
      });
    } catch (e) {
      // Self-heal: ensure set_code and previous_market_price columns exist on live connections
      await customStatement('ALTER TABLE set_card_prices ADD COLUMN set_code TEXT').catchError((_) {});
      await customStatement('ALTER TABLE set_card_prices ADD COLUMN previous_market_price REAL').catchError((_) {});
      await batch((b) {
        b.insertAll(setCardPrices, prices, mode: InsertMode.insertOrReplace);
      });
    }
  }

  Future<List<DriftSetCardPrice>> getSetCardPricesForSet(int setId) {
    return (select(setCardPrices)..where((t) => t.setId.equals(setId))).get();
  }

  /// Deletes price rows whose card id does not exist (legacy rows keyed by
  /// TCGplayer product id).
  Future<int> deleteOrphanSetCardPrices() {
    return customUpdate(
      'DELETE FROM set_card_prices WHERE card_id NOT IN (SELECT id FROM cards)',
      updates: {setCardPrices},
      updateKind: UpdateKind.delete,
    );
  }

  /// Returns one printing per card for every card that has a printing whose
  /// code starts with `PREFIX-` (e.g. `LOB` → `LOB-EN001`).
  Future<List<CardPrinting>> getCardPrintingsBySetPrefix(String prefix) async {
    final query = select(cardSets).join([
      innerJoin(cards, cards.id.equalsExp(cardSets.cardId)),
    ])
      ..where(cardSets.setCode.like('${prefix.toUpperCase()}-%'));

    final rows = await query.get();
    final byCard = <int, CardPrinting>{};
    for (final row in rows) {
      final cs = row.readTable(cardSets);
      byCard.putIfAbsent(
        cs.cardId,
        () => CardPrinting(cardId: cs.cardId, setCode: cs.setCode, cardName: row.readTable(cards).name),
      );
    }
    return byCard.values.toList();
  }

  Stream<List<DriftSetCardPrice>> watchPricesForCard(int cardId) {
    return (select(setCardPrices)..where((t) => t.cardId.equals(cardId))).watch();
  }

  // ==========================================
  // CURRENCY RATES QUERIES
  // ==========================================

  Future<void> saveCurrencyRates(List<CurrencyRatesCompanion> rates) async {
    await batch((b) {
      b.insertAll(currencyRates, rates, mode: InsertMode.insertOrReplace);
    });
  }

  Stream<List<DriftCurrencyRate>> watchAllCurrencyRates() {
    return select(currencyRates).watch();
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


/// A favorite/wanted flag as stored in the cloud.
typedef CardFlagRecord = ({int cardId, String syncId, DateTime updatedAt});

/// A favorite/wanted flag moved from a retired card id to the current one.
typedef CardIdChange = ({int oldId, int newId, String? syncId});

/// What [AppDatabase.remapRetiredCardIds] changed.
class RetiredCardIdRemap {
  /// Inventory rows moved off a retired id: [removed] is the row as it was,
  /// [kept] is the row that now holds it (merged into an existing one if the
  /// same printing was already stored under the current id).
  final List<({DriftCollectionItem removed, DriftCollectionItem kept})> inventory;

  /// Decks that had at least one card moved.
  final Set<int> deckIds;
  final List<CardIdChange> favorites;
  final List<CardIdChange> wanted;

  /// Retired card rows deleted because nothing pointed at them any more.
  final int removedCards;

  const RetiredCardIdRemap({
    required this.inventory,
    required this.deckIds,
    required this.favorites,
    required this.wanted,
    required this.removedCards,
  });

  bool get hasUserDataChanges =>
      inventory.isNotEmpty || deckIds.isNotEmpty || favorites.isNotEmpty || wanted.isNotEmpty;
}

class CardPrinting {
  final int cardId;
  final String setCode;
  final String cardName;

  const CardPrinting({
    required this.cardId,
    required this.setCode,
    required this.cardName,
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

class CardPriceStat {
  final int cardId;
  final String cardName;
  final double price;

  CardPriceStat({
    required this.cardId,
    required this.cardName,
    required this.price,
  });
}
