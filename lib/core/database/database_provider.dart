import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';
import 'package:ygobinder/features/inventory/data/repositories/inventory_sync_repository.dart';

/// Provides a single instance of [AppDatabase] throughout the app.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provides the [CardDataService] for fetching raw JSON data.
final cardDataServiceProvider = Provider<CardDataService>((ref) {
  return CardDataService();
});

/// Provides the [CardRepository], automatically injecting both the
/// database and the data service.
final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final dataService = ref.watch(cardDataServiceProvider);
  final syncRepo = ref.watch(inventorySyncRepositoryProvider);

  return CardRepository(db, dataService, syncRepo);
});
