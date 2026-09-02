import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/database/app_database.dart' as drift;
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

final totalCardsCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchTotalCardCount();
});

final uniqueCardsCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchUniqueCardCount();
});

final newestCardProvider = StreamProvider<YgoCard?>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchNewestCard();
});

final oldestCardProvider = StreamProvider<YgoCard?>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchOldestCard();
});

final topSetsProvider = StreamProvider<List<drift.SetStat>>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchTopSets(5);
});

final topCardsProvider = StreamProvider<List<drift.CardStat>>((ref) {
  final repo = ref.watch(cardRepositoryProvider);
  return repo.watchTopCards(5);
});
