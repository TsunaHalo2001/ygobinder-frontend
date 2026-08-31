import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

part 'card_list_provider.g.dart';

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

@riverpod
class CardList extends _$CardList {
  int _offset = 0;
  final int _pageSize = 50;
  String _currentSearch = '';
  String? _currentTypeFilter;
  String? _currentAttributeFilter;
  String? _currentRaceFilter;
  String? _currentSubTypeFilter;
  String? _currentFrameFilter;
  int? _currentLevelFilter;
  int? _currentScaleFilter;
  int? _currentLinkValFilter;
  int? _currentAtkFilter;
  String? _currentAtkOperator;
  bool? _currentAtkShowQuestionMark;
  int? _currentDefFilter;
  String? _currentDefOperator;
  bool? _currentDefShowQuestionMark;
  
  String _currentSortBy = 'name'; // ✅ Added sort field
  bool _currentSortDescending = false; // ✅ Added sort direction

  @override
  Future<CardListState> build() async {
    _offset = 0;
    _currentSearch = '';
    _currentTypeFilter = null;
    _currentAttributeFilter = null;
    _currentRaceFilter = null;
    _currentSubTypeFilter = null;
    _currentFrameFilter = null;
    _currentLevelFilter = null;
    _currentScaleFilter = null;
    _currentLinkValFilter = null;
    _currentAtkFilter = null;
    _currentAtkOperator = null;
    _currentAtkShowQuestionMark = null;
    _currentDefFilter = null;
    _currentDefOperator = null;
    _currentDefShowQuestionMark = null;
    _currentSortBy = 'name';
    _currentSortDescending = false;
    
    final initialCards = await _fetchPage(0);
    _offset = initialCards.length;
    
    return CardListState(
      cards: initialCards,
      hasMore: initialCards.length >= _pageSize,
    );
  }

  Future<List<YgoCard>> _fetchPage(int offset) async {
    final repo = ref.read(cardRepositoryProvider);
    return repo.getCardsPage(
      offset: offset,
      limit: _pageSize,
      searchQuery: _currentSearch,
      typeFilter: _currentTypeFilter,
      attributeFilter: _currentAttributeFilter,
      raceFilter: _currentRaceFilter,
      subTypeFilter: _currentSubTypeFilter,
      frameFilter: _currentFrameFilter,
      levelFilter: _currentLevelFilter,
      scaleFilter: _currentScaleFilter,
      linkValFilter: _currentLinkValFilter,
      atkFilter: _currentAtkFilter,
      atkOperator: _currentAtkOperator,
      atkShowQuestionMark: _currentAtkShowQuestionMark,
      defFilter: _currentDefFilter,
      defOperator: _currentDefOperator,
      defShowQuestionMark: _currentDefShowQuestionMark,
      sortBy: _currentSortBy,
      sortDescending: _currentSortDescending,
    );
  }

  bool get isFiltered => 
      _currentTypeFilter != null || 
      _currentAttributeFilter != null || 
      _currentRaceFilter != null || 
      _currentSubTypeFilter != null ||
      _currentFrameFilter != null ||
      _currentLevelFilter != null ||
      _currentScaleFilter != null ||
      _currentLinkValFilter != null ||
      _currentAtkFilter != null ||
      _currentAtkShowQuestionMark != null ||
      _currentDefFilter != null ||
      _currentDefShowQuestionMark != null;

  String? get currentTypeFilter => _currentTypeFilter;
  String? get currentAttributeFilter => _currentAttributeFilter;
  String? get currentRaceFilter => _currentRaceFilter;
  String? get currentSubTypeFilter => _currentSubTypeFilter;
  String? get currentFrameFilter => _currentFrameFilter;
  int? get currentLevelFilter => _currentLevelFilter;
  int? get currentScaleFilter => _currentScaleFilter;
  int? get currentLinkValFilter => _currentLinkValFilter;
  int? get currentAtkFilter => _currentAtkFilter;
  String? get currentAtkOperator => _currentAtkOperator;
  bool? get currentAtkShowQuestionMark => _currentAtkShowQuestionMark;
  int? get currentDefFilter => _currentDefFilter;
  String? get currentDefOperator => _currentDefOperator;
  bool? get currentDefShowQuestionMark => _currentDefShowQuestionMark;
  
