import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RawApiCacheData {
  final List<dynamic> cards;
  final List<dynamic> sets;

  RawApiCacheData({required this.cards, required this.sets});
}

class CardDataService {
  static const String cacheUrl =
      'https://raw.githubusercontent.com/TsunaHalo2001/ygobinder/refs/heads/master/assets/json/ygo_api_cache.json';

  final Dio _dio;

  CardDataService() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 13),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<RawApiCacheData> fetchRawCardData({
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final response = await _dio.get<String>(
        cacheUrl,
        onReceiveProgress: onProgress,
      );

      if (response.statusCode == 200 && response.data != null) {
        final decoded = jsonDecode(response.data!);

        if (decoded is Map<String, dynamic>) {
          final cards = (decoded['data'] ?? decoded['cards'] ?? decoded['results']) as List<dynamic>? ?? [];
          final sets = (decoded['sets']) as List<dynamic>? ?? [];
          return RawApiCacheData(cards: cards, sets: sets);
        } else if (decoded is List) {
          return RawApiCacheData(cards: decoded, sets: []);
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

  Future<List<dynamic>?> fetchSetCards(int setId) async {
    final url = 'https://openapi.tcgtracking.com/v1/2/sets/$setId/cards';
    try {
      final response = await _dio.get<dynamic>(url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }

        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('data') && data['data'] is List) {
            return data['data'] as List<dynamic>;
          }
          if (data.containsKey('cards') && data['cards'] is List) {
            return data['cards'] as List<dynamic>;
          }
          if (data.containsKey('results') && data['results'] is List) {
            return data['results'] as List<dynamic>;
          }
          if (data.containsKey('products') && data['products'] is List) {
            return data['products'] as List<dynamic>;
          }
        }
      }
    } catch (e) {
      // Suppress error
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchSetPricing(int setId) async {
    final url = 'https://openapi.tcgtracking.com/v1/2/sets/$setId/pricing';
    try {
      final response = await _dio.get<dynamic>(url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is Map<String, dynamic>) {
          return data;
        }
      }
    } catch (e) {
      // Suppress individual set error to allow batch to continue
    }
    return null;
  }

  Future<Map<String, double>?> fetchCurrencyRates() async {
    const url = 'https://open.er-api.com/v6/latest/USD';
    try {
      final response = await _dio.get<dynamic>(url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) data = jsonDecode(data);

        if (data is Map<String, dynamic> && data['rates'] is Map<String, dynamic>) {
          final ratesMap = data['rates'] as Map<String, dynamic>;
          final parsedRates = <String, double>{};

          for (final entry in ratesMap.entries) {
            final val = (entry.value as num?)?.toDouble();
            if (val != null && val > 0) {
              parsedRates[entry.key.toUpperCase()] = val;
            }
          }
          return parsedRates;
        }
      }
    } catch (e) {
      debugPrint('Error fetching exchange rates: $e');
    }
    return null;
  }
}
