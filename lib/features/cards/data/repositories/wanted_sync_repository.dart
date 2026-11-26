import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/features/cards/data/repositories/card_flag_sync_repository.dart';

part 'wanted_sync_repository.g.dart';

/// Cloud sync for wanted cards (`users/{uid}/wanted`).
@riverpod
CardFlagSyncRepository wantedSyncRepository(Ref ref) {
  return CardFlagSyncRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    collectionName: 'wanted',
    saveLocally: (db, records) => db.upsertWantedCards(records),
  );
}
