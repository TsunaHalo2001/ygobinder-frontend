// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CardList)
final cardListProvider = CardListProvider._();

final class CardListProvider
    extends $AsyncNotifierProvider<CardList, CardListState> {
  CardListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cardListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cardListHash();

  @$internal
  @override
  CardList create() => CardList();
}

String _$cardListHash() => r'2798654f6d9787e39d0449de819fd0737b153f6f';

abstract class _$CardList extends $AsyncNotifier<CardListState> {
  FutureOr<CardListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CardListState>, CardListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CardListState>, CardListState>,
              AsyncValue<CardListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeckCardList)
final deckCardListProvider = DeckCardListProvider._();

final class DeckCardListProvider
    extends $AsyncNotifierProvider<DeckCardList, CardListState> {
  DeckCardListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckCardListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckCardListHash();

  @$internal
  @override
  DeckCardList create() => DeckCardList();
}

String _$deckCardListHash() => r'6de58f2ad718ed3fa9439cab06e978fe5423b24b';

abstract class _$DeckCardList extends $AsyncNotifier<CardListState> {
  FutureOr<CardListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CardListState>, CardListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CardListState>, CardListState>,
              AsyncValue<CardListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
