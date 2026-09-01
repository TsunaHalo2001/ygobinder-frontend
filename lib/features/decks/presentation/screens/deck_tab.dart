import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/decks/presentation/providers/deck_file_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

class DeckVisualCard {
  final YgoCard card;
  final bool isOwned;

  DeckVisualCard({required this.card, required this.isOwned});
}

class DeckTab extends ConsumerStatefulWidget {
  const DeckTab({super.key});

  @override
  ConsumerState<DeckTab> createState() => _DeckTabState();
}

class _DeckTabState extends ConsumerState<DeckTab> {
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any, // ✅ Changed to 'any' for better compatibility on Linux
        // allowedExtensions: ['ydk'], // Removed temporarily to test visibility
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
    final nameController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final deckState = ref.watch(deckFileContentProvider);
    final savedDecksAsync = ref.watch(savedDecksProvider);
    final categorizedCardsAsync = ref.watch(categorizedDeckCardsProvider);
    final inventoryIdsAsync = ref.watch(userInventoryIdsProvider);
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DECK BUILDER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          if (deckState.content.isNotEmpty) ...[
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
            icon: const Icon(Icons.file_upload_rounded), // ✅ More standard icon
            tooltip: 'Load Deck',
          ),
        ],
      ),
      body: deckState.content.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                        onPressed: () => _deleteDeck(deck.id, deck.name),
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
                        minimumSize: const Size(double.infinity, 56), // Make it full width to match dropdown
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : categorizedCardsAsync.when(
              data: (categorized) => Column(
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
                          onPressed: () => ref.read(deckFileContentProvider.notifier).reset(),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final inventory = inventoryIdsAsync.value ?? {};
                        final usageTracker = <int, int>{};

                        List<DeckVisualCard> prepareVisualCards(List<YgoCard> source) {
                          return source.map((card) {
                            final totalOwned = inventory[card.id] ?? 0;
                            final usedSoFar = usageTracker[card.id] ?? 0;
                            final isOwned = usedSoFar < totalOwned;
                            usageTracker[card.id] = usedSoFar + 1;
                            return DeckVisualCard(card: card, isOwned: isOwned);
                          }).toList();
                        }

                        final mainVisual = prepareVisualCards(categorized['main']!);
                        final extraVisual = prepareVisualCards(categorized['extra']!);
                        final sideVisual = prepareVisualCards(categorized['side']!);

                        return ListView(
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            _buildCategorySection('MAIN DECK', mainVisual, theme, cacheManager),
                            const SizedBox(height: 24),
                            _buildCategorySection('EXTRA DECK', extraVisual, theme, cacheManager),
                            const SizedBox(height: 24),
                            _buildCategorySection('SIDE DECK', sideVisual, theme, cacheManager),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<DeckVisualCard> visualCards,
    ThemeData theme,
    CacheManager cacheManager,
  ) {
    if (visualCards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 80,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: visualCards.length,
          itemBuilder: (context, index) {
            final visual = visualCards[index];
            final card = visual.card;
            final isOwned = visual.isOwned;
            final imageUrl = card.cardImages?.firstOrNull?.imageUrlSmall ?? '';

            return InkWell(
              onTap: () => context.push('/card/${card.id}'),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isOwned ? Colors.white10 : Colors.redAccent.withValues(alpha: 0.3)),
                ),
                clipBehavior: Clip.antiAlias,
                child: ColorFiltered(
                  colorFilter: isOwned
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: imageUrl.isEmpty
                      ? Container(
                          color: Colors.white.withValues(alpha: 0.05),
                          child: Center(
                            child: Image.asset(
                              'assets/images/icon/logo.png',
                              width: 24,
                              height: 24,
                              opacity: const AlwaysStoppedAnimation(0.2),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          cacheManager: cacheManager,
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
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
