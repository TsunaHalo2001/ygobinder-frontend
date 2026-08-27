import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/features/scanner/presentation/providers/camera_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';
import 'package:ygobinder/core/database/database_provider.dart';

class CameraScannerScreen extends ConsumerStatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  ConsumerState<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends ConsumerState<CameraScannerScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  bool _isInitialized = false;
  bool _isProcessing = false;
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(cameraController.description);
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      await _controller!.setFlashMode(_flashMode);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _toggleCamera(List<CameraDescription> cameras) {
    if (cameras.isEmpty) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    _initializeCamera(cameras[_selectedCameraIndex]);
  }

  void _toggleFlash() async {
    if (_controller == null) return;

    FlashMode nextMode;
    switch (_flashMode) {
      case FlashMode.off:
        nextMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        nextMode = FlashMode.always;
        break;
      case FlashMode.always:
        nextMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        nextMode = FlashMode.off;
        break;
    }

    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {
        _flashMode = nextMode;
      });
    } catch (e) {
      debugPrint('Flash error: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.isTakingPicture || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile file = await _controller!.takePicture();
      
      // Process with OCR
      final inputImage = InputImage.fromFilePath(file.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      final List<String> lines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text)
          .toList();

      /* ✅ Commented for Release: OCR Debugging
      debugPrint('--- IDENTIFIED TEXT ---');
      for (var i = 0; i < lines.length; i++) {
        debugPrint('Line $i: ${lines[i]}');
      }
      debugPrint('-----------------------');
      */

      final repo = ref.read(cardRepositoryProvider);
      final int? cardId = await repo.identifyCardFromText(lines);

      if (mounted) {
        if (cardId != null) {
          context.pushReplacement('/card/$cardId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not identify card. Try again.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Take picture/OCR error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final camerasAsync = ref.watch(availableCamerasListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: camerasAsync.when(
        data: (cameras) {
          if (cameras.isEmpty) {
            return const Center(child: Text('No cameras found'));
          }

          if (!_isInitialized && _controller == null) {
            _initializeCamera(cameras[_selectedCameraIndex]);
          }

          if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
            return const Center(child: SpinningCardLoader());
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview
              Center(
                child: CameraPreview(_controller!),
              ),

              if (_isProcessing)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinningCardLoader(width: 80, height: 112),
                        SizedBox(height: 16),
                        Text('IDENTIFYING CARD...', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                        ),
                      ],
                    ),
                  ),
                ),

              // Controls Overlay
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Bar (Flash & Close)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white, size: 30),
                          ),
                          IconButton(
                            onPressed: _toggleFlash,
                            icon: Icon(
                              _getFlashIcon(),
                              color: _flashMode == FlashMode.off ? Colors.white : Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Bar (Rotate & Take Picture)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Rotate
                          IconButton(
                            onPressed: () => _toggleCamera(cameras),
                            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white, size: 40),
                          ),

                          // Shutter
                          GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Empty space to balance Row
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: SpinningCardLoader()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }
}
