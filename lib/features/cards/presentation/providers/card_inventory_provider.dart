import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/core/database/database_provider.dart';

final cardInventoryProvider = FutureProvider.family<List<DriftCollectionItem>, int>((ref, cardId) async {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.getInventoryForCard(cardId);
});
