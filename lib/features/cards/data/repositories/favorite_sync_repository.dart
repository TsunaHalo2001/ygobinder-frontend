import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';

part 'favorite_sync_repository.g.dart';

@riverpod
FavoriteSyncRepository favoriteSyncRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return FavoriteSyncRepository(firestore, auth);
}

class FavoriteSyncRepository {
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  FavoriteSyncRepository(this._firestore, this._auth);

  String? get _uid => _auth?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userFavoritesCollection {
    if (_uid == null || _firestore == null) return null;
    return _firestore.collection('users').doc(_uid).collection('favorites');
  }

  /// Syncs a single card favorite status to Firestore
  Future<void> syncFavorite(int cardId, bool isFavorite, {String? syncId}) async {
    final collection = _userFavoritesCollection;
    if (collection == null) return;

    final docRef = collection.doc(cardId.toString());

    if (isFavorite) {
      await docRef.set({
        'cardId': cardId,
        'syncId': syncId,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } else {
      await docRef.delete();
    }
  }

  /// Pulls all favorites from Firestore and merges with local database
  Future<void> fullSync(AppDatabase db) async {
    final collection = _userFavoritesCollection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get().timeout(const Duration(seconds: 5));
      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final cardId = data['cardId'] as int;
        final syncId = data['syncId'] as String? ?? '';
        final cloudUpdatedAt = (data['updatedAt'] as Timestamp).toDate();

        await db.upsertFavoriteCard(cardId, syncId, cloudUpdatedAt);
      }
    } catch (e) {
      debugPrint('Favorite Sync Error: $e');
    }
  }
}
