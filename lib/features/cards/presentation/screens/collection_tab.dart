import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_list_provider.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

class CollectionTab extends ConsumerStatefulWidget {
  const CollectionTab({super.key});

  @override
  ConsumerState<CollectionTab> createState() => _CollectionTabState();
}

class _CollectionTabState extends ConsumerState<CollectionTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to scroll events to trigger loadMore
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // If we are near the bottom (within 200px), load more cards
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(cardListProvider.notifier).loadMore();
    }
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar + Camera Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search cards...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(cardListProvider.notifier).search('');
                                },
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref.read(cardListProvider.notifier).search(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _showFilterMenu(context),
                    icon: const Icon(Icons.filter_list_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: ref.watch(cardListProvider.notifier).isFiltered
                          ? Theme.of(context).colorScheme.primary // ✅ Changed color when filtered
                          : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
                      foregroundColor: ref.watch(cardListProvider.notifier).isFiltered
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      context.push('/scanner');
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // The Grid
            Expanded(
              child: cardsAsync.when(
                loading: () => const Center(child: SpinningCardLoader(width: 40, height: 56)),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (state) {
                  final cards = state.cards;
                  if (cards.isEmpty) {
                    return const Center(child: Text('No cards found.'));
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240.0,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.hasMore ? cards.length + 1 : cards.length,
                    itemBuilder: (context, index) {
                      if (index == cards.length) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SpinningCardLoader(width: 30, height: 42),
                        ));
                      }

                      return CardGridItem(card: cards[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardGridItem extends ConsumerWidget {
  final YgoCard card;
  const CardGridItem({super.key, required this.card});

  Color _getCardColor() {
    final frame = card.frameType?.toLowerCase() ?? '';
    if (frame.contains('trap')) return const Color(0xFFBC5A84);
    if (frame.contains('spell')) return const Color(0xFF1D9B7F);
    if (frame.contains('normal')) return const Color(0xFFFDE68A);
    if (frame.contains('effect')) return const Color(0xFFFF8B53);
    if (frame.contains('ritual')) return const Color(0xFF9DB5F2);
    if (frame.contains('fusion')) return const Color(0xFFA086B7);
    if (frame.contains('synchro')) return const Color(0xFFCCCCCC);
    if (frame.contains('xyz')) return const Color(0xFF000000);
    if (frame.contains('link')) return const Color(0xFF00008B);
    if (frame.contains('token')) return const Color(0xFFC0C0C0);
    if (frame.contains('pendulum')) return const Color(0xFF45A29E); // Teal/Gold mix
    return const Color(0xFF1F2833); // Default Slate
  }

  Widget _buildBanlistIndicators(BuildContext context) {
    final info = card.banlistInfo;
    if (info == null) return const SizedBox.shrink();

    final List<Widget> items = [];

    void addIcon(String? status, String label) {
      if (status == null) return;
      final String s = status.toLowerCase();
      final bool isBanned = s == 'banned' || s == 'prohibited' || s == 'forbidden';
      final bool isLimited = s == 'limited';
      final bool isSemiLimited = s == 'semi-limited' || s == 'semilimited';

      if (isBanned || isLimited || isSemiLimited) {
        IconData iconData = Icons.block;
        Color iconColor = Colors.redAccent;

        if (isLimited) {
          iconData = Icons.looks_one_outlined;
          iconColor = Colors.orangeAccent;
        } else if (isSemiLimited) {
          iconData = Icons.looks_two_outlined;
          iconColor = Colors.yellowAccent;
        }

        final nameStyle = Theme.of(context).textTheme.bodySmall;

        items.add(
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(iconData, color: iconColor, size: 48), // Large enough to act as a frame
              Text(
                label,
                style: nameStyle?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(blurRadius: 4.0, color: Colors.black),
                    const Shadow(blurRadius: 2.0, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    addIcon(info.banTcg, 'TCG');
    addIcon(info.banOcg, 'OCG');
    addIcon(info.banGoat, 'GOAT');

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlCropped ?? '';
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final cardColor = _getCardColor();

    final isPendulum = card.frameType?.toLowerCase().contains('pendulum') ?? false;

    // Calculate if the background is light or dark to pick the right text color
    final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      // If Pendulum, the Card background will be transparent because we use a Gradient in the Container below
      color: isPendulum ? Colors.transparent : cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white10, width: 0.5),
      ),
      child: InkWell(
        onTap: () => context.push('/card/${card.id}'),
        child: Container(
          decoration: isPendulum
              ? const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1D9B7F), // Spell color
                      Color(0xFFFF8B53), // Monster color (Effect)
                    ],
                    stops: [0.4, 0.9], // Start transition after the image area
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'card_image_${card.id}',
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          cacheManager: cacheManager,
                          placeholder: (context, url) => Container(
                            color: Colors.black12,
                            child: Center(
                              child: Image.asset(
                                'assets/images/icon/logo.png',
                                width: 32,
                                height: 32,
                                opacity: const AlwaysStoppedAnimation(0.2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.black12,
                            child: const Icon(Icons.broken_image, color: Colors.redAccent, size: 20),
                          ),
                        ),
                      ),
                    ),
                    // ✅ Banlist Indicators in bottom right
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: _buildBanlistIndicators(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      card.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet({super.key});

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _tempAttribute;

  @override
  void initState() {
    super.initState();
    // Initialize with current filter state
    _tempAttribute = ref.read(cardListProvider.notifier).currentAttributeFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: DefaultTabController(
        length: 3,
        initialIndex: _getInitialTabIndex(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.white38,
              indicatorColor: theme.colorScheme.primary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'MONSTER'),
                Tab(text: 'MAGIC'),
                Tab(text: 'TRAP'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _FilterTabContent(
                    type: 'Monster',
                    selectedAttribute: _tempAttribute,
                    onAttributeSelected: (attr) => setState(() => _tempAttribute = attr),
                  ),
                  const _FilterTabContent(type: 'Spell'),
                  const _FilterTabContent(type: 'Trap'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getInitialTabIndex() {
    final currentType = ref.read(cardListProvider.notifier).currentTypeFilter;
    if (currentType == 'Spell') return 1;
    if (currentType == 'Trap') return 2;
    return 0;
  }
}

class _FilterTabContent extends ConsumerWidget {
  final String type;
  final String? selectedAttribute;
  final ValueChanged<String?>? onAttributeSelected;

  const _FilterTabContent({
    required this.type,
    this.selectedAttribute,
    this.onAttributeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMonster = type == 'Monster';

    final attributes = [
      {'name': 'DARK', 'asset': 'assets/images/attributes/dark.webp'},
      {'name': 'EARTH', 'asset': 'assets/images/attributes/earth.png'},
      {'name': 'FIRE', 'asset': 'assets/images/attributes/fire.webp'},
      {'name': 'LIGHT', 'asset': 'assets/images/attributes/light.png'},
      {'name': 'WATER', 'asset': 'assets/images/attributes/water.png'},
      {'name': 'WIND', 'asset': 'assets/images/attributes/wind.webp'},
      {'name': 'DIVINE', 'asset': 'assets/images/attributes/divine.webp'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMonster) ...[
            const Text(
              'SELECT ATTRIBUTE:',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: attributes.map((attr) {
                final isSelected = selectedAttribute == attr['name'];
                return InkWell(
                  onTap: () {
                    onAttributeSelected?.call(isSelected ? null : attr['name']!);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(attr['asset']!, width: 32, height: 32),
                        const SizedBox(height: 4),
                        Text(
                          attr['name']!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? theme.colorScheme.primary : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          const Text(
            'Filter by this type?',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(cardListProvider.notifier).applyFilters(
                type: type,
                attribute: isMonster ? selectedAttribute : null,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('FILTER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              ref.read(cardListProvider.notifier).clearFilters();
              Navigator.pop(context);
            },
            child: const Text('CLEAR ALL FILTERS', style: TextStyle(color: Colors.white38)),
          ),
        ],
      ),
    );
  }
}
