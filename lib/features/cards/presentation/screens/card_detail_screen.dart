import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_detail_provider.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_inventory_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardDetailProvider(cardId));

    return cardAsync.when(
      data: (card) {
        if (card == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Card not found')),
          );
        }
        return _CardDetailScaffold(card: card);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: SpinningCardLoader(width: 100, height: 140)),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _CardDetailScaffold extends ConsumerWidget {
  final YgoCard card;

  const _CardDetailScaffold({required this.card});

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
      baseColor = const Color(0xFFFF8B53); // Default Effect orange
    }

    if (isPendulum) {
      // ✅ Hybrid Pendulum: Base color on top, Spell/Pendulum green on bottom
      return [baseColor, const Color(0xFF1D9B7F)];
    }
    return [baseColor];
  }

  String? _getAttributeAsset() {
    final type = card.type.toLowerCase();
    if (type.contains('spell')) return 'assets/images/attributes/spell.webp';
    if (type.contains('trap')) return 'assets/images/attributes/trap.png';
    
    final attr = card.attribute?.toLowerCase();
    if (attr == null) return null;
    
    switch (attr) {
      case 'dark': return 'assets/images/attributes/dark.webp';
      case 'earth': return 'assets/images/attributes/earth.png';
      case 'fire': return 'assets/images/attributes/fire.webp';
      case 'light': return 'assets/images/attributes/light.png';
      case 'water': return 'assets/images/attributes/water.png';
      case 'wind': return 'assets/images/attributes/wind.webp';
      case 'divine': return 'assets/images/attributes/divine.webp';
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = _getCardColors();
    final isHybrid = colors.length > 1;
    final isDark = colors.first.computeLuminance() < 0.5;
    final foregroundColor = isDark ? Colors.white : Colors.black87;
    final attributeAsset = _getAttributeAsset();

    return Scaffold(
      backgroundColor: isHybrid ? null : colors.first,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: foregroundColor),
        title: Text(
          card.name,
          style: TextStyle(color: foregroundColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (attributeAsset != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                attributeAsset,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: isHybrid
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                  stops: const [0.2, 0.9],
                ),
              )
            : null,
        child: SafeArea(
          child: _CardDetailBody(card: card, foregroundColor: foregroundColor),
        ),
      ),
    );
  }
}

class _CardDetailBody extends ConsumerStatefulWidget {
  final YgoCard card;
  final Color foregroundColor;

  const _CardDetailBody({required this.card, required this.foregroundColor});

  @override
  ConsumerState<_CardDetailBody> createState() => _CardDetailBodyState();
}

class _CardDetailBodyState extends ConsumerState<_CardDetailBody> {
  int _currentImageIndex = 0;

