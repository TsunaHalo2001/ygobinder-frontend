import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/firebase_providers.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';

part 'inventory_sync_repository.g.dart';

@riverpod
InventorySyncRepository inventorySyncRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider); // ✅ Use the safe provider
  return InventorySyncRepository(firestore, auth);
}

class InventorySyncRepository {
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth; // ✅ Make nullable

  InventorySyncRepository(this._firestore, this._auth);

  String? get _uid => _auth?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userCollection {
    if (_uid == null || _firestore == null) return null;
    return _firestore!.collection('users').doc(_uid).collection('inventory');
  }

  /// Pushes a single local item to Firestore
  Future<void> syncItem(DriftCollectionItem item) async {
    final collection = _userCollection;
    if (collection == null) return;

    final docId = '${item.cardId}_${item.setCode}_${item.rarity}_${item.collectionNumber}';
    
    await collection.doc(docId).set({
      'cardId': item.cardId,
      'setCode': item.setCode,
      'rarity': item.rarity,
      'collectionNumber': item.collectionNumber,
      'quantity': item.quantity,
      'condition': item.condition,
      'language': item.language,
      'isFirstEdition': item.isFirstEdition,
      'priceAtPurchase': item.priceAtPurchase,
      'notes': item.notes,
      'updatedAt': Timestamp.fromDate(item.updatedAt), // ✅ Use local timestamp for multi-device ordering
    }, SetOptions(merge: true));
  }

  /// Removes an item from Firestore
  Future<void> removeItem(DriftCollectionItem item) async {
    final collection = _userCollection;
    if (collection == null) return;
    final docId = '${item.cardId}_${item.setCode}_${item.rarity}_${item.collectionNumber}';
    await collection.doc(docId).delete();
  }

  /// Pulls the entire collection from Firestore and merges it into the local database
  Future<void> fullSync(AppDatabase db) async {
    final collection = _userCollection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get();
      if (snapshot.docs.isEmpty) return;

      await db.transaction(() async {
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final cloudUpdatedAt = (data['updatedAt'] as Timestamp).toDate();

          // 1. Check if item exists locally
          final existing = await db.findCollectionItem(
            cardId: data['cardId'] as int,
            setCode: data['setCode'] as String,
            rarity: data['rarity'] as String,
            collectionNumber: data['collectionNumber'] as int,
          );

          if (existing == null) {
            // 2. Doesn't exist locally: Insert
            await db.into(db.collectionItems).insert(
                  CollectionItemsCompanion.insert(
                    cardId: data['cardId'] as int,
                    setCode: data['setCode'] as String,
                    rarity: data['rarity'] as String,
                    collectionNumber: Value(data['collectionNumber'] as int),
                    quantity: Value(data['quantity'] as int),
                    condition: Value(data['condition'] as String),
                    language: Value(data['language'] as String? ?? 'EN'),
                    isFirstEdition: Value(data['isFirstEdition'] as bool? ?? false),
                    priceAtPurchase: Value(data['priceAtPurchase'] != null ? (data['priceAtPurchase'] as num).toDouble() : null),
                    notes: Value(data['notes'] as String?),
                    updatedAt: Value(cloudUpdatedAt),
                  ),
                );
          } else if (cloudUpdatedAt.isAfter(existing.updatedAt)) {
            // 3. Exists but Cloud is newer: Update Local
            await (db.update(db.collectionItems)..where((t) => t.id.equals(existing.id))).write(
                  CollectionItemsCompanion(
                    quantity: Value(data['quantity'] as int),
                    condition: Value(data['condition'] as String),
                    language: Value(data['language'] as String? ?? 'EN'),
                    isFirstEdition: Value(data['isFirstEdition'] as bool? ?? false),
                    priceAtPurchase: Value(data['priceAtPurchase'] != null ? (data['priceAtPurchase'] as num).toDouble() : null),
                    notes: Value(data['notes'] as String?),
                    updatedAt: Value(cloudUpdatedAt),
                  ),
                );
          }
          // 4. Local is newer (or same): Do nothing, local wins
        }
      });
    } catch (e) {
      debugPrint('Sync Error: $e');
    }
  }
}
