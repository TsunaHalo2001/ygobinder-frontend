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
    extends $AsyncNotifierProvider<CardList, List<YgoCard>> {
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

String _$cardListHash() => r'7e8974a4ec83650d0598e617f0d2b44a8cbe05b5';

abstract class _$CardList extends $AsyncNotifier<List<YgoCard>> {
  FutureOr<List<YgoCard>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<YgoCard>>, List<YgoCard>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<YgoCard>>, List<YgoCard>>,
              AsyncValue<List<YgoCard>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
