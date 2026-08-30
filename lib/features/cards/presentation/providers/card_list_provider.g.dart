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

String _$cardListHash() => r'0a5fd7d8e0343b6dab3e3f3fa61336de83b677ea';

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
