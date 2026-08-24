import 'dart:convert';
import 'package:dio/dio.dart';

class CardDataService {
  static const String cacheUrl =
      'https://raw.githubusercontent.com/TsunaHalo2001/ygobinder/refs/heads/master/assets/json/ygo_api_cache.json';

  final Dio _dio;

  CardDataService() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 13),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<List<dynamic>> fetchRawCardData({
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final response = await _dio.get<String>(
        cacheUrl,
        onReceiveProgress: onProgress,
      );

      if (response.statusCode == 200 && response.data != null) {
        final decoded = jsonDecode(response.data!);

        if (decoded is List) {
          return decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            return decoded['data'] as List<dynamic>;
          }
          if (decoded.containsKey('cards') && decoded['cards'] is List) {
            return decoded['cards'] as List<dynamic>;
          }
          if (decoded.containsKey('results') && decoded['results'] is List) {
            return decoded['results'] as List<dynamic>;
          }
          throw Exception('Unexpected JSON structure: "data" key not found or not a list.');
        }

        throw Exception('Unexpected JSON structure: Expected a list or a map.');
      } else {
        throw Exception('Failed to fetch card data: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while fetching card data.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while fetching card data.');
      }
      throw Exception('Dio error while fetching card data: ${e.message}');
    }
    catch (e) {
      throw Exception('Unexpected error while fetching card data: $e');
    }
  }
}