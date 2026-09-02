// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wanted_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isWantedCard)
final isWantedCardProvider = IsWantedCardFamily._();

final class IsWantedCardProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  IsWantedCardProvider._({
    required IsWantedCardFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'isWantedCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isWantedCardHash();

  @override
  String toString() {
    return r'isWantedCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as int;
    return isWantedCard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsWantedCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isWantedCardHash() => r'8f2c64d5353bd1a120a8a9d5bda6b263d34273cc';

final class IsWantedCardFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, int> {
  IsWantedCardFamily._()
    : super(
        retry: null,
        name: r'isWantedCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsWantedCardProvider call(int cardId) =>
      IsWantedCardProvider._(argument: cardId, from: this);

  @override
  String toString() => r'isWantedCardProvider';
}
