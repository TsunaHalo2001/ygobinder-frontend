import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';

part 'currency_provider.g.dart';

class CurrencyInfo {
  final String code;
  final String symbol;
  final double rateToUsd;

  CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.rateToUsd,
  });

  String formatPrice(double priceInUsd) {
    if (priceInUsd <= 0.0) return 'N/A';
    final converted = priceInUsd * rateToUsd;

    final isJpy = code == 'JPY';
    final decimals = isJpy ? 0 : 2;

    final parts = converted.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    final formattedVal = '$formattedInteger$decimalPart';

    if (code == 'USD') return '\$$formattedVal';
    if (code == 'EUR') return '€$formattedVal';
    if (code == 'GBP') return '£$formattedVal';
    if (code == 'PEN') return 'S/$formattedVal';
    if (code == 'JPY') return '¥$formattedVal';
    if (code == 'CUSTOM') return '\$$formattedVal (Custom)';

    return '$symbol$formattedVal $code';
  }
}

@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  @override
  String build() {
    _loadCurrency();
    return 'USD';
  }

  Future<void> _loadCurrency() async {
    final db = ref.read(databaseProvider);
    final code = await db.getSetting('selected_currency');
    if (code != null && code.isNotEmpty) {
      state = code.toUpperCase();
    }
  }

  Future<void> setCurrency(String code) async {
    state = code.toUpperCase();
    final db = ref.read(databaseProvider);
    await db.saveSetting('selected_currency', code.toUpperCase());
  }
}

@riverpod
class CustomCurrencyRate extends _$CustomCurrencyRate {
  @override
  double build() {
    _loadRate();
    return 1.0;
  }

  Future<void> _loadRate() async {
    final db = ref.read(databaseProvider);
    final rateStr = await db.getSetting('custom_currency_rate');
    if (rateStr != null && rateStr.isNotEmpty) {
      final parsed = double.tryParse(rateStr);
      if (parsed != null && parsed > 0) {
        state = parsed;
      }
    }
  }

  Future<void> setRate(double rate) async {
    state = rate;
    final db = ref.read(databaseProvider);
    await db.saveSetting('custom_currency_rate', rate.toString());
  }
}

@riverpod
Stream<Map<String, double>> currencyRatesStream(Ref ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllCurrencyRates().map((list) {
    return {for (final r in list) r.currencyCode.toUpperCase(): r.rateToUsd};
  });
}

@riverpod
CurrencyInfo activeCurrencyInfo(Ref ref) {
  final code = ref.watch(selectedCurrencyProvider);
  final ratesAsync = ref.watch(currencyRatesStreamProvider);
  final customRate = ref.watch(customCurrencyRateProvider);

  double rate = 1.0;
  if (code == 'CUSTOM') {
    rate = customRate;
  } else {
    final ratesMap = ratesAsync.value ?? {};
    rate = ratesMap[code] ?? 1.0;
  }

  final symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'MXN': '\$',
    'CAD': '\$',
    'JPY': '¥',
    'BRL': 'R\$',
    'ARS': '\$',
    'CLP': '\$',
    'PEN': 'S/',
    'COP': '\$',
    'CUSTOM': '\$',
  };

  return CurrencyInfo(
    code: code,
    symbol: symbols[code] ?? '\$',
    rateToUsd: rate,
  );
}
