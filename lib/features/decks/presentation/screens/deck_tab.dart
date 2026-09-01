import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/decks/presentation/providers/deck_file_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

class DeckTab extends ConsumerStatefulWidget {
  const DeckTab({super.key});

  @override
  ConsumerState<DeckTab> createState() => _DeckTabState();
}

class _DeckTabState extends ConsumerState<DeckTab> {
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // ✅ Changed to 'any' for better compatibility on Linux
        // allowedExtensions: ['ydk'], // Removed temporarily to test visibility
      );

      if (result != null && result.files.single.path != null) {
        await ref.read(deckFileContentProvider.notifier).loadFromPath(result.files.single.path!);
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

  @override
  Widget build(BuildContext context) {
    final deckContent = ref.watch(deckFileContentProvider);
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
          if (deckContent.isNotEmpty)
            IconButton(
              onPressed: _saveDeck,
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save Deck',
            ),
          IconButton(
            onPressed: _pickFile,
            icon: const Icon(Icons.file_upload_rounded), // ✅ More standard icon
            tooltip: 'Load Deck',
          ),
        ],
      ),
      body: deckContent.isEmpty
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
                            DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'LOAD SAVED DECK',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.folder_special_rounded),
                              ),
                              items: decks.map((deck) {
                                return DropdownMenuItem<int>(
                                  value: deck.id,
                                  child: Text(deck.name),
                                );
                              }).toList(),
                              onChanged: (deckId) {
                                if (deckId != null) {
                                  ref.read(deckFileContentProvider.notifier).loadFromDatabase(deckId);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
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
                        const Text('DECK VISUALIZER',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 1.5)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => ref.read(deckFileContentProvider.notifier).reset(),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildCategorySection('MAIN DECK', categorized['main']!, theme, cacheManager, inventoryIdsAsync.value ?? {}),
                        const SizedBox(height: 24),
                        _buildCategorySection('EXTRA DECK', categorized['extra']!, theme, cacheManager, inventoryIdsAsync.value ?? {}),
                        const SizedBox(height: 24),
                        _buildCategorySection('SIDE DECK', categorized['side']!, theme, cacheManager, inventoryIdsAsync.value ?? {}),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }

  Widget _buildCategorySection(String title, List<YgoCard> cards, ThemeData theme, CacheManager cacheManager, Set<int> ownedIds) {
    if (cards.isEmpty) return const SizedBox.shrink();

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
              '(${cards.length})',
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
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            final imageUrl = card.cardImages?.first.imageUrlSmall ?? '';
            final isOwned = ownedIds.contains(card.id);

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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    cacheManager: cacheManager,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error_outline, size: 20)),
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
