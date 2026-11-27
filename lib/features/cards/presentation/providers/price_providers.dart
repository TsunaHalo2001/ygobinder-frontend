import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/database/database_provider.dart';

/// Per-printing prices of one card, kept live from the database.
final setPricesForCardProvider =
    StreamProvider.autoDispose.family<List<DriftSetCardPrice>, int>((ref, cardId) {
  return ref.watch(databaseProvider).watchPricesForCard(cardId);
});

/// All stored per-printing prices grouped by card id (row order preserved).
final setPricesByCardProvider = StreamProvider.autoDispose<Map<int, List<DriftSetCardPrice>>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.setCardPrices).watch().map((rows) {
    final byCard = <int, List<DriftSetCardPrice>>{};
    for (final row in rows) {
      byCard.putIfAbsent(row.cardId, () => []).add(row);
    }
    return byCard;
  });
});

/// Collection items grouped by card id (row order preserved).
final collectionItemsByCardProvider = StreamProvider.autoDispose<Map<int, List<DriftCollectionItem>>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.collectionItems).watch().map((items) {
    final byCard = <int, List<DriftCollectionItem>>{};
    for (final item in items) {
      byCard.putIfAbsent(item.cardId, () => []).add(item);
    }
    return byCard;
  });
});