  void _nextImage() {
    final images = widget.card.cardImages;
    if (images == null || images.length <= 1) return;

    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % images.length;
    });
  }

  Widget _buildLinkMarkersOverlay(List<String> activeMarkers, BoxConstraints constraints) {
    const markerMap = {
      'Top': {'alignment': Alignment.topCenter, 'file': 'arrow-up'},
      'Bottom': {'alignment': Alignment.bottomCenter, 'file': 'arrow-down'},
      'Left': {'alignment': Alignment.centerLeft, 'file': 'arrow-left'},
      'Right': {'alignment': Alignment.centerRight, 'file': 'arrow-right'},
      'Top-Left': {'alignment': Alignment.topLeft, 'file': 'arrow-left-up'},
      'Top-Right': {'alignment': Alignment.topRight, 'file': 'arrow-right-up'},
      'Bottom-Left': {'alignment': Alignment.bottomLeft, 'file': 'arrow-left-down'},
      'Bottom-Right': {'alignment': Alignment.bottomRight, 'file': 'arrow-right-down'},
    };

    final normalizedActive = activeMarkers.map((m) => m.replaceAll(' ', '-')).toList();

    // ✅ Dynamic scaling based on the smallest dimension of the parent (width or height)
    final double referenceSize = constraints.maxWidth < constraints.maxHeight 
        ? constraints.maxWidth 
        : constraints.maxHeight;
        
    // ✅ Base scaling factors
    final double baseArrowSize = referenceSize * 0.18; 
    // ✅ Reduced Axis arrows (Top, Bottom, Left, Right) to 75% of their previous size
    // Previous: 0.315 * 0.75 = 0.23625
    final double enlargedArrowSize = referenceSize * 0.23625; 
    
    return Stack(
      clipBehavior: Clip.none,
      children: markerMap.entries.map((entry) {
        final String marker = entry.key;
        final Alignment alignment = entry.value['alignment'] as Alignment;
        final String fileName = entry.value['file'] as String;
        final bool isOn = normalizedActive.contains(marker);
        final String suffix = isOn ? 'on' : 'off';

        final bool isCorner = marker.contains('-');
        
        // ✅ Per-marker size and shift
        final double currentArrowSize = isCorner ? baseArrowSize : enlargedArrowSize;
        // ✅ Adjusted Axis shift: center is slightly outside, border sits between inner edge and center
        final double currentShift = isCorner ? (currentArrowSize * 0.25) : (currentArrowSize * 0.58);

        Offset offset = Offset.zero;

        if (marker == 'Top') {
          offset = Offset(0, -currentShift);
        } else if (marker == 'Bottom') {
          offset = Offset(0, currentShift);
        } else if (marker == 'Left') {
          offset = Offset(-currentShift, 0);
        } else if (marker == 'Right') {
          offset = Offset(currentShift, 0);
        } else if (marker == 'Top-Left') {
          offset = Offset(-currentShift, -currentShift);
        } else if (marker == 'Top-Right') {
          offset = Offset(currentShift, -currentShift);
        } else if (marker == 'Bottom-Left') {
          offset = Offset(-currentShift, currentShift);
        } else if (marker == 'Bottom-Right') {
          offset = Offset(currentShift, currentShift);
        }

        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: Image.asset(
              'assets/images/arrows/$fileName-$suffix.png',
              width: currentArrowSize,
              height: currentArrowSize,
              fit: BoxFit.contain,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final images = widget.card.cardImages;
    final imageUrl = (images != null && images.isNotEmpty)
        ? images[_currentImageIndex].imageUrlCropped // ✅ Reverted to cropped image as requested
        : '';
    final bool isLink = widget.card.type.toLowerCase().contains('link');

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > constraints.maxHeight;

        Widget imageWidget = Hero(
          tag: 'card_image_${widget.card.id}',
          child: GestureDetector(
            onTap: _nextImage,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // ✅ Allow Link markers to bleed outside the Stack
              children: [
                // 1. The Framed Image (Defines the size of the Stack)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.grey,
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: CachedNetworkImage(
                      key: ValueKey(imageUrl),
                      imageUrl: imageUrl,
                      cacheManager: cacheManager,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SpinningCardLoader(),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                
                // 2. The Link Markers overlay (Sitting ON TOP of the border)
                if (isLink)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, markersConstraints) {
                        if (markersConstraints.maxWidth <= 0) return const SizedBox.shrink();
                        return _buildLinkMarkersOverlay(widget.card.linkMarkers ?? [], markersConstraints);
                      },
                    ),
                  ),

                if (images != null && images.length > 1)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1} / ${images.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      imageWidget,
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _CardInfo(card: widget.card, foregroundColor: widget.foregroundColor),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight * 0.5,
                    ),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(height: 24),
                _CardInfo(card: widget.card, foregroundColor: widget.foregroundColor),
              ],
            ),
          );
        }
      },
    );
  }
}

class _CardInfo extends ConsumerWidget {
  final YgoCard card;
  final Color foregroundColor;

  const _CardInfo({required this.card, required this.foregroundColor});

  String _getMonsterTypeLine() {
    final List<String> parts = [];
    parts.add(card.race);

    if (card.typeLine != null) {
      for (final t in card.typeLine!) {
        if (t != 'Monster' && t != card.race) {
          parts.add(t);
        }
      }
    } else {
      final typeStr = card.type.toLowerCase();
      if (typeStr.contains('effect')) parts.add('Effect');
      if (typeStr.contains('fusion')) parts.add('Fusion');
      if (typeStr.contains('synchro')) parts.add('Synchro');
      if (typeStr.contains('xyz')) parts.add('Xyz');
      if (typeStr.contains('link')) parts.add('Link');
      if (typeStr.contains('ritual')) parts.add('Ritual');
      if (typeStr.contains('pendulum')) parts.add('Pendulum');
      if (typeStr.contains('spirit')) parts.add('Spirit');
      if (typeStr.contains('union')) parts.add('Union');
      if (typeStr.contains('gemini')) parts.add('Gemini');
      if (typeStr.contains('tuner')) parts.add('Tuner');
      if (typeStr.contains('flip')) parts.add('Flip');
      if (typeStr.contains('toon')) parts.add('Toon');
    }

    return '[${parts.toSet().join(' / ')}]';
  }

