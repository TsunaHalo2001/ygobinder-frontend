import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/decks/presentation/providers/deck_file_provider.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_list_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/widgets/card_filter_dialogs.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

class DeckTab extends ConsumerStatefulWidget {
  const DeckTab({super.key});

  @override
  ConsumerState<DeckTab> createState() => _DeckTabState();
}

class _DeckTabState extends ConsumerState<DeckTab> {
  bool _isEditing = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
      );

      if (result.isNotEmpty && result.first.path != null) {
        await ref.read(deckFileContentProvider.notifier).loadFromPath(result.first.path!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _saveDeck() async {
    final nameController = TextEditingController(
      text: ref.read(deckFileContentProvider).name ?? '',
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Deck'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Enter deck name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        await ref.read(deckFileContentProvider.notifier).saveToDatabase(name);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deck saved successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving deck: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteDeck(int deckId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(deckFileContentProvider.notifier).deleteDeck(deckId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deck "$name" deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting deck: $e')),
          );
        }
      }
    }
  }

  void _editDeck([int? deckId, String? name]) {
    if (deckId != null) {
      ref.read(deckFileContentProvider.notifier).loadFromDatabase(deckId);
    }
    ref.read(deckCardListProvider.notifier).resetSearchAndFilters();
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deckState = ref.watch(deckFileContentProvider);
    final savedDecksAsync = ref.watch(savedDecksProvider);
    final processedDeckAsync = ref.watch(processedDeckDataProvider);
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DECK BUILDER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          if (deckState.content.isNotEmpty) ...[
            IconButton(
              onPressed: () => _editDeck(),
              icon: Icon(
                _isEditing ? Icons.edit_off_rounded : Icons.edit_rounded,
                color: _isEditing ? theme.colorScheme.primary : null,
              ),
              tooltip: _isEditing ? 'Exit Edit Mode' : 'Edit Deck',
            ),
            IconButton(
              onPressed: () => ref.read(deckFileContentProvider.notifier).shareDeck(),
              icon: const Icon(Icons.share_rounded),
              tooltip: 'Share Deck',
            ),
            IconButton(
              onPressed: _saveDeck,
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save Deck',
            ),
          ],
          IconButton(
            onPressed: _pickFile,
            icon: const Icon(Icons.file_upload_rounded),
            tooltip: 'Load Deck',
          ),
        ],
      ),
      body: deckState.content.isEmpty
          ? _buildNoDeckLoadedView(theme, savedDecksAsync)
          : Builder(
              builder: (context) {
                final deckData = processedDeckAsync.value;

                if (deckData == null) {
                  if (processedDeckAsync.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (processedDeckAsync.hasError) {
                    return Center(child: Text('Error: ${processedDeckAsync.error}'));
                  }
                  return const SizedBox.shrink();
                }

                // Compute total card counts for badge lookup in sidebar
                final totalCardsInDeck = <int, int>{};
                for (final item in [...deckData.main, ...deckData.extra, ...deckData.side]) {
                  totalCardsInDeck[item.card.id] = (totalCardsInDeck[item.card.id] ?? 0) + 1;
                }

                return Row(
                  children: [
                    // Main Deck View
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Row(
                              children: [
                                const Icon(Icons.style_rounded, size: 16, color: Colors.white60),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    deckState.name?.toUpperCase() ?? 'DECK VISUALIZER',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white60,
                                      letterSpacing: 1.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _editDeck(),
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    size: 16,
                                    color: _isEditing ? theme.colorScheme.primary : Colors.amber,
                                  ),
                                  tooltip: 'Edit Deck',
                                  visualDensity: VisualDensity.compact,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() => _isEditing = false);
                                    ref.read(deckFileContentProvider.notifier).reset();
                                  },
                                  icon: const Icon(Icons.close_rounded, size: 16),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                ..._buildCategorySectionSlivers('MAIN DECK', 'main', deckData.main, theme, cacheManager),
                                ..._buildCategorySectionSlivers('EXTRA DECK', 'extra', deckData.extra, theme, cacheManager),
                                ..._buildCategorySectionSlivers('SIDE DECK', 'side', deckData.side, theme, cacheManager, isLast: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Side Panel when Editing
                    if (_isEditing) ...[
                      const VerticalDivider(width: 1, thickness: 1, color: Colors.white10),
                      SizedBox(
                        width: isWideScreen ? 340 : 260,
                        child: _DeckEditSidebar(
                          totalCardsInDeck: totalCardsInDeck,
                          onClose: () => setState(() => _isEditing = false),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }

  Widget _buildNoDeckLoadedView(ThemeData theme, AsyncValue<List<dynamic>> savedDecksAsync) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.style_rounded, size: 64, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Deck Loaded',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search or Drop a .ydk file here',
              style: TextStyle(color: Colors.white38),
            ),
            const SizedBox(height: 32),
            
            // Saved Decks Selector
            savedDecksAsync.when(
              data: (decks) {
                if (decks.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    const Text(
                      'SAVED DECKS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: decks.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                          itemBuilder: (context, index) {
                            final deck = decks[index];
                            return ListTile(
                              leading: const Icon(Icons.folder_special_rounded, color: Colors.amber),
                              title: Text(deck.name),
                              subtitle: Text(
                                'Last updated: ${deck.updatedAt.day}/${deck.updatedAt.month}/${deck.updatedAt.year}',
                                style: const TextStyle(fontSize: 10, color: Colors.white38),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: Colors.amber),
                                    tooltip: 'Edit Deck',
                                    onPressed: () => _editDeck(deck.id, deck.name),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    tooltip: 'Delete Deck',
                                    onPressed: () => _deleteDeck(deck.id, deck.name),
                                  ),
                                ],
                              ),
                              onTap: () {
                                ref.read(deckFileContentProvider.notifier).loadFromDatabase(deck.id);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading decks: $err'),
            ),

            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.search_rounded),
              label: const Text('SEARCH YDK FILE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategorySectionSlivers(
    String title,
    String categoryKey,
    List<DeckVisualCard> visualCards,
    ThemeData theme,
    CacheManager cacheManager, {
    bool isLast = false,
  }) {
    if (visualCards.isEmpty) return const [];

    return [
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${visualCards.length})',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 80,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _DeckCardTile(
                visual: visualCards[index],
                categoryKey: categoryKey,
                isEditing: _isEditing,
                cacheManager: cacheManager,
              );
            },
            childCount: visualCards.length,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: isLast ? 16 : 24)),
    ];
  }
}

class _DeckCardTile extends ConsumerWidget {
  final DeckVisualCard visual;
  final String categoryKey;
  final bool isEditing;
  final CacheManager cacheManager;

  const _DeckCardTile({
    required this.visual,
    required this.categoryKey,
    required this.isEditing,
    required this.cacheManager,
  });

  static const _grayscaleFilter = ColorFilter.mode(Colors.grey, BlendMode.saturation);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = visual.card;
    final isOwned = visual.isOwned;
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlSmall ?? '';

    Widget imageWidget;
    if (imageUrl.isEmpty) {
      imageWidget = Container(
        color: Colors.white.withValues(alpha: 0.05),
        child: Center(
          child: Image.asset(
            'assets/images/icon/logo.png',
            width: 24,
            height: 24,
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
        ),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        cacheManager: cacheManager,
        memCacheWidth: 160,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.white.withValues(alpha: 0.05),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.white.withValues(alpha: 0.05),
          child: Center(
            child: Image.asset(
              'assets/images/icon/logo.png',
              width: 24,
              height: 24,
              opacity: const AlwaysStoppedAnimation(0.2),
            ),
          ),
        ),
      );
    }

    if (!isOwned) {
      imageWidget = ColorFiltered(
        colorFilter: _grayscaleFilter,
        child: imageWidget,
      );
    }

    return RepaintBoundary(
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => context.push('/card/${card.id}'),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isOwned ? Colors.white10 : Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageWidget,
              ),
            ),
          ),

          // Remove Button Badge in Edit Mode
          if (isEditing)
            Positioned(
              top: 2,
              right: 2,
              child: Material(
                color: Colors.redAccent.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    ref
                        .read(deckFileContentProvider.notifier)
                        .removeOneCopyFromCategory(card.id, categoryKey);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.remove_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeckEditSidebar extends ConsumerStatefulWidget {
  final Map<int, int> totalCardsInDeck;
  final VoidCallback onClose;

  const _DeckEditSidebar({
    required this.totalCardsInDeck,
    required this.onClose,
  });

  @override
  ConsumerState<_DeckEditSidebar> createState() => _DeckEditSidebarState();
}

class _DeckEditSidebarState extends ConsumerState<_DeckEditSidebar> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deckCardListProvider.notifier).resetSearchAndFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    ref.read(deckCardListProvider.notifier).resetSearchAndFilters();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      ref.read(deckCardListProvider.notifier).loadMore();
    }
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CardFilterBottomSheet(isDeckBuilder: true),
    );
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const CardSortBottomSheet(isDeckBuilder: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardListState = ref.watch(deckCardListProvider);
    final isFiltered = ref.watch(deckCardListProvider.notifier).isFiltered;

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Sidebar Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.style_rounded, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ADD CARDS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Search card name...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(deckCardListProvider.notifier).search('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (value) {
                    ref.read(deckCardListProvider.notifier).search(value);
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showFilterMenu(context),
                        icon: Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: isFiltered ? theme.colorScheme.primary : Colors.white70,
                        ),
                        label: Text(
                          isFiltered ? 'FILTERED' : 'FILTERS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isFiltered ? theme.colorScheme.primary : Colors.white70,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(
                            color: isFiltered ? theme.colorScheme.primary : Colors.white24,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => _showSortMenu(context),
                      icon: const Icon(Icons.filter_list_rounded, size: 16),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Sort Options',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.white10),

          // 1-Column Card List
          Expanded(
            child: cardListState.when(
              data: (state) {
                if (state.cards.isEmpty) {
                  return const Center(
                    child: Text(
                      'No cards found',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: state.cards.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.cards.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }

                    final card = state.cards[index];
                    final totalInDeck = widget.totalCardsInDeck[card.id] ?? 0;

                    return _SidebarCardTile(
                      card: card,
                      totalInDeck: totalInDeck,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading cards: $err', style: const TextStyle(fontSize: 11)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarCardTile extends ConsumerWidget {
  final YgoCard card;
  final int totalInDeck;

  const _SidebarCardTile({
    required this.card,
    required this.totalInDeck,
  });

  bool get _isExtraDeckMonster {
    final type = card.type.toLowerCase();
    return type.contains('fusion') ||
        type.contains('synchro') ||
        type.contains('xyz') ||
        type.contains('link');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlSmall ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: totalInDeck > 0 ? theme.colorScheme.primary.withValues(alpha: 0.5) : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/card/${card.id}'),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  // Small Card Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 40,
                      height: 58,
                      child: imageUrl.isEmpty
                          ? Container(color: Colors.black26)
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              cacheManager: cacheManager,
                              memCacheWidth: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.black12),
                              errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 16),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${card.type}${card.attribute != null ? " • ${card.attribute}" : ""}',
                          style: const TextStyle(fontSize: 10, color: Colors.white54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (totalInDeck > 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$totalInDeck IN DECK',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_isExtraDeckMonster)
                _QuickAddButton(
                  label: '+ MAIN',
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    ref.read(deckFileContentProvider.notifier).addCardToCategory(card.id, 'main');
                  },
                )
              else
                _QuickAddButton(
                  label: '+ EXTRA',
                  color: Colors.purpleAccent,
                  onPressed: () {
                    ref.read(deckFileContentProvider.notifier).addCardToCategory(card.id, 'extra');
                  },
                ),
              const SizedBox(width: 6),
              _QuickAddButton(
                label: '+ SIDE',
                color: Colors.tealAccent,
                onPressed: () {
                  ref.read(deckFileContentProvider.notifier).addCardToCategory(card.id, 'side');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _QuickAddButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
