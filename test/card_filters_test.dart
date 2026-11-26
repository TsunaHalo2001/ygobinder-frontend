import 'package:flutter_test/flutter_test.dart';
import 'package:ygobinder/features/cards/data/models/card_filters.dart';

void main() {
  group('CardFilters', () {
    test('defaults are not filtered and sort by name ascending', () {
      const f = CardFilters();
      expect(f.isFiltered, isFalse);
      expect(f.search, '');
      expect(f.sortBy, 'name');
      expect(f.sortDescending, isFalse);
    });

    test('search alone does not count as filtered', () {
      expect(const CardFilters().withSearch('blue').isFiltered, isFalse);
    });

    test('withAttributes replaces attribute filters and keeps only* flags when null', () {
      final base = const CardFilters(search: 'dragon', sortBy: 'atk', onlyGoat: true)
          .withAttributes(type: 'Monster', attribute: 'LIGHT', level: 8);

      expect(base.type, 'Monster');
      expect(base.attribute, 'LIGHT');
      expect(base.level, 8);
      expect(base.onlyGoat, isTrue, reason: 'null only* keeps current value');
      expect(base.search, 'dragon');
      expect(base.sortBy, 'atk');
      expect(base.isFiltered, isTrue);

      final next = base.withAttributes(type: 'Spell', onlyGoat: false);
      expect(next.type, 'Spell');
      expect(next.attribute, isNull, reason: 'null attribute clears it');
      expect(next.level, isNull);
      expect(next.onlyGoat, isFalse);
    });

    test('cleared keeps sort but resets search and filters', () {
      final f = const CardFilters(search: 'x', sortBy: 'def', sortDescending: true)
          .withAttributes(type: 'Trap', onlyWanted: true)
          .cleared();
      expect(f.search, '');
      expect(f.isFiltered, isFalse);
      expect(f.sortBy, 'def');
      expect(f.sortDescending, isTrue);
    });

    test('withSort keeps filters', () {
      final f = const CardFilters().withAttributes(type: 'Monster').withSort('tcgDate', true);
      expect(f.type, 'Monster');
      expect(f.sortBy, 'tcgDate');
      expect(f.sortDescending, isTrue);
    });
  });
}
