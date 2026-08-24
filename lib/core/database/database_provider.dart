import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';

/// Provides a single instance of [AppDatabase] throughout the app.
///
/// This ensures:
/// - Only ONE database connection exists (prevents conflicts)
/// - The database is automatically closed when the app is disposed
/// - Any widget can access the database via `ref.read(databaseProvider)`
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Automatically close the database when the app is disposed
  ref.onDispose(() => db.close());

  return db;
});

/// Provides a [CardRepository] instance that uses the database.
///
/// This is a convenience provider so you don't have to manually
/// pass the database to the repository everywhere.
final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CardRepository(db);
});