import 'package:flutter_test/flutter_test.dart';
import 'package:ygobinder/core/app_version.dart';
import 'package:ygobinder/core/providers/currency_provider.dart';
import 'package:ygobinder/core/utils/formatters.dart';
import 'package:ygobinder/features/cards/data/models/ban_status.dart';
import 'package:ygobinder/features/decks/data/ydk.dart';
import 'package:ygobinder/features/options/presentation/screens/options_tab.dart';

void main() {
  group('ydk', () {
    test('replaceYdkCardIds maps retired ids and keeps other lines', () {
      const content = '#created by tool\r\n#main\r\n46986414\r\n89631139\r\n!side\r\n46986414\r\n';
      expect(
        replaceYdkCardIds(content, {46986414: 46986420}),
        '#created by tool\r\n#main\r\n46986420\r\n89631139\r\n!side\r\n46986420\r\n',
      );
      expect(replaceYdkCardIds(content, const {}), content);
    });

    test('build → parse round trip keeps order and duplicates', () {
      final content = buildYdk(main: [1, 1, 2], extra: [3], side: [4]);
      expect(content, '#main\n1\n1\n2\n#extra\n3\n!side\n4\n');
      expect(parseYdkContent(content), {
        'main': [1, 1, 2],
        'extra': [3],
        'side': [4],
      });
    });

    test('parse ignores comments, blanks and ids before a section', () {
      const content = '#created by someone\n99\n#main\n\n 10 \n#extra\n!side\n';
      expect(parseYdkContent(content), {
        'main': [10],
        'extra': <int>[],
        'side': <int>[],
      });
    });
  });

  group('parseBanStatus', () {
    test('maps text and numeric values', () {
      expect(parseBanStatus('Forbidden'), BanStatus.forbidden);
      expect(parseBanStatus('0'), BanStatus.forbidden);
      expect(parseBanStatus('Limited'), BanStatus.limited);
      expect(parseBanStatus('1'), BanStatus.limited);
      expect(parseBanStatus('Semi-Limited'), BanStatus.semiLimited);
      expect(parseBanStatus('2'), BanStatus.semiLimited);
      expect(parseBanStatus('3'), BanStatus.unlimited);
      expect(parseBanStatus(null), BanStatus.unlimited);
    });
  });

  group('formatters', () {
    test('thousand separators', () {
      expect(formatWithThousandSeparators(1234567.891), '1,234,567.89');
      expect(formatWithThousandSeparators(999), '999.00');
      expect(formatWithThousandSeparators(1234.4, decimals: 0), '1,234');
    });

    test('CurrencyInfo.formatPrice', () {
      expect(CurrencyInfo(code: 'USD', symbol: r'$', rateToUsd: 1).formatPrice(1234.5), r'$1,234.50');
      expect(CurrencyInfo(code: 'JPY', symbol: '¥', rateToUsd: 150).formatPrice(10), '¥1,500');
      expect(CurrencyInfo(code: 'MXN', symbol: r'$', rateToUsd: 20).formatPrice(2), r'$40.00 MXN');
      expect(CurrencyInfo(code: 'USD', symbol: r'$', rateToUsd: 1).formatPrice(0), 'N/A');
    });

    test('formatLastUpdatedTimestamp handles bad input', () {
      expect(formatLastUpdatedTimestamp(null), '');
      expect(formatLastUpdatedTimestamp('not a date'), '');
      expect(formatDateTime(DateTime(2026, 1, 2, 3, 4)), '02/01/2026 03:04');
    });
  });

  group('isAppVersionOlder', () {
    test('compares build numbers first, then semver', () {
      expect(isAppVersionOlder('1.4.0+17', '1.4.0+18'), isTrue);
      expect(isAppVersionOlder('1.4.0+17', '1.4.0+17'), isFalse);
      expect(isAppVersionOlder('1.4.0', '1.5.0'), isTrue);
      expect(isAppVersionOlder('2.0.0', '1.9.9'), isFalse);
      expect(isAppVersionOlder(kAppVersion, kAppVersion), isFalse);
    });
  });
}
