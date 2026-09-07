import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_detail_provider.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_inventory_provider.dart';
import 'package:ygobinder/features/cards/presentation/providers/favorite_providers.dart';
import 'package:ygobinder/features/cards/data/repositories/favorite_sync_repository.dart';
import 'package:ygobinder/features/cards/presentation/providers/wanted_providers.dart';
import 'package:ygobinder/features/cards/data/repositories/wanted_sync_repository.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

String formatLastUpdatedTimestamp(String? isoString) {
  if (isoString == null || isoString.trim().isEmpty) return '';
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '';

  final local = dt.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year;
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');

  return '$day/$month/$year $hour:$minute';
}

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
    final theme = Theme.of(context);
    final colors = _getCardColors();
    final isHybrid = colors.length > 1;
    final isDark = colors.first.computeLuminance() < 0.5;
    final foregroundColor = isDark ? Colors.white : Colors.black87;
    final attributeAsset = _getAttributeAsset();

    final isFavAsync = ref.watch(isFavoriteCardProvider(card.id));
    final isFav = isFavAsync.value ?? false;

    final isWantedAsync = ref.watch(isWantedCardProvider(card.id));
    final isWanted = isWantedAsync.value ?? false;

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
          IconButton(
            icon: Icon(
              isFav ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFav ? Colors.amber : foregroundColor,
              size: 28,
            ),
            tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
            onPressed: () async {
              final db = ref.read(databaseProvider);
              final syncRepo = ref.read(favoriteSyncRepositoryProvider);
              final newIsFav = await db.toggleFavorite(card.id);
              await syncRepo.syncFavorite(card.id, newIsFav);
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/icon/wanted.png',
              width: 26,
              height: 26,
              color: isWanted ? theme.colorScheme.primary : foregroundColor.withValues(alpha: 0.35),
            ),
            tooltip: isWanted ? 'Remove from Wanted' : 'Add to Wanted',
            onPressed: () async {
              final db = ref.read(databaseProvider);
              final syncRepo = ref.read(wantedSyncRepositoryProvider);
              final newIsWanted = await db.toggleWanted(card.id);
              await syncRepo.syncWanted(card.id, newIsWanted);
            },
          ),
          if (attributeAsset != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 4.0),
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
      final bool isBanned = s == 'banned' || s == 'prohibited' || s == 'forbidden' || s == '0';
      final bool isLimited = s == 'limited' || s == '1';
      final bool isSemiLimited = s == 'semi-limited' || s == 'semilimited' || s == '2';
      final bool isEdisonUnlimited = label == 'EDI' && (s == 'unlimited' || s == '3');

      if (isBanned || isLimited || isSemiLimited || isEdisonUnlimited) {
        IconData iconData = Icons.block;
        Color iconColor = Colors.redAccent;

        if (isLimited) {
          iconData = Icons.looks_one_outlined;
          iconColor = Colors.orangeAccent;
        } else if (isSemiLimited) {
          iconData = Icons.looks_two_outlined;
          iconColor = Colors.yellowAccent;
        } else if (isEdisonUnlimited) {
          iconData = Icons.looks_3_outlined; // ✅ Visual for 3 copies in Edison
          iconColor = Colors.greenAccent;
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
    
    // ✅ Edison Status
    if (info.banEdison != null) {
      addStatus(info.banEdison, 'EDI');
    }

    if (items.isEmpty) {
      // ✅ Special indicator if available in Edison (Now Green with "EDI")
      if (info.banEdison != null) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.greenAccent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.verified_rounded, color: Colors.greenAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'EDI',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

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
                ?headerLeading,
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
                ?headerTrailing,
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
        const SizedBox(height: 24),
        _buildSeePricesButton(context),
        const SizedBox(height: 12),
        _buildOpenInTcgPlayerButton(context),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSeePricesButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: () => _showSeePricesBottomSheet(context, card),
      icon: const Icon(Icons.price_change_rounded, size: 18),
      label: const Text(
        'See prices',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildOpenInTcgPlayerButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final cleanName = card.name.trim().replaceAll(RegExp(r'\s+'), '+');
        final encodedName = Uri.encodeQueryComponent(cleanName).replaceAll('%2B', '+');
        final urlString =
            'https://www.tcgplayer.com/search/yugioh/product?productLineName=yugioh&productName=$encodedName&Language=English';
        final uri = Uri.parse(urlString);

        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open TCGPlayer: $e')),
            );
          }
        }
      },
      icon: const Icon(Icons.open_in_new_rounded, size: 18),
      label: const Text(
        'Open in TCGPlayer',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(color: foregroundColor.withValues(alpha: 0.4)),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildInventoryTable(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(cardInventoryProvider(card.id));
    final db = ref.watch(databaseProvider);
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

        return StreamBuilder<List<DriftSetCardPrice>>(
          stream: db.watchPricesForCard(card.id),
          builder: (context, snapshot) {
            final setPricesList = snapshot.data ?? [];

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
                            0: FlexColumnWidth(2.2),
                            1: FlexColumnWidth(2.5),
                            2: FlexColumnWidth(1.0),
                            3: FlexColumnWidth(1.8),
                          },
                          children: [
                            TableRow(
                              children: [
                                _tableHeader('SET', theme),
                                _tableHeader('RARITY', theme),
                                _tableHeader('QTY', theme, textAlign: TextAlign.center),
                                _tableHeader('PRICE', theme, textAlign: TextAlign.end),
                              ],
                            ),
                            ...collectionItems.map((item) {
                              final priceString = _getInventoryItemPriceString(item, setPricesList, card);
                              final timestampStr = _getInventoryItemTimestampString(item, setPricesList);
                              return TableRow(
                                children: [
                                  _tableCell(item.setCode, theme),
                                  _tableCell(item.rarity, theme),
                                  _tableCell(item.quantity.toString(), theme, textAlign: TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          priceString,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: priceString.startsWith('\$') ? Colors.greenAccent : foregroundColor.withValues(alpha: 0.5),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        if (timestampStr.isNotEmpty)
                                          Text(
                                            timestampStr,
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: foregroundColor.withValues(alpha: 0.4),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _getInventoryItemPriceString(
    DriftCollectionItem item,
    List<DriftSetCardPrice> setPrices,
    YgoCard card,
  ) {
    // 1. Try matching SetCardPrices by setCode or rarity
    final matchingPrices = setPrices.where((p) {
      final codeMatch = p.setCode != null &&
          p.setCode!.trim().toUpperCase() == item.setCode.trim().toUpperCase();
      final rarityMatch = p.printing.toLowerCase().contains(item.rarity.toLowerCase()) ||
          item.rarity.toLowerCase().contains(p.printing.toLowerCase());
      return codeMatch || rarityMatch;
    }).toList();

    if (matchingPrices.isNotEmpty) {
      final market = matchingPrices.first.marketPrice ?? matchingPrices.first.lowPrice;
      if (market != null && market > 0.0) {
        return '\$${market.toStringAsFixed(2)}';
      }
    }

    // 2. Try matching CardSets in YgoCard
    if (card.cardSets != null) {
      final matchingCardSet = card.cardSets!.firstWhereOrNull((cs) =>
          cs.setCode.trim().toUpperCase() == item.setCode.trim().toUpperCase() ||
          cs.setRarity.toLowerCase().contains(item.rarity.toLowerCase()));
      if (matchingCardSet != null && matchingCardSet.setPrice != null) {
        final p = matchingCardSet.setPrice;
        if (p != null && p > 0.0) {
          return '\$${p.toStringAsFixed(2)}';
        }
      }
    }

    // 3. Try priceAtPurchase in item
    if (item.priceAtPurchase != null && item.priceAtPurchase! > 0.0) {
      return '\$${item.priceAtPurchase!.toStringAsFixed(2)}';
    }

    // 4. Try global cardPrices in card
    final globalTcg = card.cardPrices?.firstOrNull?.tcgPlayerPrice;
    if (globalTcg != null && globalTcg > 0.0) {
      return '\$${globalTcg.toStringAsFixed(2)}';
    }

    return 'N/A';
  }

  String _getInventoryItemTimestampString(
    DriftCollectionItem item,
    List<DriftSetCardPrice> setPrices,
  ) {
    final matchingPrices = setPrices.where((p) {
      final codeMatch = p.setCode != null &&
          p.setCode!.trim().toUpperCase() == item.setCode.trim().toUpperCase();
      final rarityMatch = p.printing.toLowerCase().contains(item.rarity.toLowerCase()) ||
          item.rarity.toLowerCase().contains(p.printing.toLowerCase());
      return codeMatch || rarityMatch;
    }).toList();

    if (matchingPrices.isNotEmpty) {
      return formatLastUpdatedTimestamp(matchingPrices.first.lastUpdated);
    }
    return '';
  }

  Widget _tableHeader(String text, ThemeData theme, {TextAlign textAlign = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: foregroundColor.withValues(alpha: 0.5),
        ),
        textAlign: textAlign,
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

void _showSeePricesBottomSheet(BuildContext context, YgoCard card) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CardPricesBottomSheet(card: card),
  );
}

class _CardPricesBottomSheet extends ConsumerStatefulWidget {
  final YgoCard card;

  const _CardPricesBottomSheet({required this.card});

  @override
  ConsumerState<_CardPricesBottomSheet> createState() => _CardPricesBottomSheetState();
}

class _CardPricesBottomSheetState extends ConsumerState<_CardPricesBottomSheet> {
  int _processedCount = 0;
  int _totalCount = 0;
  String _currentStatus = 'Initializing...';
  bool _isFetching = false;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFetchingPrices();
    });
  }

  @override
  void dispose() {
    _isCancelled = true;
    super.dispose();
  }

  Future<void> _startFetchingPrices({bool forceRefresh = false}) async {
    if (!mounted || _isFetching) return;

    final db = ref.read(databaseProvider);
    final dataService = CardDataService();

    // Check if prices for this card already exist in local SQLite cache
    final cachedPrices = await db.getPricesForCard(widget.card.id);
    if (cachedPrices.isNotEmpty && !forceRefresh) {
      final tsStr = formatLastUpdatedTimestamp(cachedPrices.first.lastUpdated);
      if (mounted) {
        setState(() {
          _isFetching = false;
          _currentStatus = tsStr.isNotEmpty
              ? 'Cached prices (Updated: $tsStr). Tap 🔄 to refresh.'
              : 'Displaying cached prices. Tap 🔄 to update.';
        });
      }
      return; // Do NOT call API if already cached!
    }

    final cardSets = widget.card.cardSets ?? [];
    if (cardSets.isEmpty) {
      if (mounted) {
        setState(() {
          _currentStatus = 'No set printings found for this card.';
        });
      }
      return;
    }

    // Extract unique base set codes
    final allSetInfos = await db.getAllSetInfos();
    final setInfoByAbbr = {
      for (final info in allSetInfos)
        if (info.abbreviation != null && info.abbreviation!.isNotEmpty)
          info.abbreviation!.toUpperCase(): info
    };
    final setInfoByName = {
      for (final info in allSetInfos) info.name.toUpperCase(): info
    };

    final setTasks = <_CardSetTask>[];
    final addedSetIds = <int>{};

    for (final cs in cardSets) {
      final rawCode = cs.setCode.trim();
      final baseCode = rawCode.contains('-') ? rawCode.split('-').first.toUpperCase() : rawCode.toUpperCase();
      final setInfo = setInfoByAbbr[baseCode] ?? setInfoByName[cs.setName.toUpperCase()];

      if (setInfo != null && !addedSetIds.contains(setInfo.id)) {
        addedSetIds.add(setInfo.id);
        setTasks.add(_CardSetTask(
          setId: setInfo.id,
          setCode: cs.setCode,
          setName: cs.setName,
          setSymbolUrl: setInfo.setSymbolUrl,
        ));
      }
    }

    if (setTasks.isEmpty) {
      if (mounted) {
        setState(() {
          _currentStatus = 'No set metadata found for card printings.';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isFetching = true;
        _totalCount = setTasks.length;
        _processedCount = 0;
      });
    }

    // Map existing cached prices to preserve previous market price on update
    final oldPricesMap = <String, double>{};
    for (final cp in cachedPrices) {
      if (cp.marketPrice != null && cp.marketPrice! > 0.0) {
        oldPricesMap['${cp.setId}_${cp.printing.trim().toLowerCase()}'] = cp.marketPrice!;
      }
    }

    // Clear old price records for this card before fetching fresh prices
    await db.deleteSetCardPricesForCard(widget.card.id);

    for (var i = 0; i < setTasks.length; i++) {
      if (!mounted || _isCancelled) break;

      final task = setTasks[i];
      if (mounted) {
        setState(() {
          _processedCount = i + 1;
          _currentStatus = 'Fetching ${i + 1} of ${setTasks.length}: ${task.setName}...';
        });
      }

      try {
        // Step 2: Query Link 2 (https://openapi.tcgtracking.com/v1/2/sets/{set_id}/cards)
        final setCards = await dataService.fetchSetCards(task.setId);
        final matchedProducts = <Map<String, dynamic>>[];

        if (setCards != null && setCards.isNotEmpty) {
          final cleanTargetCode = task.setCode.trim().toUpperCase();
          final cleanCardName = widget.card.name.trim().toUpperCase();
          final normCardName = cleanCardName.replaceAll(RegExp(r'[^A-Z0-9]'), '');

          final targetPrefix = cleanTargetCode.contains('-') ? cleanTargetCode.split('-').first : cleanTargetCode;
          final targetDigits = cleanTargetCode.replaceAll(RegExp(r'[^0-9]'), '');

          for (final item in setCards) {
            final json = item as Map<String, dynamic>;
            final number = (json['number'] as String?)?.trim().toUpperCase() ?? '';
            final cleanName = (json['clean_name'] as String?)?.trim().toUpperCase() ??
                (json['name'] as String?)?.trim().toUpperCase() ?? '';
            final normApiName = cleanName.replaceAll(RegExp(r'[^A-Z0-9]'), '');

            final itemPrefix = number.contains('-') ? number.split('-').first : number;
            final itemDigits = number.replaceAll(RegExp(r'[^0-9]'), '');

            bool isMatch = false;

            // Strategy 1: Exact Set Code Match (e.g. "PGD-070" == "PGD-070")
            if (number.isNotEmpty && number == cleanTargetCode) {
              isMatch = true;
            }
            // Strategy 2: Exact Prefix & Digits Match (e.g. "PGD-EN070" vs "PGD-070")
            else if (targetPrefix.isNotEmpty && itemPrefix == targetPrefix && targetDigits.isNotEmpty && itemDigits == targetDigits) {
              isMatch = true;
            }
            // Strategy 3: Name Match AND matching Digits (e.g. "A Cat of Ill Omen" & digits "070" == "070")
            else if (normApiName == normCardName) {
              if (targetDigits.isNotEmpty && itemDigits.isNotEmpty) {
                if (targetDigits == itemDigits) {
                  isMatch = true;
                }
              } else {
                isMatch = true;
              }
            }

            if (isMatch) {
              matchedProducts.add(json);
            }
          }
        }

        if (mounted && !_isCancelled) {
          await Future.delayed(const Duration(seconds: 1));
        }

        // Step 3: Query Link 3 (https://openapi.tcgtracking.com/v1/2/sets/{set_id}/pricing)
        final pricingData = await dataService.fetchSetPricing(task.setId);
        if (pricingData != null && mounted) {
          final setId = pricingData['set_id'] as int? ?? task.setId;
          final updatedStr = pricingData['updated'] as String? ?? DateTime.now().toIso8601String();
          final pricesMap = pricingData['prices'] as Map<String, dynamic>?;

          if (pricesMap != null && pricesMap.isNotEmpty) {
            final companions = <SetCardPricesCompanion>[];

            for (final product in matchedProducts) {
              final productId = product['id']?.toString();
              final productRarity = product['rarity'] as String? ?? '';

              if (productId != null && pricesMap.containsKey(productId)) {
                final cardData = pricesMap[productId] as Map<String, dynamic>?;
                final tcgData = cardData?['tcg'] as Map<String, dynamic>?;

                if (tcgData != null) {
                  for (final entry in tcgData.entries) {
                    final subPrinting = entry.key; // e.g. "Normal", "1st Edition", "Unlimited"
                    final pMap = entry.value as Map<String, dynamic>?;

                    final low = (pMap?['low'] as num?)?.toDouble();
                    final market = (pMap?['market'] as num?)?.toDouble();

                    final printingName = productRarity.isNotEmpty
                        ? (subPrinting == 'Normal' ? productRarity : '$productRarity ($subPrinting)')
                        : subPrinting;

                    final key = '${setId}_${printingName.trim().toLowerCase()}';
                    final oldPrice = oldPricesMap[key];
                    final prevPrice = (oldPrice != null && market != null && (oldPrice - market).abs() >= 0.01)
                        ? oldPrice
                        : null;

                    companions.add(
                      SetCardPricesCompanion.insert(
                        setId: setId,
                        cardId: widget.card.id,
                        setCode: Value(task.setCode),
                        printing: printingName,
                        lowPrice: Value(low),
                        marketPrice: Value(market),
                        previousMarketPrice: Value(prevPrice),
                        lastUpdated: Value(updatedStr),
                      ),
                    );
                  }
                }
              }
            }

            if (companions.isNotEmpty) {
              await db.saveSetCardPrices(companions);
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching pricing for set ${task.setId}: $e');
      }

      if (i < setTasks.length - 1 && mounted && !_isCancelled) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (mounted) {
      setState(() {
        _isFetching = false;
        _currentStatus = 'All version prices updated!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);
    final cardSets = widget.card.cardSets ?? [];

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.price_change_rounded, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'PRINTING PRICES - ${widget.card.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _isFetching ? null : () => _startFetchingPrices(forceRefresh: true),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  tooltip: 'Refresh prices from API',
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),

          // Progress Status Bar
          if (_isFetching || _currentStatus.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  if (_isFetching)
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                    ),
                  if (_isFetching) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _isFetching ? Colors.amber : Colors.greenAccent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (_isFetching && _totalCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: LinearProgressIndicator(
                  value: _processedCount / _totalCount,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation(Colors.amber),
                  minHeight: 3,
                ),
              ),
          ],

          const Divider(height: 1, color: Colors.white10),

          // Stream of cached prices for this card
          Expanded(
            child: StreamBuilder<List<DriftSetCardPrice>>(
              stream: db.watchPricesForCard(widget.card.id),
              builder: (context, snapshot) {
                final pricesList = snapshot.data ?? [];

                if (cardSets.isEmpty) {
                  return const Center(child: Text('No printings available', style: TextStyle(color: Colors.white38)));
                }

                // Group cardSets by unique setCode
                final uniqueSets = <String, Map<String, dynamic>>{};
                for (final cs in cardSets) {
                  final code = cs.setCode.trim().toUpperCase();
                  if (!uniqueSets.containsKey(code)) {
                    uniqueSets[code] = {
                      'setCode': cs.setCode,
                      'setName': cs.setName,
                      'basePrice': cs.setPrice,
                    };
                  }
                }

                final groupedList = uniqueSets.values.toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedList.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                  itemBuilder: (context, index) {
                    final item = groupedList[index];
                    final setCode = item['setCode'] as String;
                    final setName = item['setName'] as String;

                    // Find all prices in SetCardPrices for this set code
                    final setPrices = pricesList.where((p) => p.setCode?.toUpperCase() == setCode.toUpperCase()).toList();

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  setCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  setName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Display all printings & prices for this set code
                          if (setPrices.isNotEmpty) ...[
                            ...setPrices.map((p) {
                              final ts = formatLastUpdatedTimestamp(p.lastUpdated);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          p.printing,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: p.printing.toLowerCase().contains('quarter') ||
                                                    p.printing.toLowerCase().contains('1st')
                                                ? Colors.amber
                                                : Colors.white70,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (p.marketPrice != null) ...[
                                              const Text('Market: ', style: TextStyle(fontSize: 11, color: Colors.white38)),
                                              Text(
                                                '\$${p.marketPrice!.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                              if (p.previousMarketPrice != null && p.previousMarketPrice! > 0.0) ...[
                                                const SizedBox(width: 6),
                                                _buildTrendBadge(p.marketPrice!, p.previousMarketPrice!),
                                              ],
                                            ],
                                            if (p.lowPrice != null) ...[
                                              const SizedBox(width: 12),
                                              const Text('Low: ', style: TextStyle(fontSize: 11, color: Colors.white38)),
                                              Text(
                                                '\$${p.lowPrice!.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (ts.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Updated: $ts',
                                          style: const TextStyle(fontSize: 9, color: Colors.white38),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ] else if (_isFetching) ...[
                            const Row(
                              children: [
                                SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5)),
                                SizedBox(width: 6),
                                Text('Fetching prices...', style: TextStyle(fontSize: 11, color: Colors.amber)),
                              ],
                            ),
                          ] else ...[
                            Text(
                              item['basePrice'] != null ? '\$${item['basePrice']}' : 'N/A',
                              style: const TextStyle(fontSize: 13, color: Colors.white54),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBadge(double newPrice, double oldPrice) {
    final diff = newPrice - oldPrice;
    if (diff.abs() < 0.01) return const SizedBox.shrink();

    final percent = oldPrice > 0 ? (diff / oldPrice) * 100 : 0.0;
    final isUp = diff > 0;
    final color = isUp ? Colors.greenAccent : Colors.redAccent;
    final arrow = isUp ? '▲' : '▼';
    final sign = isUp ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        '$arrow $sign\$${diff.abs().toStringAsFixed(2)} (${sign}${percent.toStringAsFixed(1)}%)',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _CardSetTask {
  final int setId;
  final String setCode;
  final String setName;
  final String? setSymbolUrl;

  _CardSetTask({
    required this.setId,
    required this.setCode,
    required this.setName,
    this.setSymbolUrl,
  });
}
