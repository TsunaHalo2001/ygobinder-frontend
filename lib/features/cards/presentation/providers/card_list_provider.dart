import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/models/card_filters.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

class CardListState {
  final List<YgoCard> cards;
  final bool hasMore;
  final bool isLoadingMore;

  CardListState({
    required this.cards,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  CardListState copyWith({
    List<YgoCard>? cards,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CardListState(
      cards: cards ?? this.cards,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Paging, search, filter and sort logic shared by [CardList] (collection
/// tab) and [DeckCardList] (deck builder sidebar).
///
/// Every request is tagged with a generation number; responses that arrive
/// after a newer search/filter/sort request was issued are discarded, so a
/// slow query can never overwrite newer results or append stale pages.
mixin PagedCardListMixin on AsyncNotifier<CardListState> {
  static const pageSize = 50;

  CardFilters _filters = const CardFilters();
  int _offset = 0;
  int _generation = 0;

  CardFilters get filters => _filters;
  bool get isFiltered => _filters.isFiltered;
  String? get currentTypeFilter => _filters.type;
  String get currentSortBy => _filters.sortBy;
  bool get currentSortDescending => _filters.sortDescending;

  Future<List<YgoCard>> _fetchPage(int offset) {
    return ref.read(cardRepositoryProvider).getCardsPage(
          offset: offset,
          limit: pageSize,
          filters: _filters,
        );
  }

  CardListState _firstPage(List<YgoCard> cards) {
    _offset = cards.length;
    return CardListState(cards: cards, hasMore: cards.length >= pageSize);
  }

  /// Initial load used by `build()`; resets every criterion.
  Future<CardListState> _buildFirstPage() async {
    _filters = const CardFilters();
    _offset = 0;
    _generation++;
    return _firstPage(await _fetchPage(0));
  }

  Future<void> _reload(CardFilters next) async {
    _filters = next;
    _offset = 0;
    final generation = ++_generation;

    state = const AsyncValue.loading();
    try {
      final cards = await _fetchPage(0);
      if (!ref.mounted || generation != _generation) return;
      state = AsyncValue.data(_firstPage(cards));
    } catch (e, stack) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) return;

    final generation = _generation;
    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final newCards = await _fetchPage(_offset);
      if (!ref.mounted || generation != _generation) return;

      _offset += newCards.length;
      state = AsyncValue.data(CardListState(
        cards: [...currentState.cards, ...newCards],
        hasMore: newCards.length >= pageSize,
      ));
    } catch (e, stack) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> search(String query) async {
    if (_filters.search == query) return;
    await _reload(_filters.withSearch(query));
  }

  Future<void> applyFilters({
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
    return _reload(_filters.withAttributes(
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
      onlyGoat: onlyGoat,
      onlyEdison: onlyEdison,
      onlyHat: onlyHat,
      onlyFavorites: onlyFavorites,
      onlyWanted: onlyWanted,
    ));
  }

  Future<void> setSort(String sortBy, bool descending) async {
    if (_filters.sortBy == sortBy && _filters.sortDescending == descending) return;
    await _reload(_filters.withSort(sortBy, descending));
  }

  /// Clears search and filters, keeping the current sort.
  Future<void> clearFilters() => _reload(_filters.cleared());

  /// Restores search, filters and sort to their defaults.
  Future<void> resetSearchAndFilters() => _reload(const CardFilters());
}

/// Card list shown in the Collection tab.
class CardList extends AsyncNotifier<CardListState> with PagedCardListMixin {
  @override
  Future<CardListState> build() => _buildFirstPage();
}

final cardListProvider = AsyncNotifierProvider.autoDispose<CardList, CardListState>(CardList.new);

/// Card list shown in the deck builder sidebar.
class DeckCardList extends AsyncNotifier<CardListState> with PagedCardListMixin {
  @override
  Future<CardListState> build() => _buildFirstPage();
}

final deckCardListProvider = AsyncNotifierProvider.autoDispose<DeckCardList, CardListState>(DeckCardList.new);
