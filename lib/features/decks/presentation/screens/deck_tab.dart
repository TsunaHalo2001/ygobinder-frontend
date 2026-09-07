import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:ygobinder/features/decks/presentation/providers/deck_file_provider.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_list_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/widgets/card_filter_dialogs.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:ygobinder/core/providers/currency_provider.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

enum BanlistStatus { forbidden, limited, semiLimited, unlimited }

BanlistStatus getBanlistStatus(YgoCard card, String banlist) {
  final info = card.banlistInfo;
  final format = banlist.toUpperCase();

  String? rawStatus;
  if (format == 'TCG') {
    rawStatus = info?.banTcg;
  } else if (format == 'OCG') {
    rawStatus = info?.banOcg;
  } else if (format == 'GOAT') {
    rawStatus = info?.banGoat;
  } else if (format == 'EDISON') {
    rawStatus = info?.banEdison;
    // Edison rule: If card has no Edison record (or empty), it is not legal in Edison -> forbidden!
    if (rawStatus == null || rawStatus.isEmpty) {
      return BanlistStatus.forbidden;
    }
  }

  if (rawStatus == null || rawStatus.isEmpty) {
    return BanlistStatus.unlimited;
  }

  final lower = rawStatus.toLowerCase().trim();
  if (lower.contains('forbid') || lower.contains('banned') || lower == '0') {
    return BanlistStatus.forbidden;
  } else if (lower.contains('semi') || lower == '2') {
    return BanlistStatus.semiLimited;
  } else if (lower.contains('limited') || lower == '1') {
    return BanlistStatus.limited;
  } else if (lower.contains('legal') || lower.contains('unlimited') || lower == '3') {
    return BanlistStatus.unlimited;
  }

  return BanlistStatus.unlimited;
}

class _BanlistBadge extends StatelessWidget {
  final BanlistStatus status;

