import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_cache_provider.g.dart';

/// A custom FileService that limits downloads to 5 per second.
class RateLimitedFileService extends HttpFileService {
  final Duration _interval = const Duration(milliseconds: 220); 
  Future<void> _throttle = Future.value();

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) async {
    // 1. Capture the current tail of the chain
    final previous = _throttle;
    final completer = Completer<void>();
    
    // 2. Update the tail to wait for this new operation
    _throttle = completer.future;

    try {
      // 3. Wait for all previous requests to at least start their delay
      await previous;
    } catch (_) {
      // Ignore errors in previous requests to keep the chain moving
    }

    // 4. Enforce the delay
    await Future.delayed(_interval);
    
    // 5. Signal that the next request in line can start its delay
    completer.complete();

    // 6. Execute the actual request
    return super.get(url, headers: headers);
  }
}

@riverpod
CacheManager imageCacheManager(Ref ref) {
  return CacheManager(
    Config(
      'ygoCardCache',
      stalePeriod: const Duration(days: 365 * 100), // 100 years
      maxNrOfCacheObjects: 20000,
      fileService: RateLimitedFileService(), // Inject the rate limiter
    ),
  );
}
