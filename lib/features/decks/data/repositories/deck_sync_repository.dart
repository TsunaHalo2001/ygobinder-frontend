import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';

part 'deck_sync_repository.g.dart';

@riverpod
DeckSyncRepository deckSyncRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return DeckSyncRepository(firestore, auth);
}

class DeckSyncRepository {
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  DeckSyncRepository(this._firestore, this._auth);

  String? get _uid => _auth?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userDecksCollection {
    if (_uid == null || _firestore == null) return null;
    return _firestore.collection('users').doc(_uid).collection('decks');
  }

  Future<void> syncDeck(DriftDeck deck, List<DriftDeckCard> cards) async {
    final collection = _userDecksCollection;
    if (collection == null || deck.syncId == null) return;

    final main = cards.where((c) => c.category == 'main').map((c) => c.cardId).toList();
    final extra = cards.where((c) => c.category == 'extra').map((c) => c.cardId).toList();
    final side = cards.where((c) => c.category == 'side').map((c) => c.cardId).toList();

    await collection.doc(deck.syncId).set({
      'name': deck.name,
      'main': main,
      'extra': extra,
      'side': side,
      'updatedAt': Timestamp.fromDate(deck.updatedAt),
    }, SetOptions(merge: true));
  }

  Future<void> removeDeck(String syncId) async {
    final collection = _userDecksCollection;
    if (collection == null) return;
    await collection.doc(syncId).delete();
  }

  Future<void> fullSync(AppDatabase db) async {
    final collection = _userDecksCollection;
    if (collection == null) return;

    try {
      // Add a specific timeout for the network call
      final snapshot = await collection.get().timeout(const Duration(seconds: 5));
      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final syncId = doc.id;
        final name = data['name'] as String;
        final main = List<int>.from(data['main'] ?? []);
        final extra = List<int>.from(data['extra'] ?? []);
        final side = List<int>.from(data['side'] ?? []);
        final cloudUpdatedAt = (data['updatedAt'] as Timestamp).toDate();

        final existing = await db.getDeckBySyncId(syncId);

        if (existing == null || cloudUpdatedAt.isAfter(existing.updatedAt)) {
          await db.upsertDeck(
            syncId,
            name,
            {
              'main': main,
              'extra': extra,
              'side': side,
            },
            cloudUpdatedAt,
          );
        }
      }
    } catch (e) {
      debugPrint('Deck Sync Error: $e');
    }
  }
}
