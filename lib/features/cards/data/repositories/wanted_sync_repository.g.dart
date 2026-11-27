// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wanted_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cloud sync for wanted cards (`users/{uid}/wanted`).

@ProviderFor(wantedSyncRepository)
final wantedSyncRepositoryProvider = WantedSyncRepositoryProvider._();

/// Cloud sync for wanted cards (`users/{uid}/wanted`).

final class WantedSyncRepositoryProvider
    extends
        $FunctionalProvider<
          CardFlagSyncRepository,
          CardFlagSyncRepository,
          CardFlagSyncRepository
        >
    with $Provider<CardFlagSyncRepository> {
  /// Cloud sync for wanted cards (`users/{uid}/wanted`).
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
  $ProviderElement<CardFlagSyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CardFlagSyncRepository create(Ref ref) {
    return wantedSyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CardFlagSyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CardFlagSyncRepository>(value),
    );
  }
}

String _$wantedSyncRepositoryHash() =>
    r'8768bb065c451556560cca8c45d832147bc1f805';
