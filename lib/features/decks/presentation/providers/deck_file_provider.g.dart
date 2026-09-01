// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_file_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeckFileContent)
final deckFileContentProvider = DeckFileContentProvider._();

final class DeckFileContentProvider
    extends $NotifierProvider<DeckFileContent, String> {
  DeckFileContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckFileContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckFileContentHash();

  @$internal
  @override
  DeckFileContent create() => DeckFileContent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$deckFileContentHash() => r'95ec73b558a1ec543d0b14455a5deb913e0d8568';

abstract class _$DeckFileContent extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(categorizedDeckCards)
final categorizedDeckCardsProvider = CategorizedDeckCardsProvider._();

final class CategorizedDeckCardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<YgoCard>>>,
          Map<String, List<YgoCard>>,
          FutureOr<Map<String, List<YgoCard>>>
        >
    with
        $FutureModifier<Map<String, List<YgoCard>>>,
        $FutureProvider<Map<String, List<YgoCard>>> {
  CategorizedDeckCardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorizedDeckCardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorizedDeckCardsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<YgoCard>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<YgoCard>>> create(Ref ref) {
    return categorizedDeckCards(ref);
  }
}

String _$categorizedDeckCardsHash() =>
    r'7496601c98390af0f1e90a020e62c95304761bc4';
