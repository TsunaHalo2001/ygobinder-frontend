import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ygobinder/features/stats/presentation/providers/stats_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/core/providers/image_cache_provider.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalCardsAsync = ref.watch(totalCardsCountProvider);
    final uniqueCardsAsync = ref.watch(uniqueCardsCountProvider);
    final newestCardAsync = ref.watch(newestCardProvider);
    final oldestCardAsync = ref.watch(oldestCardProvider);
    final topSetsAsync = ref.watch(topSetsProvider);
    final topCardsAsync = ref.watch(topCardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('STATISTICS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatCard(
              label: 'Total Cards',
              value: totalCardsAsync.when(
                data: (count) => count.toString(),
                loading: () => '...',
                error: (_, _) => 'Error',
              ),
              icon: Icons.copy_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            _StatCard(
              label: 'Unique Cards',
              value: uniqueCardsAsync.when(
                data: (count) => count.toString(),
                loading: () => '...',
                error: (_, _) => 'Error',
              ),
              icon: Icons.style_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            _CardDateStatCard(
              label: 'Newest Card Owned',
              cardAsync: newestCardAsync,
              icon: Icons.auto_awesome_rounded,
              color: Colors.tealAccent,
            ),
            const SizedBox(height: 16),
            _CardDateStatCard(
              label: 'Oldest Card Owned',
              cardAsync: oldestCardAsync,
              icon: Icons.history_edu_rounded,
              color: Colors.amber,
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'TOP 5 SETS'),
            const SizedBox(height: 16),
            topSetsAsync.when(
              data: (sets) {
                if (sets.isEmpty) return const Center(child: Text('No sets found'));
                
                return SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 10),
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true, header: ''),
                    series: <CartesianSeries<SetStat, String>>[
                      BarSeries<SetStat, String>(
                        dataSource: sets.reversed.toList(),
                        xValueMapper: (SetStat data, _) => data.setName,
                        yValueMapper: (SetStat data, _) => data.count,
                        name: 'Cards',
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          labelAlignment: ChartDataLabelAlignment.outer,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'TOP 5 CARDS'),
            const SizedBox(height: 16),
            topCardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) return const Center(child: Text('No cards found'));
                
                return SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 10),
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true, header: ''),
                    series: <CartesianSeries<CardStat, String>>[
                      BarSeries<CardStat, String>(
                        dataSource: cards.reversed.toList(),
                        xValueMapper: (CardStat data, _) => data.cardName,
                        yValueMapper: (CardStat data, _) => data.count,
                        name: 'Copies',
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Colors.orangeAccent,
                          ],
                        ),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          labelAlignment: ChartDataLabelAlignment.outer,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardDateStatCard extends ConsumerWidget {
  final String label;
  final AsyncValue<YgoCard?> cardAsync;
  final IconData icon;
  final Color color;

  const _CardDateStatCard({
    required this.label,
    required this.cardAsync,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(imageCacheManagerProvider);

    return cardAsync.when(
      data: (card) {
        final imageUrl = card?.cardImages?.firstOrNull?.imageUrlCropped ??
            card?.cardImages?.firstOrNull?.imageUrlSmall ??
            '';

        String dateString = 'N/A';
        if (card != null) {
          final tcgDate = card.miscInfo?.firstOrNull?.tcgDate;
          if (tcgDate != null && tcgDate.isNotEmpty) {
            dateString = tcgDate;
          }
        }

        return Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: InkWell(
            onTap: card != null ? () => context.push('/card/${card.id}') : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (card != null && imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 44,
                        height: 64,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                          memCacheWidth: 120,
                          placeholder: (context, url) => Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Icon(icon, color: color, size: 28),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color.withValues(alpha: 0.8),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card?.name ?? 'No cards in collection',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (card != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Released: $dateString',
                            style: const TextStyle(fontSize: 12, color: Colors.white60),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (card != null)
                    const Icon(Icons.chevron_right_rounded, color: Colors.white38),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
      ),
    );
  }
}
