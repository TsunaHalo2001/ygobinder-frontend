import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
            catch (e) {
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return true;
    }
    if (error.response != null &&
        error.response!.statusCode != null &&
        error.response!.statusCode! >= 500) {
      return true;
    }
    return false;
  }

  Future<Response<T>> get<T>(
    String path, {
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
    }) async {
      return _dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    }

  void close() => _dio.close();
}