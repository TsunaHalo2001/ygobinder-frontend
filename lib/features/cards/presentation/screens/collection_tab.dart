import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_list_provider.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';
import 'package:ygobinder/features/cards/presentation/widgets/card_filter_dialogs.dart';

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
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      _searchController.clear();
      ref.read(cardListProvider.notifier).resetSearchAndFilters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
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
      builder: (context) => const CardFilterBottomSheet(),
    );
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const CardSortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                    onPressed: () => _showSortMenu(context),
                    icon: const Icon(Icons.filter_list_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _showFilterMenu(context),
                    icon: const Icon(Icons.tune_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: ref.watch(cardListProvider.notifier).isFiltered
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
                      foregroundColor: ref.watch(cardListProvider.notifier).isFiltered
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      context.push('/scanner');
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
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
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SpinningCardLoader(width: 30, height: 42),
                          ),
                        );
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

  List<Color> _getCardColors() {
    final frame = card.frameType?.toLowerCase() ?? '';
    final isPendulum = frame.contains('pendulum');
    
    Color baseColor;
    if (frame.contains('trap')) {
      baseColor = const Color(0xFFBC5A84);
    } else if (frame.contains('spell')) {
      baseColor = const Color(0xFF1D9B7F);
    } else if (frame.contains('normal')) {
      baseColor = const Color(0xFFFDE68A);
    } else if (frame.contains('ritual')) {
      baseColor = const Color(0xFF9DB5F2);
    } else if (frame.contains('fusion')) {
      baseColor = const Color(0xFFA086B7);
    } else if (frame.contains('synchro')) {
      baseColor = const Color(0xFFCCCCCC);
    } else if (frame.contains('xyz')) {
      baseColor = const Color(0xFF000000);
    } else if (frame.contains('link')) {
      baseColor = const Color(0xFF00008B);
    } else if (frame.contains('token')) {
      baseColor = const Color(0xFFC0C0C0);
    } else {
      baseColor = const Color(0xFFFF8B53); 
    }

    if (isPendulum) {
      return [const Color(0xFF1D9B7F), baseColor];
    }
    return [baseColor];
  }

  Widget _buildBanlistIndicators(BuildContext context) {
    final info = card.banlistInfo;
    if (info == null) return const SizedBox.shrink();
    final List<Widget> items = [];
    void addIcon(String? status, String label) {
      if (status == null) return;
      final String s = status.toLowerCase();
      if (s == 'banned' || s == 'prohibited' || s == 'forbidden' || s == 'limited' || s == 'semi-limited' || s == 'semilimited' || s == '0' || s == '1' || s == '2') {
        IconData iconData = Icons.block;
        Color iconColor = Colors.redAccent;
        if (s == 'limited' || s == '1') { iconData = Icons.looks_one_outlined; iconColor = Colors.orangeAccent; }
        else if (s.contains('semi') || s == '2') { iconData = Icons.looks_two_outlined; iconColor = Colors.yellowAccent; }
        items.add(Stack(alignment: Alignment.center, children: [
          Icon(iconData, color: iconColor, size: 32),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [const Shadow(blurRadius: 4.0, color: Colors.black)],
              )),
        ]));
      }
    }
    addIcon(info.banTcg, 'TCG'); addIcon(info.banOcg, 'OCG'); addIcon(info.banGoat, 'GOAT');
    if (info.banEdison != null) addIcon(info.banEdison, 'EDI');
    
    if (items.isEmpty) {
      if (info.banEdison != null) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
          child: const Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
        );
      }
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 120),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = card.cardImages?.firstOrNull?.imageUrlCropped ?? '';
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final colors = _getCardColors();
    final isHybrid = colors.length > 1;
    final textColor = colors.last.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      color: isHybrid ? Colors.transparent : colors.first,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.white10, width: 0.5)),
      child: InkWell(
        onTap: () => context.push('/card/${card.id}'),
        child: Container(
          decoration: isHybrid ? BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors, stops: const [0.4, 0.9])) : null,
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
                          placeholder: (context, url) => Container(color: Colors.black12, child: Center(child: Image.asset('assets/images/icon/logo.png', width: 32, height: 32, opacity: const AlwaysStoppedAnimation(0.2)))),
                          errorWidget: (context, url, error) => Container(color: Colors.black12, child: const Icon(Icons.broken_image, color: Colors.redAccent, size: 20)),
                        ),
                      ),
                    ),
                    Positioned(bottom: 4, right: 4, child: _buildBanlistIndicators(context)),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
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
