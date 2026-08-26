// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(availableCamerasList)
final availableCamerasListProvider = AvailableCamerasListProvider._();

final class AvailableCamerasListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CameraDescription>>,
          List<CameraDescription>,
          FutureOr<List<CameraDescription>>
        >
    with
        $FutureModifier<List<CameraDescription>>,
        $FutureProvider<List<CameraDescription>> {
  AvailableCamerasListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableCamerasListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableCamerasListHash();

  @$internal
  @override
  $FutureProviderElement<List<CameraDescription>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CameraDescription>> create(Ref ref) {
    return availableCamerasList(ref);
  }
}

String _$availableCamerasListHash() =>
    r'edf3fbd03829cd9219b11a53252b3c316a0f45b8';
