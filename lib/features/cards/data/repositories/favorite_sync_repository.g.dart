// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cloud sync for favorite cards (`users/{uid}/favorites`).

@ProviderFor(favoriteSyncRepository)
final favoriteSyncRepositoryProvider = FavoriteSyncRepositoryProvider._();

/// Cloud sync for favorite cards (`users/{uid}/favorites`).

final class FavoriteSyncRepositoryProvider
    extends
        $FunctionalProvider<
          CardFlagSyncRepository,
          CardFlagSyncRepository,
          CardFlagSyncRepository
        >
    with $Provider<CardFlagSyncRepository> {
  /// Cloud sync for favorite cards (`users/{uid}/favorites`).
  FavoriteSyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteSyncRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteSyncRepositoryHash();

  @$internal
  @override
  $ProviderElement<CardFlagSyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CardFlagSyncRepository create(Ref ref) {
    return favoriteSyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CardFlagSyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CardFlagSyncRepository>(value),
    );
  }
}

String _$favoriteSyncRepositoryHash() =>
    r'89690ec491553dc874ec43a27df877c0a1cf3669';
