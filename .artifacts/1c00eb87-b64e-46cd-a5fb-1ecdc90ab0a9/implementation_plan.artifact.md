# Save Decks to Firebase

The goal is to synchronize the user's saved decks with Firebase Firestore, similar to how the inventory is currently synchronized. This allows users to access their decks across different devices.

## User Review Required

> [!IMPORTANT]
> This change introduces a new migration (v8) to the local database to add a `syncId` (UUID) to the `Decks` table. This ensures each deck has a unique identifier for cloud synchronization.

## Proposed Changes

### [Core] Database & Providers

#### [MODIFY] [app_database.dart](file:///TsunaDomain/Proyectos/ygobinder-revamped/ygobinder-frontend/lib/core/database/app_database.dart)
- Update `Decks` table to include a `syncId` column (Text).
- Increment `schemaVersion` to 8.
- Add migration logic for v8.
- Update `saveDeck` to accept and save a `syncId`.
- Add `getDeckWithCards` method to fetch a deck and its associated cards in one go.
- Add `upsertDeck` method to support syncing from the cloud.

### [Decks] Data Layer

#### [NEW] [deck_sync_repository.dart](file:///TsunaDomain/Proyectos/ygobinder-revamped/ygobinder-frontend/lib/features/decks/data/repositories/deck_sync_repository.dart)
- Create a repository to handle Firestore operations for decks.
- Implement `syncDeck(DriftDeck deck, List<DriftDeckCard> cards)`: Pushes a deck to Firestore.
- Implement `removeDeck(String syncId)`: Deletes a deck from Firestore.
- Implement `fullSync(AppDatabase db)`: Pulls all decks from Firestore and merges them locally.

### [Decks] Presentation Layer

#### [MODIFY] [deck_file_provider.dart](file:///TsunaDomain/Proyectos/ygobinder-revamped/ygobinder-frontend/lib/features/decks/presentation/providers/deck_file_provider.dart)
- Inject `deckSyncRepositoryProvider`.
- Update `saveToDatabase` to also call `syncDeck`.
- Update `deleteDeck` to also call `removeDeck`.

## Verification Plan

### Automated Tests
- N/A (Project seems to lack unit tests for repositories, but manual verification will be thorough).

### Manual Verification
1.  **Save a new deck**: Verify it appears in the local database and in Firestore under `users/{uid}/decks/{syncId}`.
2.  **Delete a deck**: Verify it is removed from both the local database and Firestore.
3.  **Full sync**: Log out, log in on another "device" (or clear local db), and verify all decks are pulled from Firestore.
