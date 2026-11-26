import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';

part 'wanted_providers.g.dart';

@riverpod
Stream<bool> isWantedCard(Ref ref, int cardId) {
  final db = ref.watch(databaseProvider);
  return db.watchIsWanted(cardId);
}
