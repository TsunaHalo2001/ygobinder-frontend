import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/core/database/database_provider.dart';

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
    // Give the UI a tiny moment to render the splash screen
    await Future.delayed(const Duration(milliseconds: 500));

    final repo = ref.read(cardRepositoryProvider);
    final db = ref.read(databaseProvider);

    // 1. Check if we need to sync
    final needsSync = await repo.needsDailySync();

    if (needsSync) {
      // Check if DB is completely empty (first time ever)
      final cardCount = await db.getCollectionSize(); // Or a specific card count query

      if (cardCount == 0) {
        // First time ever: Go to full sync
        if (mounted) context.go('/sync');
      } else {
        // Has cards, but needs daily update: Go to background sync or just main app
        // For now, let's just go to collection and sync in background, or force sync.
        // Let's force sync for simplicity:
        if (mounted) context.go('/sync');
      }
    } else {
      // Already synced today! Skip download completely.
      if (mounted) context.go('/collection');
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
            const CircularProgressIndicator(),
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