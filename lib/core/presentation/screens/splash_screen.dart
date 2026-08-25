import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/core/database/database_provider.dart';

import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkDatabaseAndRoute();
  }

  Future<void> _checkDatabaseAndRoute() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final repo = ref.read(cardRepositoryProvider);
    final db = ref.read(databaseProvider);

    final needsSync = await repo.needsDailySync();

    if (needsSync) {
      final cardCount = await db.getCollectionSize();

      if (cardCount == 0) {
        // First time ever: Go to full sync
        if (mounted) context.go('/sync');
      } else {
        // Has cards, but needs daily update: Go to sync
        if (mounted) context.go('/sync');
      }
    } else {
      // ✅ CHANGED: Already synced today! Go straight to the Main Shell
      if (mounted) context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your App Logo or Icon
            Icon(Icons.deck_rounded, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            const SpinningCardLoader(width: 60, height: 84),
            const SizedBox(height: 16),
            Text(
              'Loading YGO Binder...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}