import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';

part 'favorite_providers.g.dart';

@riverpod
Stream<bool> isFavoriteCard(Ref ref, int cardId) {
  final db = ref.watch(databaseProvider);
  return db.watchIsFavorite(cardId);
}

final favoriteCardIdsProvider = StreamProvider<List<int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchFavoriteCardIds();
});
