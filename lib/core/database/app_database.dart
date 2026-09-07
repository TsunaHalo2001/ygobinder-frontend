import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';

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

  @override
  int get schemaVersion => 16;

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
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('ALTER TABLE set_card_prices ADD COLUMN set_code TEXT').catchError((_) {});
      await customStatement('ALTER TABLE set_card_prices ADD COLUMN previous_market_price REAL').catchError((_) {});
      await customStatement('CREATE INDEX IF NOT EXISTS set_card_prices_card_id_idx ON set_card_prices (card_id)').catchError((_) {});
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

  Future<void> clearCollection() async {
    await delete(collectionItems).go();
    await refreshUserOwnedSets();
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

  Stream<List<CardPriceStat>> watchTopExpensiveCards(int limit) {
    late StreamController<List<CardPriceStat>> controller;
    StreamSubscription? sub1;
    StreamSubscription? sub2;

    Future<void> recalculate() async {
      try {
        final items = await select(collectionItems).get();
        if (items.isEmpty) {
          if (!controller.isClosed) controller.add([]);
          return;
        }

        final cardIds = items.map((i) => i.cardId).toSet().toList();

        final driftCards = await (select(cards)..where((t) => t.id.isIn(cardIds))).get();
        final cardNameById = {for (final c in driftCards) c.id: c.name};

        final gPrices = await (select(cardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
        final globalPriceById = <int, double>{};
        for (final p in gPrices) {
          final price = p.tcgPlayerPrice ?? p.cardMarketPrice ?? 0.0;
          globalPriceById[p.cardId] = price;
        }

        final sPrices = await (select(setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
        final setPricesMap = <String, double>{};
        for (final sp in sPrices) {
          final price = sp.marketPrice ?? sp.lowPrice ?? 0.0;
          if (sp.setCode != null && sp.setCode!.isNotEmpty) {
            setPricesMap['${sp.cardId}_${sp.setCode!.toUpperCase()}'] = price;
          }
          final currentMax = setPricesMap['${sp.cardId}'] ?? 0.0;
          if (price > currentMax) {
            setPricesMap['${sp.cardId}'] = price;
          }
        }

        final stats = <CardPriceStat>[];
        for (final cardId in cardIds) {
          final name = cardNameById[cardId];
          if (name == null) continue;

          final cardItems = items.where((i) => i.cardId == cardId);

          double maxOwnedCardPrice = 0.0;

          for (final item in cardItems) {
            final baseSetCode = item.setCode.trim().toUpperCase();
            final setPriceKey = '${item.cardId}_$baseSetCode';

            final setPrice = setPricesMap[setPriceKey] ?? setPricesMap['${item.cardId}'] ?? 0.0;
            final globalPrice = globalPriceById[item.cardId] ?? 0.0;
            final purchasePrice = item.priceAtPurchase ?? 0.0;

            double itemPrice = setPrice;
            if (itemPrice <= 0.0) itemPrice = globalPrice;
            if (itemPrice <= 0.0) itemPrice = purchasePrice;

            if (itemPrice > maxOwnedCardPrice) {
              maxOwnedCardPrice = itemPrice;
            }
          }

          if (maxOwnedCardPrice > 0.0) {
            stats.add(CardPriceStat(
              cardId: cardId,
              cardName: name,
              price: maxOwnedCardPrice,
            ));
          }
        }

        stats.sort((a, b) => b.price.compareTo(a.price));
        if (!controller.isClosed) {
          controller.add(stats.take(limit).toList());
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    controller = StreamController<List<CardPriceStat>>(
      onListen: () {
        recalculate();
        sub1 = select(collectionItems).watch().listen((_) => recalculate());
        sub2 = select(setCardPrices).watch().listen((_) => recalculate());
      },
      onCancel: () {
        sub1?.cancel();
        sub2?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  Stream<double> watchTotalCollectionValue() {
    late StreamController<double> controller;
    StreamSubscription? sub1;
    StreamSubscription? sub2;

    Future<void> recalculate() async {
      try {
        final items = await select(collectionItems).get();
        if (items.isEmpty) {
          if (!controller.isClosed) controller.add(0.0);
          return;
        }

        final cardIds = items.map((i) => i.cardId).toSet().toList();

        final gPrices = await (select(cardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
        final globalPriceById = <int, double>{};
        for (final p in gPrices) {
          final price = p.tcgPlayerPrice ?? p.cardMarketPrice ?? 0.0;
          globalPriceById[p.cardId] = price;
        }

        final sPrices = await (select(setCardPrices)..where((t) => t.cardId.isIn(cardIds))).get();
        final setPricesMap = <String, double>{};
        for (final sp in sPrices) {
          final price = sp.marketPrice ?? sp.lowPrice ?? 0.0;
          if (sp.setCode != null) {
            setPricesMap['${sp.cardId}_${sp.setCode!.toUpperCase()}'] = price;
          }
          final currentMax = setPricesMap['${sp.cardId}'] ?? 0.0;
          if (price > currentMax) {
            setPricesMap['${sp.cardId}'] = price;
          }
        }

        double totalValue = 0.0;

        for (final item in items) {
          final baseSetCode = item.setCode.trim().toUpperCase();
          final setPriceKey = '${item.cardId}_$baseSetCode';

          final setPrice = setPricesMap[setPriceKey] ?? setPricesMap['${item.cardId}'] ?? 0.0;
          final globalPrice = globalPriceById[item.cardId] ?? 0.0;
          final purchasePrice = item.priceAtPurchase ?? 0.0;

          double cardPrice = setPrice;
          if (cardPrice <= 0.0) cardPrice = globalPrice;
          if (cardPrice <= 0.0) cardPrice = purchasePrice;

          totalValue += cardPrice * item.quantity;
        }

        if (!controller.isClosed) {
          controller.add(totalValue);
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    controller = StreamController<double>(
      onListen: () {
        recalculate();
        sub1 = select(collectionItems).watch().listen((_) => recalculate());
        sub2 = select(setCardPrices).watch().listen((_) => recalculate());
      },
      onCancel: () {
        sub1?.cancel();
        sub2?.cancel();
        controller.close();
      },
    );

    return controller.stream;
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
    String? frameFilter, // ✅ Added frame filter
    int? levelFilter, // ✅ Added level filter
    int? scaleFilter, // ✅ Added scale filter
    int? linkValFilter, // ✅ Added link val filter
    int? atkFilter,
    String? atkOperator,
    bool? atkShowQuestionMark, // ✅ Added
    int? defFilter,
    String? defOperator,
    bool? defShowQuestionMark, // ✅ Added
    String? sortBy, // ✅ Added sort field
    bool sortDescending = false, // ✅ Added sort direction
    bool onlyEdison = false, // ✅ Added only Edison filter
    bool onlyFavorites = false, // ✅ Added only Favorites filter
    bool onlyWanted = false, // ✅ Added only Wanted filter
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

    if (onlyEdison) {
      // ✅ Filter for cards available in Edison
      query = query..where((t) {
        return t.id.isInQuery(
          selectOnly(banlistInfos)
            ..addColumns([banlistInfos.cardId])
            ..where(banlistInfos.banEdison.isNotNull())
        );
      });
    }

    if (onlyFavorites) {
      query = query..where((t) {
        return t.id.isInQuery(
          selectOnly(favoriteCards)..addColumns([favoriteCards.cardId])
        );
      });
    }

    if (onlyWanted) {
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

      // Filter out card IDs that don't exist in the database to avoid FK constraints (Error 787)
      final allCardIds = categorizedCards.values.expand((e) => e).toSet().toList();
      final existingCardIds = await (selectOnly(cards)..addColumns([cards.id])..where(cards.id.isIn(allCardIds)))
          .get()
          .then((rows) => rows.map((r) => r.read(cards.id)).toSet());

      for (final entry in categorizedCards.entries) {
        final category = entry.key;
        final cardIds = entry.value;

        for (final cardId in cardIds) {
          if (!existingCardIds.contains(cardId)) continue; // Skip missing cards

          await into(deckCards).insert(
            DeckCardsCompanion.insert(
              deckId: deckId,
              cardId: cardId,
              category: category,
            ),
          );
        }
      }

      return deckId;
    });
  }

  // ==========================================
  // FAVORITES QUERIES
  // ==========================================

  Stream<bool> watchIsFavorite(int cardId) {
    return (select(favoriteCards)..where((t) => t.cardId.equals(cardId)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  Future<bool> isFavorite(int cardId) async {
    final item = await (select(favoriteCards)..where((t) => t.cardId.equals(cardId))).getSingleOrNull();
    return item != null;
  }

  Future<bool> toggleFavorite(int cardId, {String? syncId}) async {
    final existing = await (select(favoriteCards)..where((t) => t.cardId.equals(cardId))).getSingleOrNull();
    if (existing != null) {
      await (delete(favoriteCards)..where((t) => t.cardId.equals(cardId))).go();
      return false;
    } else {
      final id = syncId ?? const Uuid().v4();
      await into(favoriteCards).insert(
        FavoriteCardsCompanion.insert(
          cardId: Value(cardId),
          syncId: Value(id),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return true;
    }
  }

  Stream<List<int>> watchFavoriteCardIds() {
    return select(favoriteCards).watch().map((rows) => rows.map((r) => r.cardId).toList());
  }

  Future<List<DriftFavoriteCard>> getAllFavoriteCards() {
    return select(favoriteCards).get();
  }

  Future<void> upsertFavoriteCard(int cardId, String syncId, DateTime updatedAt) async {
    await into(favoriteCards).insert(
      FavoriteCardsCompanion.insert(
        cardId: Value(cardId),
        syncId: Value(syncId),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> removeFavoriteCard(int cardId) async {
    await (delete(favoriteCards)..where((t) => t.cardId.equals(cardId))).go();
  }

  // ==========================================
  // WANTED QUERIES
  // ==========================================

  Stream<bool> watchIsWanted(int cardId) {
    return (select(wantedCards)..where((t) => t.cardId.equals(cardId)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  Future<bool> isWanted(int cardId) async {
    final item = await (select(wantedCards)..where((t) => t.cardId.equals(cardId))).getSingleOrNull();
    return item != null;
  }

  Future<bool> toggleWanted(int cardId, {String? syncId}) async {
    final existing = await (select(wantedCards)..where((t) => t.cardId.equals(cardId))).getSingleOrNull();
    if (existing != null) {
      await (delete(wantedCards)..where((t) => t.cardId.equals(cardId))).go();
      return false;
    } else {
      final id = syncId ?? const Uuid().v4();
      await into(wantedCards).insert(
        WantedCardsCompanion.insert(
          cardId: Value(cardId),
          syncId: Value(id),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return true;
    }
  }

  Stream<List<int>> watchWantedCardIds() {
    return select(wantedCards).watch().map((rows) => rows.map((r) => r.cardId).toList());
  }

  Future<List<DriftWantedCard>> getAllWantedCards() {
    return select(wantedCards).get();
  }

  Future<void> upsertWantedCard(int cardId, String syncId, DateTime updatedAt) async {
    await into(wantedCards).insert(
      WantedCardsCompanion.insert(
        cardId: Value(cardId),
        syncId: Value(syncId),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> removeWantedCard(int cardId) async {
    await (delete(wantedCards)..where((t) => t.cardId.equals(cardId))).go();
  }

  // ==========================================
  // SET INFOS QUERIES
  // ==========================================

  Future<List<DriftSetInfo>> getAllSetInfos() {
    return (select(setInfos)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Stream<List<DriftSetInfo>> watchAllSetInfos() {
    return (select(setInfos)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  Future<DriftSetInfo?> getSetInfoByAbbreviation(String abbreviation) {
    return (select(setInfos)..where((t) => t.abbreviation.equals(abbreviation))).getSingleOrNull();
  }

  Future<DriftSetInfo?> getSetInfoByName(String name) {
    return (select(setInfos)..where((t) => t.name.equals(name))).getSingleOrNull();
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

      // Filter out card IDs that don't exist in the database to avoid FK constraints (Error 787)
      final allCardIds = categorizedCards.values.expand((e) => e).toSet().toList();
      final existingCardIds = await (selectOnly(cards)..addColumns([cards.id])..where(cards.id.isIn(allCardIds)))
          .get()
          .then((rows) => rows.map((r) => r.read(cards.id)).toSet());

      for (final entry in categorizedCards.entries) {
        final category = entry.key;
        for (final cardId in entry.value) {
          if (!existingCardIds.contains(cardId)) continue; // Skip missing cards

          await into(deckCards).insert(
            DeckCardsCompanion.insert(
              deckId: deckId,
              cardId: cardId,
              category: category,
            ),
          );
        }
      }
    });
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
  // USER OWNED SETS QUERIES
  // ==========================================

  Stream<List<DriftUserOwnedSet>> watchUserOwnedSets() {
    return (select(userOwnedSets)..orderBy([(t) => OrderingTerm.desc(t.totalCardsOwned)])).watch();
  }

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

      final allCardSets = await select(cardSets).get();
      final setNameByAbbr = <String, String>{};
      for (final cs in allCardSets) {
        final baseCode = cs.setCode.contains('-') ? cs.setCode.split('-').first.toUpperCase() : cs.setCode.toUpperCase();
        setNameByAbbr.putIfAbsent(baseCode, () => cs.setName);
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

  Future<List<DriftSetCardPrice>> getPricesForSetAndCard(int setId, int cardId) {
    return (select(setCardPrices)
          ..where((t) => t.setId.equals(setId) & t.cardId.equals(cardId)))
        .get();
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

  Future<List<DriftCurrencyRate>> getAllCurrencyRates() {
    return select(currencyRates).get();
  }

  Future<DriftCurrencyRate?> getCurrencyRate(String code) {
    return (select(currencyRates)..where((t) => t.currencyCode.equals(code.toUpperCase()))).getSingleOrNull();
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
