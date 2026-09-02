import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';

part 'wanted_sync_repository.g.dart';

@riverpod
WantedSyncRepository wantedSyncRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return WantedSyncRepository(firestore, auth);
}

class WantedSyncRepository {
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  WantedSyncRepository(this._firestore, this._auth);

  String? get _uid => _auth?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userWantedCollection {
    if (_uid == null || _firestore == null) return null;
    return _firestore.collection('users').doc(_uid).collection('wanted');
  }

  /// Syncs a single card wanted status to Firestore
  Future<void> syncWanted(int cardId, bool isWanted, {String? syncId}) async {
    final collection = _userWantedCollection;
    if (collection == null) return;

    final docRef = collection.doc(cardId.toString());

    if (isWanted) {
      await docRef.set({
        'cardId': cardId,
        'syncId': syncId,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } else {
      await docRef.delete();
    }
  }

  /// Pulls all wanted cards from Firestore and merges with local database
  Future<void> fullSync(AppDatabase db) async {
    final collection = _userWantedCollection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get().timeout(const Duration(seconds: 5));
      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final cardId = data['cardId'] as int;
        final syncId = data['syncId'] as String? ?? '';
        final cloudUpdatedAt = (data['updatedAt'] as Timestamp).toDate();

        await db.upsertWantedCard(cardId, syncId, cloudUpdatedAt);
      }
    } catch (e) {
      debugPrint('Wanted Sync Error: $e');
    }
  }
}
