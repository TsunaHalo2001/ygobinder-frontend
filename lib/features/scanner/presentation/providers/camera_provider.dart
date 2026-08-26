import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

@riverpod
Future<List<CameraDescription>> availableCamerasList(Ref ref) async {
  return await availableCameras();
}
