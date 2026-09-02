// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isFavoriteCard)
final isFavoriteCardProvider = IsFavoriteCardFamily._();

final class IsFavoriteCardProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  IsFavoriteCardProvider._({
    required IsFavoriteCardFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'isFavoriteCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFavoriteCardHash();

  @override
  String toString() {
    return r'isFavoriteCardProvider'
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
    return isFavoriteCard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFavoriteCardHash() => r'bf5672a2d58387d9d66f7d6fda2f5d8ba8c394e1';

final class IsFavoriteCardFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, int> {
  IsFavoriteCardFamily._()
    : super(
        retry: null,
        name: r'isFavoriteCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsFavoriteCardProvider call(int cardId) =>
      IsFavoriteCardProvider._(argument: cardId, from: this);

  @override
  String toString() => r'isFavoriteCardProvider';
}
