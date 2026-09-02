import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_list_provider.dart';

const List<Map<String, String>> _kAttributes = [
  {'name': 'DARK', 'asset': 'assets/images/attributes/dark.webp'},
  {'name': 'EARTH', 'asset': 'assets/images/attributes/earth.png'},
  {'name': 'FIRE', 'asset': 'assets/images/attributes/fire.webp'},
  {'name': 'LIGHT', 'asset': 'assets/images/attributes/light.png'},
  {'name': 'WATER', 'asset': 'assets/images/attributes/water.png'},
  {'name': 'WIND', 'asset': 'assets/images/attributes/wind.webp'},
  {'name': 'DIVINE', 'asset': 'assets/images/attributes/divine.webp'},
];

const List<Map<String, String>> _kMonsterRaces = [
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

const List<Map<String, String?>> _kSpellRaces = [
  {'name': 'Normal', 'asset': null},
  {'name': 'Continuous', 'asset': 'assets/images/attributes/continuous.png'},
  {'name': 'Equip', 'asset': 'assets/images/attributes/equip.webp'},
  {'name': 'Field', 'asset': 'assets/images/attributes/field.png'},
  {'name': 'Quick-Play', 'asset': 'assets/images/attributes/quickplay.webp'},
  {'name': 'Ritual', 'asset': 'assets/images/attributes/ritual.webp'},
];

const List<Map<String, String?>> _kTrapRaces = [
  {'name': 'Normal', 'asset': null},
  {'name': 'Continuous', 'asset': 'assets/images/attributes/continuous.png'},
  {'name': 'Counter', 'asset': 'assets/images/attributes/counter.webp'},
];

const List<Map<String, dynamic>> _kFrames = [
  {'name': 'normal', 'label': 'NORMAL', 'color': Color(0xFFFDE68A)},
  {'name': 'effect', 'label': 'EFFECT', 'color': Color(0xFFFF8B53)},
  {'name': 'ritual', 'label': 'RITUAL', 'color': Color(0xFF9DB5F2)},
  {'name': 'fusion', 'label': 'FUSION', 'color': Color(0xFFA086B7)},
  {'name': 'synchro', 'label': 'SYNCHRO', 'color': Color(0xFFCCCCCC)},
  {'name': 'xyz', 'label': 'XYZ', 'color': Color(0xFF000000)},
  {'name': 'link', 'label': 'LINK', 'color': Color(0xFF00008B)},
  {'name': 'pendulum', 'label': 'PENDULUM', 'color': Color(0xFF45A29E)},
  {'name': 'token', 'label': 'TOKEN', 'color': Color(0xFFC0C0C0)},
];

const List<String> _kSubTypes = ['Flip', 'Toon', 'Spirit', 'Union', 'Gemini', 'Tuner'];

class CardFilterBottomSheet extends ConsumerStatefulWidget {
  final bool isDeckBuilder;
  const CardFilterBottomSheet({super.key, this.isDeckBuilder = false});

  @override
  ConsumerState<CardFilterBottomSheet> createState() => _CardFilterBottomSheetState();
}

class _CardFilterBottomSheetState extends ConsumerState<CardFilterBottomSheet> {
  String? _tempAttribute;
  String? _tempRace;
  String? _tempSubType;
  String? _tempFrame;
  int? _tempLevel;
  int? _tempScale;
  int? _tempLinkVal;
  int? _tempAtk;
  String? _tempAtkOperator;
  bool? _tempAtkShowQuestionMark;
  int? _tempDef;
  String? _tempDefOperator;
  bool? _tempDefShowQuestionMark;
  bool _tempOnlyEdison = false;

  final TextEditingController _atkController = TextEditingController();
  final TextEditingController _defController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dynamic notifier = widget.isDeckBuilder
        ? ref.read(deckCardListProvider.notifier)
        : ref.read(cardListProvider.notifier);
    _tempAttribute = notifier.currentAttributeFilter;
    _tempRace = notifier.currentRaceFilter;
    _tempSubType = notifier.currentSubTypeFilter;
    _tempFrame = notifier.currentFrameFilter;
    _tempLevel = notifier.currentLevelFilter;
    _tempScale = notifier.currentScaleFilter;
    _tempLinkVal = notifier.currentLinkValFilter;
    _tempAtk = notifier.currentAtkFilter;
    _tempAtkOperator = notifier.currentAtkOperator;
    _tempAtkShowQuestionMark = notifier.currentAtkShowQuestionMark;
    _tempDef = notifier.currentDefFilter;
    _tempDefOperator = notifier.currentDefOperator;
    _tempDefShowQuestionMark = notifier.currentDefShowQuestionMark;
    _tempOnlyEdison = notifier.currentOnlyEdisonFilter;

    _atkController.text = _tempAtk?.toString() ?? '';
    _defController.text = _tempDef?.toString() ?? '';
  }

  @override
  void dispose() {
    _atkController.dispose();
    _defController.dispose();
    super.dispose();
  }

  void _applyFilters(String type) {
    if (widget.isDeckBuilder) {
      ref.read(deckCardListProvider.notifier).applyFilters(
            type: type,
            attribute: type == 'Monster' ? _tempAttribute : null,
            race: (type == 'Spell' || type == 'Trap' || type == 'Monster') ? _tempRace : null,
            subType: type == 'Monster' ? _tempSubType : null,
            frame: type == 'Monster' ? _tempFrame : null,
            level: type == 'Monster' ? _tempLevel : null,
            scale: type == 'Monster' ? _tempScale : null,
            linkVal: type == 'Monster' ? _tempLinkVal : null,
            atk: type == 'Monster' ? int.tryParse(_atkController.text) : null,
            atkOperator: type == 'Monster' ? _tempAtkOperator : null,
            atkShowQuestionMark: type == 'Monster' ? _tempAtkShowQuestionMark : null,
            def: type == 'Monster' ? int.tryParse(_defController.text) : null,
            defOperator: type == 'Monster' ? _tempDefOperator : null,
            defShowQuestionMark: type == 'Monster' ? _tempDefShowQuestionMark : null,
            onlyEdison: _tempOnlyEdison,
          );
    } else {
      ref.read(cardListProvider.notifier).applyFilters(
            type: type,
            attribute: type == 'Monster' ? _tempAttribute : null,
            race: (type == 'Spell' || type == 'Trap' || type == 'Monster') ? _tempRace : null,
            subType: type == 'Monster' ? _tempSubType : null,
            frame: type == 'Monster' ? _tempFrame : null,
            level: type == 'Monster' ? _tempLevel : null,
            scale: type == 'Monster' ? _tempScale : null,
            linkVal: type == 'Monster' ? _tempLinkVal : null,
            atk: type == 'Monster' ? int.tryParse(_atkController.text) : null,
            atkOperator: type == 'Monster' ? _tempAtkOperator : null,
            atkShowQuestionMark: type == 'Monster' ? _tempAtkShowQuestionMark : null,
            def: type == 'Monster' ? int.tryParse(_defController.text) : null,
            defOperator: type == 'Monster' ? _tempDefOperator : null,
            defShowQuestionMark: type == 'Monster' ? _tempDefShowQuestionMark : null,
            onlyEdison: _tempOnlyEdison,
          );
    }
  }

  void _clearFilters() {
    if (widget.isDeckBuilder) {
      ref.read(deckCardListProvider.notifier).clearFilters();
    } else {
      ref.read(cardListProvider.notifier).clearFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
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
              tabs: const [Tab(text: 'MONSTER'), Tab(text: 'SPELL'), Tab(text: 'TRAP')],
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
                    atkController: _atkController,
                    selectedAtkOperator: _tempAtkOperator,
                    selectedAtkShowQuestionMark: _tempAtkShowQuestionMark,
                    defController: _defController,
                    selectedDefOperator: _tempDefOperator,
                    selectedDefShowQuestionMark: _tempDefShowQuestionMark,
                    onlyEdison: _tempOnlyEdison,
                    onAttributeSelected: (attr) => setState(() => _tempAttribute = attr),
                    onRaceSelected: (race) => setState(() => _tempRace = race),
                    onSubTypeSelected: (subType) => setState(() => _tempSubType = subType),
                    onFrameSelected: (frame) => setState(() => _tempFrame = frame),
                    onLevelChanged: (level) => setState(() => _tempLevel = level),
                    onScaleChanged: (scale) => setState(() => _tempScale = scale),
                    onLinkValChanged: (linkVal) => setState(() => _tempLinkVal = linkVal),
                    onAtkOperatorChanged: (op) => setState(() => _tempAtkOperator = op),
                    onAtkShowQuestionMarkChanged: (show) => setState(() => _tempAtkShowQuestionMark = show),
                    onDefOperatorChanged: (op) => setState(() => _tempDefOperator = op),
                    onDefShowQuestionMarkChanged: (show) => setState(() => _tempDefShowQuestionMark = show),
                    onOnlyEdisonChanged: (val) => setState(() => _tempOnlyEdison = val),
                    onApply: () {
                      _applyFilters('Monster');
                      Navigator.pop(context);
                    },
                    onClear: () {
                      _clearFilters();
                      Navigator.pop(context);
                    },
                  ),
                  _FilterTabContent(
                    type: 'Spell',
                    selectedRace: _tempRace,
                    onlyEdison: _tempOnlyEdison,
                    onRaceSelected: (race) => setState(() => _tempRace = race),
                    onOnlyEdisonChanged: (val) => setState(() => _tempOnlyEdison = val),
                    onApply: () {
                      _applyFilters('Spell');
                      Navigator.pop(context);
                    },
                    onClear: () {
                      _clearFilters();
                      Navigator.pop(context);
                    },
                  ),
                  _FilterTabContent(
                    type: 'Trap',
                    selectedRace: _tempRace,
                    onlyEdison: _tempOnlyEdison,
                    onRaceSelected: (race) => setState(() => _tempRace = race),
                    onOnlyEdisonChanged: (val) => setState(() => _tempOnlyEdison = val),
                    onApply: () {
                      _applyFilters('Trap');
                      Navigator.pop(context);
                    },
                    onClear: () {
                      _clearFilters();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getInitialTabIndex() {
    final currentType = widget.isDeckBuilder
        ? ref.read(deckCardListProvider.notifier).currentTypeFilter
        : ref.read(cardListProvider.notifier).currentTypeFilter;
    if (currentType == 'Spell') return 1;
    if (currentType == 'Trap') return 2;
    return 0;
  }
}

class CardSortBottomSheet extends ConsumerWidget {
  final bool isDeckBuilder;
  const CardSortBottomSheet({super.key, this.isDeckBuilder = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sortBy = isDeckBuilder
        ? ref.read(deckCardListProvider.notifier).currentSortBy
        : ref.read(cardListProvider.notifier).currentSortBy;
    final descending = isDeckBuilder
        ? ref.read(deckCardListProvider.notifier).currentSortDescending
        : ref.read(cardListProvider.notifier).currentSortDescending;
    final options = const [
      {'label': 'A-Z', 'field': 'name', 'desc': false, 'icon': Icons.sort_by_alpha_rounded},
      {'label': 'Z-A', 'field': 'name', 'desc': true, 'icon': Icons.sort_by_alpha_rounded},
      {'label': 'DATE ASC', 'field': 'tcgDate', 'desc': false, 'icon': Icons.calendar_today_rounded},
      {'label': 'DATE DESC', 'field': 'tcgDate', 'desc': true, 'icon': Icons.calendar_today_rounded},
      {'label': 'ATK ASC', 'field': 'atk', 'desc': false, 'icon': Icons.trending_up_rounded},
      {'label': 'ATK DESC', 'field': 'atk', 'desc': true, 'icon': Icons.trending_down_rounded},
      {'label': 'DEF ASC', 'field': 'def', 'desc': false, 'icon': Icons.trending_up_rounded},
      {'label': 'DEF DESC', 'field': 'def', 'desc': true, 'icon': Icons.trending_down_rounded},
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Text('ORDER BY', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2, color: theme.colorScheme.primary)),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 60,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final opt = options[index];
              final isSelected = sortBy == opt['field'] && descending == opt['desc'];
              return InkWell(
                onTap: () {
                  if (isDeckBuilder) {
                    ref.read(deckCardListProvider.notifier).setSort(opt['field'] as String, opt['desc'] as bool);
                  } else {
                    ref.read(cardListProvider.notifier).setSort(opt['field'] as String, opt['desc'] as bool);
                  }
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.white10, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(opt['icon'] as IconData, size: 18, color: isSelected ? theme.colorScheme.primary : Colors.white38),
                      const SizedBox(width: 8),
                      Text(
                        opt['label'] as String,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? theme.colorScheme.primary : Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FilterTabContent extends StatelessWidget {
  final String type;
  final String? selectedAttribute;
  final String? selectedRace;
  final String? selectedSubType;
  final String? selectedFrame;
  final int? selectedLevel;
  final int? selectedScale;
  final int? selectedLinkVal;
  final TextEditingController? atkController;
  final String? selectedAtkOperator;
  final bool? selectedAtkShowQuestionMark;
  final TextEditingController? defController;
  final String? selectedDefOperator;
  final bool? selectedDefShowQuestionMark;
  final bool onlyEdison;

  final ValueChanged<String?>? onAttributeSelected;
  final ValueChanged<String?>? onRaceSelected;
  final ValueChanged<String?>? onSubTypeSelected;
  final ValueChanged<String?>? onFrameSelected;
  final ValueChanged<int?>? onLevelChanged;
  final ValueChanged<int?>? onScaleChanged;
  final ValueChanged<int?>? onLinkValChanged;
  final ValueChanged<String?>? onAtkOperatorChanged;
  final ValueChanged<bool?>? onAtkShowQuestionMarkChanged;
  final ValueChanged<String?>? onDefOperatorChanged;
  final ValueChanged<bool?>? onDefShowQuestionMarkChanged;
  final ValueChanged<bool>? onOnlyEdisonChanged;
  final VoidCallback? onApply;
  final VoidCallback? onClear;

  const _FilterTabContent({
    required this.type,
    this.selectedAttribute,
    this.selectedRace,
    this.selectedSubType,
    this.selectedFrame,
    this.selectedLevel,
    this.selectedScale,
    this.selectedLinkVal,
    this.atkController,
    this.selectedAtkOperator,
    this.selectedAtkShowQuestionMark,
    this.defController,
    this.selectedDefOperator,
    this.selectedDefShowQuestionMark,
    this.onlyEdison = false,
    this.onAttributeSelected,
    this.onRaceSelected,
    this.onSubTypeSelected,
    this.onFrameSelected,
    this.onLevelChanged,
    this.onScaleChanged,
    this.onLinkValChanged,
    this.onAtkOperatorChanged,
    this.onAtkShowQuestionMarkChanged,
    this.onDefOperatorChanged,
    this.onDefShowQuestionMarkChanged,
    this.onOnlyEdisonChanged,
    this.onApply,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMonster = type == 'Monster';
    final isSpell = type == 'Spell';
    final isTrap = type == 'Trap';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMonster) ...[
            Row(
              children: [
                Expanded(child: _buildStatSelector('ATK', atkController!, selectedAtkOperator, selectedAtkShowQuestionMark, onAtkOperatorChanged!, onAtkShowQuestionMarkChanged!, theme)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatSelector('DEF', defController!, selectedDefOperator, selectedDefShowQuestionMark, onDefOperatorChanged!, onDefShowQuestionMarkChanged!, theme)),
              ],
            ),
            const SizedBox(height: 32),
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
              children: _kFrames.map((f) {
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
                    side: BorderSide(
                      color: isSelected ? Colors.white : (isVeryDark ? Colors.white24 : frameColor.withValues(alpha: 0.4)),
                      width: 1,
                    ),
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
              children: _kAttributes.map((attr) {
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
              children: _kMonsterRaces.map((race) {
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
              children: _kSubTypes.map((st) {
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
          if (isSpell || isTrap) ...[
            Text('SELECT ${type.toUpperCase()} TYPE:', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: (isSpell ? _kSpellRaces : _kTrapRaces).map((race) {
                final isSelected = selectedRace == race['name'];
                return InkWell(
                  onTap: () => onRaceSelected?.call(isSelected ? null : race['name']),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (race['asset'] != null) Image.asset(race['asset']!, width: 24, height: 24) else const SizedBox(width: 24, height: 24),
                        const SizedBox(height: 8),
                        Text((race['name']!).toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? theme.colorScheme.primary : Colors.white38)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
          Material(
            color: Colors.transparent,
            child: SwitchListTile(
              title: const Text('ONLY EDISON FORMAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1)),
              subtitle: const Text('Hide cards not legal in Edison', style: TextStyle(fontSize: 12, color: Colors.white38)),
              value: onlyEdison,
              onChanged: onOnlyEdisonChanged,
              activeThumbColor: Colors.blueAccent,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Filter by this type?', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onApply,
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
            onPressed: onClear,
            child: const Text('CLEAR ALL FILTERS', style: TextStyle(color: Colors.white38)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSelector(String label, TextEditingController controller, String? operator, bool? showQuestionMark, ValueChanged<String?> onOperatorChanged, ValueChanged<bool?> onShowQuestionMarkChanged, ThemeData theme) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white38)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(hintText: 'Any', contentPadding: const EdgeInsets.symmetric(vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => onOperatorChanged(operator == '>=' ? null : '>='), icon: const Icon(Icons.arrow_upward_rounded), color: operator == '>=' ? theme.colorScheme.primary : Colors.white24),
            IconButton(onPressed: () => onOperatorChanged(operator == '<=' ? null : '<='), icon: const Icon(Icons.arrow_downward_rounded), color: operator == '<=' ? theme.colorScheme.primary : Colors.white24),
            IconButton(onPressed: () => onShowQuestionMarkChanged(showQuestionMark == true ? null : true), icon: Text('?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: showQuestionMark == true ? theme.colorScheme.primary : Colors.white24))),
          ],
        ),
      ],
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
            IconButton(onPressed: () { final c = value ?? min; if (c > min) onChanged(c - 1); }, icon: const Icon(Icons.remove_circle_outline)),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: accentColor), borderRadius: BorderRadius.circular(8), color: value != null ? accentColor.withValues(alpha: 0.1) : null),
              child: Text(value?.toString() ?? 'ANY', textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: value != null ? accentColor : Colors.white24)),
            ),
            IconButton(onPressed: () { final c = value ?? min; if (c < max) onChanged(c + 1); }, icon: const Icon(Icons.add_circle_outline)),
            if (value != null) IconButton(onPressed: () => onChanged(null), icon: const Icon(Icons.clear, size: 20)),
          ],
        ),
      ],
    );
  }
}
