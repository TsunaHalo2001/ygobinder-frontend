import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/presentation/providers/card_detail_provider.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';
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
    if (frame.contains('pendulum')) return const Color(0xFF45A29E);
    return const Color(0xFF1F2833);
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
    final cardColor = _getCardColor();
    final isPendulum = card.frameType?.toLowerCase().contains('pendulum') ?? false;
    final isDark = cardColor.computeLuminance() < 0.5;
    final foregroundColor = isDark ? Colors.white : Colors.black87;
    final attributeAsset = _getAttributeAsset();

    return Scaffold(
      backgroundColor: isPendulum ? null : cardColor,
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
        decoration: isPendulum
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFF8B53), // Monster color (Effect) - Top in Details
                    Color(0xFF1D9B7F), // Spell color - Bottom in Details
                  ],
                  stops: [0.2, 0.9],
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

  @override
  Widget build(BuildContext context) {
    final cacheManager = ref.watch(imageCacheManagerProvider);
    final images = widget.card.cardImages;
    final imageUrl = (images != null && images.isNotEmpty)
        ? images[_currentImageIndex].imageUrlCropped
        : '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > constraints.maxHeight;

        Widget imageWidget = Hero(
          tag: 'card_image_${widget.card.id}',
          child: GestureDetector(
            onTap: _nextImage, // ✅ Cycle images on tap
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: CachedNetworkImage(
                      key: ValueKey(imageUrl), // Crucial for AnimatedSwitcher
                      imageUrl: imageUrl,
                      cacheManager: cacheManager,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SpinningCardLoader(),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                    ),
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

class _CardInfo extends StatelessWidget {
  final YgoCard card;
  final Color foregroundColor;

  const _CardInfo({required this.card, required this.foregroundColor});

  String _getMonsterTypeLine() {
    // Format: [Race / Type1 / Type2 ...]
    final List<String> parts = [];
    parts.add(card.race);

    // Add types from typeLine, but filter out "Monster" as it's redundant inside the brackets
    if (card.typeLine != null) {
      for (final t in card.typeLine!) {
        if (t != 'Monster' && t != card.race) {
          parts.add(t);
        }
      }
    } else {
      // Fallback if typeLine is missing: Parse from the 'type' string
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
      child: Row(
        mainAxisAlignment: isXyz ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: List.generate(
          count,
          (index) => Image.asset(
            asset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildSpellTrapIcon() {
    final String race = card.race.toLowerCase();
    String? asset;

    if (race.contains('continuous')) asset = 'assets/images/attributes/continuous.png';
    else if (race.contains('counter')) asset = 'assets/images/attributes/counter.webp';
    else if (race.contains('equip')) asset = 'assets/images/attributes/equip.webp';
    else if (race.contains('field')) asset = 'assets/images/attributes/field.png';
    else if (race.contains('quick-play')) asset = 'assets/images/attributes/quickplay.webp';
    else if (race.contains('ritual')) asset = 'assets/images/attributes/ritual.webp';

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

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMonster = !card.type.toLowerCase().contains('spell') && !card.type.toLowerCase().contains('trap');
    final isLink = card.type.toLowerCase().contains('link');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMonster) _buildLevelStars() else _buildSpellTrapIcon(),
        const SizedBox(height: 8),
        // Description Box that resembles the physical card text area
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: const Color(0xFF8B4513),
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMonster) ...[
                Text(
                  _getMonsterTypeLine(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(color: Color(0xFF8B4513), thickness: 2),
                const SizedBox(height: 6),
              ],
              Text(
                card.desc,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.25,
                  color: Colors.black87,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isMonster && (card.atk != null || card.def != null || card.linkVal != null)) ...[
                const SizedBox(height: 6),
                const Divider(color: Color(0xFF8B4513), thickness: 2),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    isLink 
                      ? 'ATK/ ${card.atk ?? '?'}  LINK-${card.linkVal ?? '?'}'
                      : 'ATK/ ${card.atk ?? '?'}  DEF/ ${card.def ?? '?'}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        _buildBanlistStatus(theme), // ✅ Moved under the box
        const SizedBox(height: 32),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color textColor;

  const _InfoChip({required this.label, this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
