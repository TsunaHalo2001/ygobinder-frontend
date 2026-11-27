import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:ygobinder/core/database/app_database.dart';

/// Syncs a per-card boolean flag (favorite, wanted, ...) with the
/// `users/{uid}/{collectionName}` Firestore collection.
class CardFlagSyncRepository {
  CardFlagSyncRepository(
    this._firestore,
    this._auth, {
    required this.collectionName,
    required this.saveLocally,
  });

  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;
  final String collectionName;

  /// Writes the records pulled by [fullSync] into the local database.
  final Future<void> Function(AppDatabase db, List<CardFlagRecord> records) saveLocally;

  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _auth?.currentUser?.uid;
    final firestore = _firestore;
    if (uid == null || firestore == null) return null;
    return firestore.collection('users').doc(uid).collection(collectionName);
  }

  /// Pushes the flag state of a single card.
  Future<void> syncFlag(int cardId, bool isSet, {String? syncId}) async {
    final collection = _collection;
    if (collection == null) return;

    final docRef = collection.doc(cardId.toString());
    if (isSet) {
      await docRef.set({
        'cardId': cardId,
        'syncId': syncId,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } else {
      await docRef.delete();
    }
  }

  /// Pulls every flagged card from Firestore and merges it into the local
  /// database in one batch. Malformed documents are skipped.
  Future<void> fullSync(AppDatabase db) async {
    final collection = _collection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get().timeout(const Duration(seconds: 5));
      if (snapshot.docs.isEmpty) return;

      // Flags saved under a retired card id are stored under the current id
      // and moved in the cloud too.
      final aliases = await db.getRetiredCardIdAliases();
      final migrated = <CardIdChange>[];

      final records = <CardFlagRecord>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final cloudCardId = data['cardId'];
        final updatedAt = data['updatedAt'];
        if (cloudCardId is! int || updatedAt is! Timestamp) {
          debugPrint('Skipping malformed $collectionName doc ${doc.id}');
          continue;
        }
        final cardId = aliases[cloudCardId] ?? cloudCardId;
        final syncId = data['syncId'] as String? ?? '';
        if (cardId != cloudCardId) migrated.add((oldId: cloudCardId, newId: cardId, syncId: syncId));
        records.add((cardId: cardId, syncId: syncId, updatedAt: updatedAt.toDate()));
      }
      if (records.isNotEmpty) await saveLocally(db, records);

      for (final change in migrated) {
        await syncFlag(change.oldId, false);
        await syncFlag(change.newId, true, syncId: change.syncId);
      }
    } catch (e) {
      debugPrint('$collectionName sync error: $e');
    }
  }
}