  Widget _buildLevelStars() {
    final int count = card.level ?? 0;
    if (count == 0) return const SizedBox.shrink();

    final bool isXyz = card.frameType?.toLowerCase().contains('xyz') ?? false;
    final String asset = isXyz 
        ? 'assets/images/attributes/rank.png' 
        : 'assets/images/attributes/level.png';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: isXyz ? Alignment.centerLeft : Alignment.centerRight,
        child: Wrap(
          textDirection: isXyz ? TextDirection.ltr : TextDirection.rtl, // ✅ Content grows from edge
          spacing: -4, // Slightly overlap stars for a more authentic TCG look
          runSpacing: 4,
          children: List.generate(
            count,
            (index) => Image.asset(
              asset,
              width: 24, // Slightly reduced size to fit better on narrow screens
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpellTrapIcon() {
    final String race = card.race.toLowerCase();
    String? asset;

    if (race.contains('continuous')) {
      asset = 'assets/images/attributes/continuous.png';
    } else if (race.contains('counter')) {
      asset = 'assets/images/attributes/counter.webp';
    } else if (race.contains('equip')) {
      asset = 'assets/images/attributes/equip.webp';
    } else if (race.contains('field')) {
      asset = 'assets/images/attributes/field.png';
    } else if (race.contains('quick-play')) {
      asset = 'assets/images/attributes/quickplay.webp';
    } else if (race.contains('ritual')) {
      asset = 'assets/images/attributes/ritual.webp';
    }

    if (asset == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            asset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildBanlistStatus(ThemeData theme) {
    final info = card.banlistInfo;
    if (info == null) return const SizedBox.shrink();

    final List<Widget> items = [];

    void addStatus(String? status, String label) {
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

        items.add(
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(iconData, color: iconColor, size: 64),
              Positioned(
                top: 18,
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(blurRadius: 4.0, color: Colors.black),
                      const Shadow(blurRadius: 2.0, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        items.add(
          Text(
            '$label: $status',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: foregroundColor,
            ),
          ),
        );
      }
    }

    addStatus(info.banTcg, 'TCG');
    addStatus(info.banOcg, 'OCG');
    addStatus(info.banGoat, 'GOAT');

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items,
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddCardBottomSheet(card: card),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddMenu(context),
      icon: const Icon(Icons.add_box_rounded),
      label: const Text(
        'ADD TO COLLECTION',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }

  void _showRemoveMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RemoveCardBottomSheet(card: card),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showRemoveMenu(context), // ✅ Show pop-up menu
      icon: const Icon(Icons.indeterminate_check_box_rounded),
      label: const Text(
        'REMOVE FROM COLLECTION',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildDescriptionBox({
    required BuildContext context,
    required String text,
    String? header,
    Widget? headerLeading,
    Widget? headerTrailing,
    Widget? footer,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: const Color(0xFF8B4513),
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null || headerLeading != null || headerTrailing != null) ...[
            Row(
              children: [
                if (headerLeading != null) headerLeading,
                if (header != null)
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: headerLeading != null ? Alignment.center : Alignment.centerLeft,
                      child: Text(
                        header,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: headerLeading != null ? TextAlign.center : TextAlign.start,
                      ),
                    ),
                  ),
                if (headerTrailing != null) headerTrailing,
              ],
            ),
            const SizedBox(height: 6),
            const Divider(color: Color(0xFF8B4513), thickness: 2),
            const SizedBox(height: 6),
          ],
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.25,
              color: Colors.black87,
              letterSpacing: 0.1,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 6),
            const Divider(color: Color(0xFF8B4513), thickness: 2),
            const SizedBox(height: 6),
            footer,
          ],
        ],
      ),
    );
  }

  Widget _buildPendulumEffectRow(BuildContext context, String effect, int? scale) {
    final theme = Theme.of(context);
    
    final boxDecoration = BoxDecoration(
      color: Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(2),
      border: Border.all(color: const Color(0xFF8B4513), width: 3.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );

    Widget buildScaleBox(String assetPath) {
      return Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(height: 4),
            Text(
              '${scale ?? '?'}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildScaleBox('assets/images/arrows/left_pend.png'),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: boxDecoration,
              child: Text(
                effect,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.25,
                  color: Colors.black87,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          buildScaleBox('assets/images/arrows/right_pend.png'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMonster = !card.type.toLowerCase().contains('spell') && !card.type.toLowerCase().contains('trap');
    final isLink = card.type.toLowerCase().contains('link');
    final isPendulum = card.frameType?.toLowerCase().contains('pendulum') ?? false;

    final inventoryAsync = ref.watch(cardInventoryProvider(card.id));
    final hasInventory = inventoryAsync.value?.isNotEmpty ?? false;

    final monsterEffect = card.monsterDesc ?? card.desc;
    final pendulumEffect = card.pendDesc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMonster) _buildLevelStars() else _buildSpellTrapIcon(),
        const SizedBox(height: 8),

        if (isPendulum && pendulumEffect != null && pendulumEffect.isNotEmpty) ...[
          _buildPendulumEffectRow(context, pendulumEffect, card.scale),
          const SizedBox(height: 16),
        ],

        _buildDescriptionBox(
          context: context,
          text: monsterEffect,
          header: isMonster ? _getMonsterTypeLine() : null,
          footer: (isMonster && (card.atk != null || card.def != null || card.linkVal != null))
              ? Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isLink
                          ? 'ATK/ ${(card.atk == null || card.atk == -1) ? '?' : card.atk}  LINK-${card.linkVal ?? '?'}'
                          : 'ATK/ ${(card.atk == null || card.atk == -1) ? '?' : card.atk}  DEF/ ${(card.def == null || card.def == -1) ? '?' : card.def}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : null,
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            children: [
              _buildBanlistStatus(theme),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (hasInventory) _buildRemoveButton(context),
                  _buildAddButton(context),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInventoryTable(context, ref),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildInventoryTable(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(cardInventoryProvider(card.id));
    final theme = Theme.of(context);

    return inventoryAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        // 1. Group items by collection number
        final grouped = <int, List<DriftCollectionItem>>{};
        for (final item in items) {
          grouped.putIfAbsent(item.collectionNumber, () => []).add(item);
        }
        final sortedCollectionNumbers = grouped.keys.toList()..sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'INVENTORY',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: foregroundColor.withValues(alpha: 0.6),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // 2. Build a grouped section for each collection
            ...sortedCollectionNumbers.map((colNum) {
              final collectionItems = grouped[colNum]!;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_copy_rounded, size: 16, color: theme.colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'COLLECTION #$colNum',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: IntrinsicColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            _tableHeader('SET', theme),
                            _tableHeader('RARITY', theme),
                            _tableHeader('QTY', theme),
                          ],
                        ),
                        ...collectionItems.map((item) => TableRow(
                              children: [
                                _tableCell(item.setCode, theme),
                                _tableCell(item.rarity, theme),
                                _tableCell(item.quantity.toString(), theme, textAlign: TextAlign.center),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _tableHeader(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: foregroundColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _tableCell(String text, ThemeData theme, {TextAlign textAlign = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: foregroundColor,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

class _AddCardBottomSheet extends ConsumerStatefulWidget {
  final YgoCard card;

  const _AddCardBottomSheet({required this.card});

  @override
  ConsumerState<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends ConsumerState<_AddCardBottomSheet> {
  int _quantity = 1;
  int _collectionNumber = 1;
  String _searchQuery = '';
  bool _isSaving = false;

  Future<void> _addToCollection(CardSet cardSet) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(cardRepositoryProvider);
      await repo.addCardToCollection(
        cardId: widget.card.id,
        setCode: cardSet.setCode,
        rarity: cardSet.setRarity,
        quantity: _quantity,
        collectionNumber: _collectionNumber,
      );

      ref.invalidate(cardInventoryProvider(widget.card.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $_quantity x ${widget.card.name} to Collection #$_collectionNumber'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to collection: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allSets = widget.card.cardSets ?? [];
    
    final filteredSets = allSets.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.setCode.toLowerCase().contains(_searchQuery.toLowerCase()) || 
             s.setName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add to Collection',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 1. Selectors Row (Quantity and Collection)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              // Quantity Selector
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Quantity', style: theme.textTheme.labelLarge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Container(
                        width: 40,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              // Collection Selector
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Collection #', style: theme.textTheme.labelLarge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _collectionNumber = (_collectionNumber > 1) ? _collectionNumber - 1 : 1),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Container(
                        width: 40,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.secondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_collectionNumber',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _collectionNumber++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Filter by set code (e.g. LOB)...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Select Version:',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: filteredSets.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(_searchQuery.isEmpty ? 'No set information' : 'No matching sets found'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredSets.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final cardSet = filteredSets[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          cardSet.setName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${cardSet.setCode} • ${cardSet.setRarity}'),
                        trailing: IconButton(
                          onPressed: _isSaving ? null : () => _addToCollection(cardSet),
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.add_circle, color: Colors.greenAccent),
                          iconSize: 32,
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RemoveCardBottomSheet extends ConsumerStatefulWidget {
  final YgoCard card;

  const _RemoveCardBottomSheet({required this.card});

  @override
  ConsumerState<_RemoveCardBottomSheet> createState() => _RemoveCardBottomSheetState();
}

class _RemoveCardBottomSheetState extends ConsumerState<_RemoveCardBottomSheet> {
  int? _selectedCollectionNumber;
  int _quantityToRemove = 1;
  String _searchQuery = '';
  bool _isSaving = false;

  Future<void> _handleRemove(DriftCollectionItem item) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(cardRepositoryProvider);
      await repo.removeCardFromCollection(
        collectionItemId: item.id,
        quantity: _quantityToRemove,
      );

      // Refresh providers
      ref.invalidate(cardInventoryProvider(widget.card.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed $_quantityToRemove copies from Collection #${item.collectionNumber}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventoryAsync = ref.watch(cardInventoryProvider(widget.card.id));

    return Container(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: inventoryAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No copies found in collection', textAlign: TextAlign.center),
            );
          }

          // 1. Extract unique collection numbers
          final collections = items.map((e) => e.collectionNumber).toSet().toList()..sort();
          
          // Initialize selected number if not set or no longer available
          if (_selectedCollectionNumber == null || !collections.contains(_selectedCollectionNumber)) {
            _selectedCollectionNumber = collections.first;
          }

          final currentIndex = collections.indexOf(_selectedCollectionNumber!);
          
          // Filter items by collection AND search query
          final filteredItems = items.where((e) {
            final matchesCollection = e.collectionNumber == _selectedCollectionNumber;
            if (!matchesCollection) return false;
            
            if (_searchQuery.isEmpty) return true;
            return e.setCode.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                   e.rarity.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Remove from Collection',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 2. Selectors Row (Quantity and Collection)
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  // Quantity Selector
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Quantity', style: theme.textTheme.labelLarge),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => setState(() => _quantityToRemove = (_quantityToRemove > 1) ? _quantityToRemove - 1 : 1),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Container(
                            width: 40,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_quantityToRemove',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _quantityToRemove++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Collection Selector (Cycle through existing collections only)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Collection #', style: theme.textTheme.labelLarge),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: currentIndex > 0
                                ? () => setState(() => _selectedCollectionNumber = collections[currentIndex - 1])
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Container(
                            width: 40,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.secondary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_selectedCollectionNumber',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: currentIndex < collections.length - 1
                                ? () => setState(() => _selectedCollectionNumber = collections[currentIndex + 1])
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Search Bar
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Filter your copies (e.g. LOB)...',
                  prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. List of items in that specific collection
              Text(
                'Copies in this collection:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                child: filteredItems.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(_searchQuery.isEmpty ? 'No copies found' : 'No matching copies found'),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredItems.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'QTY: ${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${item.setCode} • ${item.rarity}'),
                            trailing: IconButton(
                              onPressed: _isSaving ? null : () => _handleRemove(item),
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.redAccent),
                                    )
                                  : const Icon(Icons.remove_circle, color: Colors.redAccent),
                              iconSize: 32,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(child: Padding(
          padding: EdgeInsets.all(32.0),
          child: SpinningCardLoader(width: 40, height: 56),
        )),
        error: (err, _) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Error: $err', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
