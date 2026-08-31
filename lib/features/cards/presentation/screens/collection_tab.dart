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
    _scrollController.addListener(_onScroll);
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
                          ? Theme.of(context).colorScheme.primary
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
      if (s == 'banned' || s == 'prohibited' || s == 'forbidden' || s == 'limited' || s == 'semi-limited' || s == 'semilimited') {
        IconData iconData = Icons.block;
        Color iconColor = Colors.redAccent;
        if (s == 'limited') {
          iconData = Icons.looks_one_outlined;
          iconColor = Colors.orangeAccent;
        } else if (s.contains('semi')) {
          iconData = Icons.looks_two_outlined;
          iconColor = Colors.yellowAccent;
        }
        items.add(Stack(alignment: Alignment.center, children: [
          Icon(iconData, color: iconColor, size: 48),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [const Shadow(blurRadius: 4.0, color: Colors.black)],
              )),
        ]));
      }
    }

    addIcon(info.banTcg, 'TCG');
    addIcon(info.banOcg, 'OCG');
    addIcon(info.banGoat, 'GOAT');
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: items),
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
          decoration: isHybrid
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors,
                    stops: const [0.4, 0.9],
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

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet({super.key});
  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _tempAttribute;
  String? _tempRace;
  String? _tempSubType;
  String? _tempFrame;
  int? _tempLevel;
  int? _tempScale;
  int? _tempLinkVal;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(cardListProvider.notifier);
    _tempAttribute = notifier.currentAttributeFilter;
    _tempRace = notifier.currentRaceFilter;
    _tempSubType = notifier.currentSubTypeFilter;
    _tempFrame = notifier.currentFrameFilter;
    _tempLevel = notifier.currentLevelFilter;
    _tempScale = notifier.currentScaleFilter;
    _tempLinkVal = notifier.currentLinkValFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.white38,
              indicatorColor: theme.colorScheme.primary,
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: 'MONSTER'), Tab(text: 'MAGIC'), Tab(text: 'TRAP')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _FilterTabContent(
                    type: 'Monster',
                    selectedAttribute: _tempAttribute,
                    selectedRace: _tempRace,
                    selectedSubType: _tempSubType,
                    selectedFrame: _tempFrame,
                    selectedLevel: _tempLevel,
                    selectedScale: _tempScale,
                    selectedLinkVal: _tempLinkVal,
                    onAttributeSelected: (attr) => setState(() => _tempAttribute = attr),
                    onRaceSelected: (race) => setState(() => _tempRace = race),
                    onSubTypeSelected: (subType) => setState(() => _tempSubType = subType),
                    onFrameSelected: (frame) => setState(() => _tempFrame = frame),
                    onLevelChanged: (level) => setState(() => _tempLevel = level),
                    onScaleChanged: (scale) => setState(() => _tempScale = scale),
                    onLinkValChanged: (linkVal) => setState(() => _tempLinkVal = linkVal),
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
  final String? selectedRace;
  final String? selectedSubType;
  final String? selectedFrame;
  final int? selectedLevel;
  final int? selectedScale;
  final int? selectedLinkVal;
  final ValueChanged<String?>? onAttributeSelected;
  final ValueChanged<String?>? onRaceSelected;
  final ValueChanged<String?>? onSubTypeSelected;
  final ValueChanged<String?>? onFrameSelected;
  final ValueChanged<int?>? onLevelChanged;
  final ValueChanged<int?>? onScaleChanged;
  final ValueChanged<int?>? onLinkValChanged;

  const _FilterTabContent({
    required this.type,
    this.selectedAttribute,
    this.selectedRace,
    this.selectedSubType,
    this.selectedFrame,
    this.selectedLevel,
    this.selectedScale,
    this.selectedLinkVal,
    this.onAttributeSelected,
    this.onRaceSelected,
    this.onSubTypeSelected,
    this.onFrameSelected,
    this.onLevelChanged,
    this.onScaleChanged,
    this.onLinkValChanged,
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
    final races = [
      {'name': 'Aqua', 'asset': 'assets/images/races/aqua.png'},
      {'name': 'Beast', 'asset': 'assets/images/races/beast.png'},
      {'name': 'Beast-Warrior', 'asset': 'assets/images/races/beast_warrior.png'},
      {'name': 'Cyberse', 'asset': 'assets/images/races/cyberse.png'},
      {'name': 'Dinosaur', 'asset': 'assets/images/races/dinosaur.png'},
      {'name': 'Divine-Beast', 'asset': 'assets/images/races/divine_beast.png'},
      {'name': 'Dragon', 'asset': 'assets/images/races/dragon.png'},
      {'name': 'Fairy', 'asset': 'assets/images/races/fairy.png'},
      {'name': 'Fiend', 'asset': 'assets/images/races/demon.png'},
      {'name': 'Fish', 'asset': 'assets/images/races/fish.png'},
      {'name': 'Illusion', 'asset': 'assets/images/races/illusion.png'},
      {'name': 'Insect', 'asset': 'assets/images/races/insect.png'},
      {'name': 'Machine', 'asset': 'assets/images/races/machine.png'},
      {'name': 'Plant', 'asset': 'assets/images/races/plant.png'},
      {'name': 'Psychic', 'asset': 'assets/images/races/psychic.png'},
      {'name': 'Pyro', 'asset': 'assets/images/races/pyro.png'},
      {'name': 'Reptile', 'asset': 'assets/images/races/reptile.png'},
      {'name': 'Rock', 'asset': 'assets/images/races/rock.png'},
      {'name': 'Sea Serpent', 'asset': 'assets/images/races/sea_serpent.png'},
      {'name': 'Spellcaster', 'asset': 'assets/images/races/spellcaster.png'},
      {'name': 'Thunder', 'asset': 'assets/images/races/thunder.png'},
      {'name': 'Warrior', 'asset': 'assets/images/races/warrior.png'},
      {'name': 'Winged Beast', 'asset': 'assets/images/races/winged_beast.png'},
      {'name': 'Wyrm', 'asset': 'assets/images/races/wyrm.png'},
      {'name': 'Zombie', 'asset': 'assets/images/races/zombie.png'},
    ];
    final frames = [
      {'name': 'normal', 'label': 'NORMAL', 'color': const Color(0xFFFDE68A)},
      {'name': 'effect', 'label': 'EFFECT', 'color': const Color(0xFFFF8B53)},
      {'name': 'ritual', 'label': 'RITUAL', 'color': const Color(0xFF9DB5F2)},
      {'name': 'fusion', 'label': 'FUSION', 'color': const Color(0xFFA086B7)},
      {'name': 'synchro', 'label': 'SYNCHRO', 'color': const Color(0xFFCCCCCC)},
      {'name': 'xyz', 'label': 'XYZ', 'color': const Color(0xFF000000)},
      {'name': 'link', 'label': 'LINK', 'color': const Color(0xFF00008B)},
      {'name': 'pendulum', 'label': 'PENDULUM', 'color': const Color(0xFF45A29E)},
      {'name': 'token', 'label': 'TOKEN', 'color': const Color(0xFFC0C0C0)},
    ];
    final subTypes = ['Flip', 'Toon', 'Spirit', 'Union', 'Gemini', 'Tuner'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMonster) ...[
            _buildNumericSelector('PENDULUM SCALE:', selectedScale, (val) => onScaleChanged?.call(val), theme, Colors.tealAccent, 0, 13),
            const SizedBox(height: 32),
            _buildNumericSelector('LEVEL / RANK:', selectedLevel, (val) => onLevelChanged?.call(val), theme, theme.colorScheme.primary, 0, 13),
            const SizedBox(height: 32),
            _buildNumericSelector('LINK VALUE:', selectedLinkVal, (val) => onLinkValChanged?.call(val), theme, Colors.blueAccent, 1, 6),
            const SizedBox(height: 32),
            const Text('SELECT CARD TYPE:', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: frames.map((f) {
                final isSelected = selectedFrame == f['name'];
                final Color frameColor = f['color'] as Color;
                final bool isVeryDark = frameColor.computeLuminance() < 0.1;
                final bool isDark = frameColor.computeLuminance() < 0.5;
                return ChoiceChip(
                  label: Text(f['label'] as String),
                  selected: isSelected,
                  onSelected: (selected) => onFrameSelected?.call(selected ? f['name'] as String : null),
                  selectedColor: frameColor,
                  backgroundColor: isVeryDark ? Colors.white10 : frameColor.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? (isDark ? Colors.white : Colors.black87) : (isVeryDark ? Colors.white60 : frameColor.withValues(alpha: 0.8)),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: isSelected ? Colors.white : (isVeryDark ? Colors.white24 : frameColor.withValues(alpha: 0.4)), width: 1),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('SELECT ATTRIBUTE:', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: attributes.map((attr) {
                final isSelected = selectedAttribute == attr['name'];
                return InkWell(
                  onTap: () => onAttributeSelected?.call(isSelected ? null : attr['name']!),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(attr['asset']!, width: 32, height: 32),
                        const SizedBox(height: 4),
                        Text(attr['name']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? theme.colorScheme.primary : Colors.white38)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('SELECT MONSTER RACE:', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: races.map((race) {
                final isSelected = selectedRace == race['name'];
                return InkWell(
                  onTap: () => onRaceSelected?.call(isSelected ? null : race['name']!),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(race['asset']!, width: 32, height: 32),
                        const SizedBox(height: 4),
                        Text(race['name']!.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? theme.colorScheme.primary : Colors.white38)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('SELECT ABILITY / CATEGORY:', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: subTypes.map((st) {
                final isSelected = selectedSubType == st;
                return ChoiceChip(
                  label: Text(st.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) => onSubTypeSelected?.call(selected ? st : null),
                  selectedColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  labelStyle: TextStyle(color: isSelected ? theme.colorScheme.primary : Colors.white38, fontWeight: FontWeight.bold, fontSize: 12),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
          const Text('Filter by this type?', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(cardListProvider.notifier).applyFilters(
                    type: type,
                    attribute: isMonster ? selectedAttribute : null,
                    race: isMonster ? selectedRace : null,
                    subType: isMonster ? selectedSubType : null,
                    frame: isMonster ? selectedFrame : null,
                    level: isMonster ? selectedLevel : null,
                    scale: isMonster ? selectedScale : null,
                    linkVal: isMonster ? selectedLinkVal : null,
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

  Widget _buildNumericSelector(String label, int? value, ValueChanged<int?> onChanged, ThemeData theme, Color accentColor, int min, int max) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                final current = value ?? min;
                if (current > min) onChanged(current - 1);
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: accentColor),
                borderRadius: BorderRadius.circular(8),
                color: value != null ? accentColor.withValues(alpha: 0.1) : null,
              ),
              child: Text(
                value?.toString() ?? 'ANY',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: value != null ? accentColor : Colors.white24,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                final current = value ?? min;
                if (current < max) onChanged(current + 1);
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
            if (value != null)
              IconButton(
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.clear, size: 20),
              ),
          ],
        ),
      ],
    );
  }
}
