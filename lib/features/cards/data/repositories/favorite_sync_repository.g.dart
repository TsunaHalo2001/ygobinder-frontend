// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteSyncRepository)
final favoriteSyncRepositoryProvider = FavoriteSyncRepositoryProvider._();

final class FavoriteSyncRepositoryProvider
    extends
        $FunctionalProvider<
          FavoriteSyncRepository,
          FavoriteSyncRepository,
          FavoriteSyncRepository
        >
    with $Provider<FavoriteSyncRepository> {
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
  $ProviderElement<FavoriteSyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoriteSyncRepository create(Ref ref) {
    return favoriteSyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoriteSyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoriteSyncRepository>(value),
    );
  }
}

String _$favoriteSyncRepositoryHash() =>
    r'31e840916fb9c8022e6f27387390f9ee9a3e2dc9';
