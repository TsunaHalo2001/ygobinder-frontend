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
    extends $NotifierProvider<DeckFileContent, DeckState> {
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
  Override overrideWithValue(DeckState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeckState>(value),
    );
  }
}

String _$deckFileContentHash() => r'c12848da97cb3986f4fd55a6bba529c39a357ae8';

abstract class _$DeckFileContent extends $Notifier<DeckState> {
  DeckState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeckState, DeckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeckState, DeckState>,
              DeckState,
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
    r'8ff9a793ca5852ec4f056eeaefc0f8202cf8046a';
