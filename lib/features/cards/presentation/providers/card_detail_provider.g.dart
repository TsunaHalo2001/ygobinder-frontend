// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cardDetail)
final cardDetailProvider = CardDetailFamily._();

final class CardDetailProvider
    extends
        $FunctionalProvider<AsyncValue<YgoCard?>, YgoCard?, FutureOr<YgoCard?>>
    with $FutureModifier<YgoCard?>, $FutureProvider<YgoCard?> {
  CardDetailProvider._({
    required CardDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'cardDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cardDetailHash();

  @override
  String toString() {
    return r'cardDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<YgoCard?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<YgoCard?> create(Ref ref) {
    final argument = this.argument as int;
    return cardDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CardDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cardDetailHash() => r'75a3fa5b7392c64a9f7e5449d87fce1f2c789a7a';

final class CardDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<YgoCard?>, int> {
  CardDetailFamily._()
    : super(
        retry: null,
        name: r'cardDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CardDetailProvider call(int cardId) =>
      CardDetailProvider._(argument: cardId, from: this);

  @override
  String toString() => r'cardDetailProvider';
}
