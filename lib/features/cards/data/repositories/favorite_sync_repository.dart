import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/features/cards/data/repositories/card_flag_sync_repository.dart';

part 'favorite_sync_repository.g.dart';

/// Cloud sync for favorite cards (`users/{uid}/favorites`).
@riverpod
CardFlagSyncRepository favoriteSyncRepository(Ref ref) {
  return CardFlagSyncRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    collectionName: 'favorites',
    saveLocally: (db, records) => db.upsertFavoriteCards(records),
  );
}
