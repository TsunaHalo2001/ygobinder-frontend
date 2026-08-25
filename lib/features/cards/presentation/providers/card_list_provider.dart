import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

part 'card_list_provider.g.dart';

@riverpod
class CardList extends _$CardList {
  int _offset = 0;
  final int _pageSize = 50; // Load 50 cards at a time
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentSearch = '';

  @override
  Future<List<YgoCard>> build() async {
    // Initial load
    return _fetchPage(0);
  }

  // Helper to fetch a specific page
  Future<List<YgoCard>> _fetchPage(int offset) async {
    final db = ref.read(databaseProvider);
    final driftCards = await db.getCardsPage(
      offset: offset,
      limit: _pageSize,
      searchQuery: _currentSearch,
    );

    return driftCards.map((card) => CardMapper.toYgoCard(card)).toList();
  }

  // Call this when the user scrolls near the bottom
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    try {
      final newCards = await _fetchPage(_offset);

      // If we got fewer cards than the page size, we've reached the end
      if (newCards.length < _pageSize) {
        _hasMore = false;
      }

      // Append new cards to the existing state
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, ...newCards]);

      _offset += _pageSize;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _isLoading = false;
    }
  }

  // Call this when the user types in the search bar
  Future<void> search(String query) async {
    _currentSearch = query;
    _offset = 0;
    _hasMore = true;
    _isLoading = false;

    // Reset state and fetch the first page of the new search
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchPage(0));
    _offset = _pageSize;
  }
}