  String get currentSortBy => _currentSortBy;
  bool get currentSortDescending => _currentSortDescending;

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) return;

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final newCards = await _fetchPage(_offset);
      
      state = AsyncValue.data(CardListState(
        cards: [...currentState.cards, ...newCards],
        hasMore: newCards.length >= _pageSize,
        isLoadingMore: false,
      ));

      _offset += newCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> search(String query) async {
    if (_currentSearch == query) return;

    _currentSearch = query;
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setTypeFilter(String? type) async {
    if (_currentTypeFilter == type) return;

    _currentTypeFilter = type;
    if (type != 'Monster') {
      _currentAttributeFilter = null;
      _currentRaceFilter = null;
      _currentSubTypeFilter = null;
      _currentFrameFilter = null;
      _currentLevelFilter = null;
      _currentScaleFilter = null;
      _currentLinkValFilter = null;
      _currentAtkFilter = null;
      _currentAtkOperator = null;
      _currentAtkShowQuestionMark = null;
      _currentDefFilter = null;
      _currentDefOperator = null;
      _currentDefShowQuestionMark = null;
    }
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setAttributeFilter(String? attribute) async {
    if (_currentAttributeFilter == attribute) return;

    _currentAttributeFilter = attribute;
    _currentTypeFilter = 'Monster';
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
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
  }) async {
    if (_currentTypeFilter == type && 
        _currentAttributeFilter == attribute && 
        _currentRaceFilter == race && 
        _currentSubTypeFilter == subType &&
        _currentFrameFilter == frame &&
        _currentLevelFilter == level &&
        _currentScaleFilter == scale &&
        _currentLinkValFilter == linkVal &&
        _currentAtkFilter == atk &&
        _currentAtkOperator == atkOperator &&
        _currentAtkShowQuestionMark == atkShowQuestionMark &&
        _currentDefFilter == def &&
        _currentDefOperator == defOperator &&
        _currentDefShowQuestionMark == defShowQuestionMark) return;

    _currentTypeFilter = type;
    _currentAttributeFilter = attribute;
    _currentRaceFilter = race;
    _currentSubTypeFilter = subType;
    _currentFrameFilter = frame;
    _currentLevelFilter = level;
    _currentScaleFilter = scale;
    _currentLinkValFilter = linkVal;
    _currentAtkFilter = atk;
    _currentAtkOperator = atkOperator;
    _currentAtkShowQuestionMark = atkShowQuestionMark;
    _currentDefFilter = def;
    _currentDefOperator = defOperator;
    _currentDefShowQuestionMark = defShowQuestionMark;
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setSort(String sortBy, bool descending) async {
    if (_currentSortBy == sortBy && _currentSortDescending == descending) return;

    _currentSortBy = sortBy;
    _currentSortDescending = descending;
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearFilters() async {
    _currentTypeFilter = null;
    _currentAttributeFilter = null;
    _currentRaceFilter = null;
    _currentSubTypeFilter = null;
    _currentFrameFilter = null;
    _currentLevelFilter = null;
    _currentScaleFilter = null;
    _currentLinkValFilter = null;
    _currentAtkFilter = null;
    _currentAtkOperator = null;
    _currentAtkShowQuestionMark = null;
    _currentDefFilter = null;
    _currentDefOperator = null;
    _currentDefShowQuestionMark = null;
    _offset = 0;

    state = const AsyncValue.loading();
    try {
      final initialCards = await _fetchPage(0);
      state = AsyncValue.data(CardListState(
        cards: initialCards,
        hasMore: initialCards.length >= _pageSize,
      ));
      _offset = initialCards.length;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
