import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/core/database/database_provider.dart';

part 'card_detail_provider.g.dart';

@riverpod
Future<YgoCard?> cardDetail(Ref ref, int cardId) async {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.getCardWithDetails(cardId);
}
