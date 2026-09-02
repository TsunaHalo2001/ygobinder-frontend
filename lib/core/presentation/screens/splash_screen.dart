import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/features/inventory/data/repositories/inventory_sync_repository.dart';
import 'package:ygobinder/features/decks/data/repositories/deck_sync_repository.dart';
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
    _checkStatusAndRoute();
  }

  Future<void> _checkStatusAndRoute() async {
    try {
      debugPrint('SplashScreen: Starting check...');
      await Future.delayed(const Duration(milliseconds: 1500)); 

      // 1. Check Auth
      debugPrint('SplashScreen: Checking Auth...');
      final user = await ref.read(authProvider.future);
      debugPrint('SplashScreen: User is ${user?.uid ?? 'Guest'}');
      
      final db = ref.read(databaseProvider);
      if (user == null) {
        final skipped = await db.getSetting('login_skipped');
        debugPrint('SplashScreen: Login skipped: $skipped');
        if (skipped != 'true') {
          if (mounted) context.go('/login');
          return;
        }
      }

      // ✅ Sync collection from Cloud
      debugPrint('SplashScreen: Starting background sync...');
      final inventorySyncRepo = ref.read(inventorySyncRepositoryProvider);
      final deckSyncRepo = ref.read(deckSyncRepositoryProvider);
      
      if (user != null) {
        Future.wait([
          inventorySyncRepo.fullSync(db),
          deckSyncRepo.fullSync(db),
        ]).catchError((e) {
          debugPrint('Background sync failed: $e');
          return [];
        });
      }

      // 2. Check Database Sync (Global Card Database)
      debugPrint('SplashScreen: Checking Daily Sync...');
      final repo = ref.read(cardRepositoryProvider);
      final needsSync = await repo.needsDailySync();
      debugPrint('SplashScreen: Needs daily sync: $needsSync');

      if (mounted) {
        if (needsSync) {
          context.go('/sync');
        } else {
          context.go('/main');
        }
      }
    } catch (e, stack) {
      debugPrint('SplashScreen CRITICAL ERROR: $e');
      debugPrint(stack.toString());
      // Fallback: try to go to main anyway if database is accessible
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
            // Your App Logo
            Image.asset(
              'assets/images/icon/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
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