  const _BanlistBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == BanlistStatus.unlimited) return const SizedBox.shrink();

    Color color;
    String text;

    switch (status) {
      case BanlistStatus.forbidden:
        color = Colors.redAccent;
        text = '0';
        break;
      case BanlistStatus.limited:
        color = Colors.amber;
        text = '1';
        break;
      case BanlistStatus.semiLimited:
        color = Colors.orangeAccent;
        text = '2';
        break;
      case BanlistStatus.unlimited:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class DeckTab extends ConsumerStatefulWidget {
  const DeckTab({super.key});

  @override
  ConsumerState<DeckTab> createState() => _DeckTabState();
}

class _DeckTabState extends ConsumerState<DeckTab> {
  bool _isEditing = false;
  String _selectedBanlist = 'TCG';

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

  Future<void> _createNewDeck() async {
    final nameController = TextEditingController(text: 'New Deck');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Deck'),
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('CREATE'),
          ),
        ],
      ),
    );

    if (name != null && name.trim().isNotEmpty) {
      ref.read(deckFileContentProvider.notifier).createNewDeck(name.trim());
      ref.read(deckCardListProvider.notifier).resetSearchAndFilters();
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  void deactivate() {
    final deckState = ref.read(deckFileContentProvider);
    if (deckState.isQuoteDeck) {
      ref.read(deckFileContentProvider.notifier).reset();
    }
    super.deactivate();
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
        toolbarHeight: 40,
        leadingWidth: deckState.content.isNotEmpty ? 80 : null,
        leading: deckState.content.isNotEmpty
            ? Center(
                child: PopupMenuButton<String>(
                  initialValue: _selectedBanlist,
                  tooltip: 'Select Banlist Format',
                  padding: EdgeInsets.zero,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedBanlist,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 14, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _selectedBanlist = value;
                    });
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'TCG', child: Text('TCG Format')),
                    PopupMenuItem(value: 'OCG', child: Text('OCG Format')),
                    PopupMenuItem(value: 'GOAT', child: Text('GOAT Format')),
                    PopupMenuItem(value: 'EDISON', child: Text('EDISON Format')),
                  ],
                ),
              )
            : null,
        title: const Text('DECK BUILDER', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _createNewDeck,
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New Deck',
            visualDensity: VisualDensity.compact,
          ),
          if (deckState.content.isNotEmpty && !deckState.isQuoteDeck) ...[
            IconButton(
              onPressed: () => _editDeck(),
              icon: Icon(
                _isEditing ? Icons.edit_off_rounded : Icons.edit_rounded,
                color: _isEditing ? theme.colorScheme.primary : null,
              ),
              tooltip: _isEditing ? 'Exit Edit Mode' : 'Edit Deck',
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              onPressed: _saveDeck,
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save Deck',
              visualDensity: VisualDensity.compact,
            ),
          ],
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More Options',
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'share') {
                ref.read(deckFileContentProvider.notifier).shareDeck();
              } else if (value == 'import') {
                _pickFile();
              }
            },
            itemBuilder: (context) => [
              if (deckState.content.isNotEmpty)
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded, size: 18),
                      SizedBox(width: 12),
                      Text('Share Deck'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.file_upload_rounded, size: 18),
                    SizedBox(width: 12),
                    Text('Import .YDK File'),
                  ],
                ),
              ),
            ],
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

                final isShortHeight = MediaQuery.sizeOf(context).height < 500;

                final deckView = Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: isShortHeight ? 4 : 10,
                      ),
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Row(
                        children: [
                          Icon(Icons.style_rounded, size: isShortHeight ? 14 : 18, color: Colors.white60),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              deckState.name?.toUpperCase() ?? 'DECK VISUALIZER',
                              style: TextStyle(
                                fontSize: isShortHeight ? 10 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60,
                                letterSpacing: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!deckState.isQuoteDeck)
                            IconButton(
                              onPressed: () => _editDeck(),
                              icon: Icon(
                                Icons.edit_rounded,
                                size: isShortHeight ? 14 : 18,
                                color: _isEditing ? theme.colorScheme.primary : Colors.amber,
                              ),
                              tooltip: 'Edit Deck',
                              visualDensity: isShortHeight ? VisualDensity.compact : VisualDensity.standard,
                            ),
                          IconButton(
                            onPressed: () {
                              setState(() => _isEditing = false);
                              ref.read(deckFileContentProvider.notifier).reset();
                            },
                            icon: Icon(Icons.close_rounded, size: isShortHeight ? 14 : 18),
                            tooltip: 'Close Deck',
                            visualDensity: isShortHeight ? VisualDensity.compact : VisualDensity.standard,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          ..._buildCategorySectionSlivers('MAIN DECK', 'main', deckData.main, theme, cacheManager, _selectedBanlist),
                          ..._buildCategorySectionSlivers('EXTRA DECK', 'extra', deckData.extra, theme, cacheManager, _selectedBanlist),
                          ..._buildCategorySectionSlivers('SIDE DECK', 'side', deckData.side, theme, cacheManager, _selectedBanlist, isLast: false),
                          SliverToBoxAdapter(
                            child: _DeckTotalPriceSummary(deckData: deckData),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                if (isWideScreen) {
                  return Row(
                    children: [
                      Expanded(child: deckView),
                      if (_isEditing) ...[
                        const VerticalDivider(width: 1, thickness: 1, color: Colors.white10),
                        SizedBox(
                          width: 340,
                          child: _DeckEditSidebar(
                            totalCardsInDeck: totalCardsInDeck,
                            selectedBanlist: _selectedBanlist,
                            onClose: () => setState(() => _isEditing = false),
                          ),
                        ),
                      ],
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      Positioned.fill(child: deckView),
                      if (_isEditing) ...[
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => setState(() => _isEditing = false),
                            child: Container(color: Colors.black54),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            child: Material(
                              elevation: 16,
                              color: theme.colorScheme.surface,
                              child: _DeckEditSidebar(
                                totalCardsInDeck: totalCardsInDeck,
                                selectedBanlist: _selectedBanlist,
                                onClose: () => setState(() => _isEditing = false),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }
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
            
            // Saved & Mandatory Decks Selector
            Column(
              children: [
                const Text(
                  'AVAILABLE DECKS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Mandatory Quoted Cards (#0) Deck Tile
                        ListTile(
                          leading: const Icon(Icons.request_quote_rounded, color: Colors.amber),
                          title: const Text('Quoted Cards (#0)', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Read-only view of Collection #0 items', style: TextStyle(fontSize: 11, color: Colors.white38)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                            ),
                            child: const Text('MANDATORY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amber)),
                          ),
                          onTap: () {
                            ref.read(deckFileContentProvider.notifier).loadQuoteDeck();
                          },
                        ),
                        const Divider(height: 1, color: Colors.white10),

                        // Saved Decks List
                        ...savedDecksAsync.maybeWhen(
                          data: (decks) => decks.map((deck) {
                            return ListTile(
                              leading: const Icon(Icons.folder_special_rounded, color: Colors.blueAccent),
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
                          }).toList(),
                          orElse: () => [],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createNewDeck,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('NEW DECK', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_upload_rounded),
                    label: const Text('IMPORT .YDK', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
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
    CacheManager cacheManager,
    String selectedBanlist, {
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
                selectedBanlist: selectedBanlist,
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
  final String selectedBanlist;

  const _DeckCardTile({
    required this.visual,
    required this.categoryKey,
    required this.isEditing,
    required this.cacheManager,
    required this.selectedBanlist,
  });

  static const _grayscaleFilter = ColorFilter.mode(Colors.grey, BlendMode.saturation);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = visual.card;
    final isOwned = visual.isOwned;
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlSmall ?? '';
    final banlistStatus = getBanlistStatus(card, selectedBanlist);

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

          // Banlist Status Badge
          Positioned(
            top: 2,
            left: 2,
            child: _BanlistBadge(status: banlistStatus),
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
  final String selectedBanlist;
  final VoidCallback onClose;

  const _DeckEditSidebar({
    required this.totalCardsInDeck,
    required this.selectedBanlist,
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
    final processedDeckAsync = ref.watch(processedDeckDataProvider);
    final deckData = processedDeckAsync.value;

    final totalDeckCardCount = widget.totalCardsInDeck.values.fold(0, (sum, count) => sum + count);

    return DefaultTabController(
      length: 2,
      child: Container(
        color: theme.colorScheme.surface,
        child: Column(
          children: [
            // Compact Header + TabBar Row
            Container(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: Colors.white38,
                      indicatorColor: theme.colorScheme.primary,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.zero,
                      tabs: [
                        const Tab(height: 36, text: 'CATALOG'),
                        Tab(height: 36, text: 'DECK ($totalDeckCardCount)'),
                      ],
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

            Expanded(
              child: TabBarView(
                children: [
                  // Tab 0: Catalog Search & Filter
                  Column(
                    children: [
                      // Single-Row Search, Filter, Sort Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Search card name...',
                                  hintStyle: const TextStyle(fontSize: 11, color: Colors.white38),
                                  prefixIcon: const Icon(Icons.search, size: 16),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 14),
                                          onPressed: () {
                                            _searchController.clear();
                                            ref.read(deckCardListProvider.notifier).search('');
                                          },
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  ref.read(deckCardListProvider.notifier).search(value);
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton.filledTonal(
                              onPressed: () => _showFilterMenu(context),
                              icon: Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: isFiltered ? theme.colorScheme.primary : null,
                              ),
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              padding: EdgeInsets.zero,
                              tooltip: 'Filter Options',
                            ),
                            const SizedBox(width: 2),
                            IconButton.filledTonal(
                              onPressed: () => _showSortMenu(context),
                              icon: const Icon(Icons.filter_list_rounded, size: 16),
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              padding: EdgeInsets.zero,
                              tooltip: 'Sort Options',
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white10),
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
                                  selectedBanlist: widget.selectedBanlist,
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

                  // Tab 1: Current Deck Cards List (Main, Extra, Side)
                  _DeckCurrentCardsTab(
                    deckData: deckData,
                    selectedBanlist: widget.selectedBanlist,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeckCurrentCardsTab extends ConsumerWidget {
  final VisualDeckData? deckData;
  final String selectedBanlist;

  const _DeckCurrentCardsTab({
    required this.deckData,
    required this.selectedBanlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (deckData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final mainCards = deckData!.main;
    final extraCards = deckData!.extra;
    final sideCards = deckData!.side;

    if (mainCards.isEmpty && extraCards.isEmpty && sideCards.isEmpty) {
      return const Center(
        child: Text(
          'Deck is empty',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
      );
    }

    Widget buildSection(String title, List<DeckVisualCard> visualCards, String categoryKey) {
      if (visualCards.isEmpty) return const SizedBox.shrink();

      // Group cards by ID to show quantity
      final grouped = <int, Map<String, dynamic>>{};
      for (final visual in visualCards) {
        final existing = grouped[visual.card.id];
        if (existing == null) {
          grouped[visual.card.id] = {'card': visual.card, 'count': 1};
        } else {
          grouped[visual.card.id]!['count'] = (existing['count'] as int) + 1;
        }
      }

      final items = grouped.values.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '$title (${visualCards.length})',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ...items.map((item) {
            final card = item['card'] as YgoCard;
            final count = item['count'] as int;

            return _DeckCardQuantityTile(
              card: card,
              count: count,
              categoryKey: categoryKey,
              selectedBanlist: selectedBanlist,
            );
          }),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        buildSection('MAIN DECK', mainCards, 'main'),
        buildSection('EXTRA DECK', extraCards, 'extra'),
        buildSection('SIDE DECK', sideCards, 'side'),
      ],
    );
  }
}

class _DeckCardQuantityTile extends ConsumerWidget {
  final YgoCard card;
  final int count;
  final String categoryKey;
  final String selectedBanlist;

  const _DeckCardQuantityTile({
    required this.card,
    required this.count,
    required this.categoryKey,
    required this.selectedBanlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlSmall ?? '';
    final banlistStatus = getBanlistStatus(card, selectedBanlist);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.push('/card/${card.id}'),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 36,
                    height: 52,
                    child: imageUrl.isEmpty
                        ? Container(color: Colors.black26)
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            cacheManager: cacheManager,
                            memCacheWidth: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 1,
                  child: _BanlistBadge(status: banlistStatus),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/card/${card.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${card.type}',
                    style: const TextStyle(fontSize: 10, color: Colors.white54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!ref.watch(deckFileContentProvider).isQuoteDeck) ...[
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.redAccent),
                  tooltip: 'Remove 1 copy',
                  onPressed: () {
                    ref
                        .read(deckFileContentProvider.notifier)
                        .removeOneCopyFromCategory(card.id, categoryKey);
                  },
                ),
                Text(
                  'x$count',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.add_circle_outline, size: 20, color: theme.colorScheme.primary),
                  tooltip: 'Add 1 copy',
                  onPressed: () {
                    ref
                        .read(deckFileContentProvider.notifier)
                        .addCardToCategory(card.id, categoryKey);
                  },
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'x$count',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarCardTile extends ConsumerWidget {
  final YgoCard card;
  final int totalInDeck;
  final String selectedBanlist;

  const _SidebarCardTile({
    required this.card,
    required this.totalInDeck,
    required this.selectedBanlist,
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
    final banlistStatus = getBanlistStatus(card, selectedBanlist);

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
                  // Small Card Image with Banlist Badge
                  Stack(
                    children: [
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
                      Positioned(
                        top: 1,
                        left: 1,
                        child: _BanlistBadge(status: banlistStatus),
                      ),
                    ],
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
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              if (totalInDeck > 0)
                _QuickAddButton(
                  label: '- REMOVE',
                  color: Colors.redAccent,
                  onPressed: () {
                    ref.read(deckFileContentProvider.notifier).removeOneCopyFromAnyCategory(card.id);
                  },
                )
              else
                const SizedBox.shrink(),
              Row(
                mainAxisSize: MainAxisSize.min,
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

class _DeckTotalPriceSummary extends ConsumerWidget {
  final VisualDeckData deckData;

  const _DeckTotalPriceSummary({required this.deckData});

  double _getCardPriceInUsd(
    YgoCard card,
    Map<String, double> liveSetPricesMap,
    Map<int, double> globalPricesMap,
  ) {
    final tcgPrice = card.cardPrices?.firstOrNull?.tcgPlayerPrice ??
        card.cardPrices?.firstOrNull?.cardMarketPrice;
    if (tcgPrice != null && tcgPrice > 0.0) return tcgPrice;

    final setP = card.cardSets?.firstOrNull?.setPrice;
    if (setP != null && setP > 0.0) return setP;

    return 0.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyInfo = ref.watch(activeCurrencyInfoProvider);
    final db = ref.watch(databaseProvider);

    final allCardIds = [
      ...deckData.main.map((vc) => vc.card.id),
      ...deckData.extra.map((vc) => vc.card.id),
      ...deckData.side.map((vc) => vc.card.id),
    ].toSet().toList();

    return StreamBuilder<List<CollectionItemWithCard>>(
      stream: db.watchCollection(),
      builder: (context, collectionSnapshot) {
        final collectionList = collectionSnapshot.data ?? [];

        final collectionByCardId = <int, List<DriftCollectionItem>>{};
        for (final row in collectionList) {
          final item = row.collectionItem;
          collectionByCardId.putIfAbsent(item.cardId, () => []).add(item);
        }

        return StreamBuilder<List<DriftSetCardPrice>>(
          stream: db.watchPricesForCardIds(allCardIds),
          builder: (context, pricesSnapshot) {
            final livePricesList = pricesSnapshot.data ?? [];

            final livePricesBySetCode = <String, double>{};
            final maxLivePriceByCardId = <int, double>{};

            for (final sp in livePricesList) {
              final p = sp.marketPrice ?? sp.lowPrice ?? 0.0;
              if (sp.setCode != null && sp.setCode!.isNotEmpty) {
                livePricesBySetCode['${sp.cardId}_${sp.setCode!.toUpperCase()}'] = p;
              }
              final currMax = maxLivePriceByCardId[sp.cardId] ?? 0.0;
              if (p > currMax) {
                maxLivePriceByCardId[sp.cardId] = p;
              }
            }

            double ownedTotalUsd = 0.0;
            double unownedTotalUsd = 0.0;
            double mainTotalUsd = 0.0;
            double extraTotalUsd = 0.0;
            double sideTotalUsd = 0.0;
            int missingCardsCount = 0;

            final usedOwnedCountByCardId = <int, int>{};

            void processCategory(
              List<DeckVisualCard> visualCards,
              void Function(double price) addToCategory,
            ) {
              for (final vc in visualCards) {
                final card = vc.card;
                final ownedItems = collectionByCardId[card.id] ?? [];
                final usedCount = usedOwnedCountByCardId[card.id] ?? 0;
                final totalOwnedQty = ownedItems.fold(0, (sum, i) => sum + i.quantity);

                double price = 0.0;

                if (usedCount < totalOwnedQty) {
                  // Card copy IS OWNED in collection!
                  usedOwnedCountByCardId[card.id] = usedCount + 1;

                  if (ownedItems.isNotEmpty) {
                    final item = ownedItems.first;
                    final baseCode = item.setCode.trim().toUpperCase();
                    final itemRarity = item.rarity.trim().toLowerCase();

                    // Match exact setCode AND rarity in livePricesList
                    final matchingSetPrices = livePricesList.where((sp) {
                      final codeMatch = sp.cardId == card.id &&
                          sp.setCode != null &&
                          sp.setCode!.trim().toUpperCase() == baseCode;
                      final normPrinting = sp.printing.trim().toLowerCase();
                      final rarityMatch = normPrinting.contains(itemRarity) || itemRarity.contains(normPrinting);
                      return codeMatch && rarityMatch;
                    }).toList();

                    if (matchingSetPrices.isNotEmpty) {
                      price = matchingSetPrices.first.marketPrice ?? matchingSetPrices.first.lowPrice ?? 0.0;
                    } else {
                      // Fallback by setCode
                      final codeMatches = livePricesList.where((sp) =>
                          sp.cardId == card.id &&
                          sp.setCode != null &&
                          sp.setCode!.trim().toUpperCase() == baseCode).toList();
                      if (codeMatches.isNotEmpty) {
                        price = codeMatches.first.marketPrice ?? codeMatches.first.lowPrice ?? 0.0;
                      } else if (item.priceAtPurchase != null && item.priceAtPurchase! > 0.0) {
                        price = item.priceAtPurchase!;
                      }
                    }
                  }

                  if (price <= 0.0) {
                    price = _getCardPriceInUsd(card, livePricesBySetCode, maxLivePriceByCardId);
                  }

                  ownedTotalUsd += price;
                } else {
                  // Card copy IS MISSING / NOT IN INVENTORY!
                  price = maxLivePriceByCardId[card.id] ??
                      _getCardPriceInUsd(card, livePricesBySetCode, maxLivePriceByCardId);

                  unownedTotalUsd += price;
                  missingCardsCount++;
                }

                addToCategory(price);
              }
            }

            processCategory(deckData.main, (p) => mainTotalUsd += p);
            processCategory(deckData.extra, (p) => extraTotalUsd += p);
            processCategory(deckData.side, (p) => sideTotalUsd += p);

            final overallTotalUsd = ownedTotalUsd + unownedTotalUsd;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'DECK TOTAL VALUE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          currencyInfo.formatPrice(overallTotalUsd),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 12),

                  // Owned vs Missing Cards Summary
                  _buildSummaryRow(
                    'Cards Owned Value',
                    currencyInfo.formatPrice(ownedTotalUsd),
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    'Missing Cards Cost ($missingCardsCount missing)',
                    currencyInfo.formatPrice(unownedTotalUsd),
                    color: missingCardsCount > 0 ? Colors.orangeAccent : Colors.white70,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 12),

                  // Section breakdown
                  _buildSummaryRow(
                    'Main Deck (${deckData.main.length} cards)',
                    currencyInfo.formatPrice(mainTotalUsd),
                  ),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    'Extra Deck (${deckData.extra.length} cards)',
                    currencyInfo.formatPrice(extraTotalUsd),
                  ),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    'Side Deck (${deckData.side.length} cards)',
                    currencyInfo.formatPrice(sideTotalUsd),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color color = Colors.white70}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
