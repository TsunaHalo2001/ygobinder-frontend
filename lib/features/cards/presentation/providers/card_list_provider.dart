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

  @override
  Future<CardListState> build() async {
    _offset = 0;
    _currentSearch = '';
    
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
    );
  }

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
}
