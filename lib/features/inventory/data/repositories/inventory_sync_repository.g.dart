// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_sync_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventorySyncRepository)
final inventorySyncRepositoryProvider = InventorySyncRepositoryProvider._();

final class InventorySyncRepositoryProvider
    extends
        $FunctionalProvider<
          InventorySyncRepository,
          InventorySyncRepository,
          InventorySyncRepository
        >
    with $Provider<InventorySyncRepository> {
  InventorySyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventorySyncRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventorySyncRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventorySyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventorySyncRepository create(Ref ref) {
    return inventorySyncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventorySyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventorySyncRepository>(value),
    );
  }
}

String _$inventorySyncRepositoryHash() =>
    r'7ac2ed3a552629bb967eb068060a980f27c9ff50';
