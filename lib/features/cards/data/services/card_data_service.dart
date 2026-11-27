import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Result of downloading the card cache.
class CardCacheDownload {
  /// Raw JSON bytes, or null when the server answered 304 Not Modified.
  final Uint8List? bytes;
  final String? etag;

  const CardCacheDownload({this.bytes, this.etag});

  bool get notModified => bytes == null;
}

final _versionPattern = RegExp(r'"(?:data sets version|data_sets_version|version)"\s*:\s*"([^"]+)"');

class CardDataService {
  static const String cacheUrl =
      'https://raw.githubusercontent.com/TsunaHalo2001/ygobinder/refs/heads/master/assets/json/ygo_api_cache.json';

  /// How many trailing bytes of the cache to read to find its `version`.
  static const int _versionTailBytes = 4096;

  final Dio _dio;

  CardDataService() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 13),
    receiveTimeout: const Duration(seconds: 30),
  ));

  /// Reads the `version` field stored at the end of the (~30 MB) card cache
  /// without downloading the whole file: a HEAD request for its size, then a
  /// byte-range request for the last few KB. Returns null on any failure.
  Future<String?> fetchCacheVersion() async {
    // Identity encoding: with gzip, content-length and ranges refer to the
    // compressed bytes.
    const identity = {'Accept-Encoding': 'identity'};
    try {
      final head = await _dio.head<void>(cacheUrl, options: Options(headers: identity));
      final length = int.tryParse(head.headers.value(Headers.contentLengthHeader) ?? '');
      if (length == null || length <= 0) return null;

      final start = length > _versionTailBytes ? length - _versionTailBytes : 0;
      final response = await _dio.get<String>(
        cacheUrl,
        options: Options(
          responseType: ResponseType.plain,
          headers: {...identity, 'Range': 'bytes=$start-${length - 1}'},
        ),
      );
      if (response.statusCode != 206 && response.statusCode != 200) return null;

      final matches = _versionPattern.allMatches(response.data ?? '');
      return matches.isEmpty ? null : matches.last.group(1);
    } catch (e) {
      debugPrint('Error fetching cache version: $e');
    }
    return null;
  }

  /// Downloads the card cache. When [etag] is given and the file did not
  /// change, returns a [CardCacheDownload] with [CardCacheDownload.notModified].
  Future<CardCacheDownload> downloadCardCache({
    String? etag,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        cacheUrl,
        onReceiveProgress: onProgress,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'If-None-Match': ?etag},
          validateStatus: (status) => status == 200 || status == 304,
        ),
      );

      if (response.statusCode == 304) {
        return CardCacheDownload(etag: etag);
      }

      final data = response.data;
      if (data == null || data.isEmpty) {
        throw Exception('Failed to fetch card data: empty response');
      }
      return CardCacheDownload(
        bytes: data is Uint8List ? data : Uint8List.fromList(data),
        etag: response.headers.value('etag'),
      );
    }
    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while fetching card data.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while fetching card data.');
      }
      throw Exception('Dio error while fetching card data: ${e.message}');
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
