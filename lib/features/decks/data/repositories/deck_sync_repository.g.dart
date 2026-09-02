// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deckSyncRepository)
final deckSyncRepositoryProvider = DeckSyncRepositoryProvider._();

final class DeckSyncRepositoryProvider
    extends
        $FunctionalProvider<
          DeckSyncRepository,
          DeckSyncRepository,
          DeckSyncRepository
        >
    with $Provider<DeckSyncRepository> {
  DeckSyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckSyncRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckSyncRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeckSyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeckSyncRepository create(Ref ref) {
    return deckSyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeckSyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeckSyncRepository>(value),
    );
  }
}

String _$deckSyncRepositoryHash() =>
    r'5b8838de41c531d06b3fd8ee2ff04cd04a546c92';
