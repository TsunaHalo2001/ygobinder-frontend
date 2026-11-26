import 'package:flutter/foundation.dart';

/// Immutable search/filter/sort criteria for the paged card lists.
@immutable
class CardFilters {
  const CardFilters({
    this.search = '',
    this.type,
    this.attribute,
    this.race,
    this.subType,
    this.frame,
    this.level,
    this.scale,
    this.linkVal,
    this.atk,
    this.atkOperator,
    this.atkShowQuestionMark,
    this.def,
    this.defOperator,
    this.defShowQuestionMark,
    this.sortBy = 'name',
    this.sortDescending = false,
    this.onlyGoat = false,
    this.onlyEdison = false,
    this.onlyHat = false,
    this.onlyFavorites = false,
    this.onlyWanted = false,
  });

  final String search;
  final String? type;
  final String? attribute;
  final String? race;
  final String? subType;
  final String? frame;
  final int? level;
  final int? scale;
  final int? linkVal;
  final int? atk;
  final String? atkOperator;
  final bool? atkShowQuestionMark;
  final int? def;
  final String? defOperator;
  final bool? defShowQuestionMark;
  final String sortBy;
  final bool sortDescending;
  final bool onlyGoat;
  final bool onlyEdison;
  final bool onlyHat;
  final bool onlyFavorites;
  final bool onlyWanted;

  /// True when any filter (not search or sort) is active.
  bool get isFiltered =>
      type != null ||
      attribute != null ||
      race != null ||
      subType != null ||
      frame != null ||
      level != null ||
      scale != null ||
      linkVal != null ||
      atk != null ||
      atkShowQuestionMark != null ||
      def != null ||
      defShowQuestionMark != null ||
      onlyGoat ||
      onlyEdison ||
      onlyHat ||
      onlyFavorites ||
      onlyWanted;

  CardFilters withSearch(String query) => _copy(search: query);

  CardFilters withSort(String sortBy, bool descending) => _copy(sortBy: sortBy, sortDescending: descending);

  /// Replaces every card-attribute filter with the given values (null clears
  /// it). The `only*` flags keep their current value when null is passed.
  CardFilters withAttributes({
    String? type,
    String? attribute,
    String? race,
    String? subType,
    String? frame,
    int? level,
    int? scale,
    int? linkVal,
    int? atk,
    String? atkOperator,
    bool? atkShowQuestionMark,
    int? def,
    String? defOperator,
    bool? defShowQuestionMark,
    bool? onlyGoat,
    bool? onlyEdison,
    bool? onlyHat,
    bool? onlyFavorites,
    bool? onlyWanted,
  }) {
    return CardFilters(
      search: search,
      type: type,
      attribute: attribute,
      race: race,
      subType: subType,
      frame: frame,
      level: level,
      scale: scale,
      linkVal: linkVal,
      atk: atk,
      atkOperator: atkOperator,
      atkShowQuestionMark: atkShowQuestionMark,
      def: def,
      defOperator: defOperator,
      defShowQuestionMark: defShowQuestionMark,
      sortBy: sortBy,
      sortDescending: sortDescending,
      onlyGoat: onlyGoat ?? this.onlyGoat,
      onlyEdison: onlyEdison ?? this.onlyEdison,
      onlyHat: onlyHat ?? this.onlyHat,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      onlyWanted: onlyWanted ?? this.onlyWanted,
    );
  }

  /// Clears search and every filter but keeps the current sort.
  CardFilters cleared() => CardFilters(sortBy: sortBy, sortDescending: sortDescending);

  CardFilters _copy({String? search, String? sortBy, bool? sortDescending}) {
    return CardFilters(
      search: search ?? this.search,
      type: type,
      attribute: attribute,
      race: race,
      subType: subType,
      frame: frame,
      level: level,
      scale: scale,
      linkVal: linkVal,
      atk: atk,
      atkOperator: atkOperator,
      atkShowQuestionMark: atkShowQuestionMark,
      def: def,
      defOperator: defOperator,
      defShowQuestionMark: defShowQuestionMark,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
      onlyGoat: onlyGoat,
      onlyEdison: onlyEdison,
      onlyHat: onlyHat,
      onlyFavorites: onlyFavorites,
      onlyWanted: onlyWanted,
    );
  }
}
