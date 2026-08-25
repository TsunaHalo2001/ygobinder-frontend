import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

part 'search_provider.g.dart';

// The Notifier replaces StateProvider
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

// Simple functions with @riverpod replace StreamProvider/FutureProvider
@riverpod
Stream<List<YgoCard>> filteredCards(Ref ref) {
  final query = ref.watch(searchQueryProvider);
  final db = ref.watch(databaseProvider);

  return db.watchCardsByName(query).map((driftCards) {
    return driftCards.map((card) => CardMapper.toYgoCard(card)).toList();
  });
}
