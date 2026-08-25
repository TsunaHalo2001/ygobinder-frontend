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

String _$cardListHash() => r'ce16a6eec4c44aeab791233ca9a12f4565f53445';

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
