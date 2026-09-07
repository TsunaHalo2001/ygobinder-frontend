// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider = SelectedCurrencyProvider._();

final class SelectedCurrencyProvider
    extends $NotifierProvider<SelectedCurrency, String> {
  SelectedCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCurrencyHash();

  @$internal
  @override
  SelectedCurrency create() => SelectedCurrency();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCurrencyHash() => r'125f074cac8d408e4aeb80e93fa805c54c233b5f';

abstract class _$SelectedCurrency extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CustomCurrencyRate)
final customCurrencyRateProvider = CustomCurrencyRateProvider._();

final class CustomCurrencyRateProvider
    extends $NotifierProvider<CustomCurrencyRate, double> {
  CustomCurrencyRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customCurrencyRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customCurrencyRateHash();

  @$internal
  @override
  CustomCurrencyRate create() => CustomCurrencyRate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$customCurrencyRateHash() =>
    r'0a79c25ba8ed8a6f054b6dcadb1458481692a872';

abstract class _$CustomCurrencyRate extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(currencyRatesStream)
final currencyRatesStreamProvider = CurrencyRatesStreamProvider._();

final class CurrencyRatesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          Stream<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $StreamProvider<Map<String, double>> {
  CurrencyRatesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyRatesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyRatesStreamHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, double>> create(Ref ref) {
    return currencyRatesStream(ref);
  }
}

String _$currencyRatesStreamHash() =>
    r'7cba6baa1090397584fefee4f5133ab2319df0b9';

@ProviderFor(activeCurrencyInfo)
final activeCurrencyInfoProvider = ActiveCurrencyInfoProvider._();

final class ActiveCurrencyInfoProvider
    extends $FunctionalProvider<CurrencyInfo, CurrencyInfo, CurrencyInfo>
    with $Provider<CurrencyInfo> {
  ActiveCurrencyInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCurrencyInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCurrencyInfoHash();

  @$internal
  @override
  $ProviderElement<CurrencyInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CurrencyInfo create(Ref ref) {
    return activeCurrencyInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyInfo>(value),
    );
  }
}

String _$activeCurrencyInfoHash() =>
    r'ef76629fd899c0eeec21e0cf5d700984a1a7ad9a';
