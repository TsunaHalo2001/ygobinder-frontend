// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wanted_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wantedSyncRepository)
final wantedSyncRepositoryProvider = WantedSyncRepositoryProvider._();

final class WantedSyncRepositoryProvider
    extends
        $FunctionalProvider<
          WantedSyncRepository,
          WantedSyncRepository,
          WantedSyncRepository
        >
    with $Provider<WantedSyncRepository> {
  WantedSyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wantedSyncRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wantedSyncRepositoryHash();

  @$internal
  @override
  $ProviderElement<WantedSyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WantedSyncRepository create(Ref ref) {
    return wantedSyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WantedSyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WantedSyncRepository>(value),
    );
  }
}

String _$wantedSyncRepositoryHash() =>
    r'5599b31917eea4be52206c20e06536f3e98c22d9';
