import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/features/inventory/data/repositories/inventory_sync_repository.dart';
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
    await Future.delayed(const Duration(milliseconds: 1500)); // Slightly longer for thematic effect

    // 1. Check Auth
    final user = await ref.read(authProvider.future);
    
    if (user == null) {
      // Check if user previously chose to skip login
      final db = ref.read(databaseProvider);
      final skipped = await db.getSetting('login_skipped');
      
      if (skipped != 'true') {
        if (mounted) context.go('/login');
        return;
      }
    }

    // ✅ Sync collection from Cloud on every startup for multi-device support
    final syncRepo = ref.read(inventorySyncRepositoryProvider);
    final db = ref.read(databaseProvider);
    
    // Only attempt full sync if user is logged in
    if (user != null) {
      await syncRepo.fullSync(db);
    }

    // 2. Check Database Sync (Global Card Database)
    final repo = ref.read(cardRepositoryProvider);

    final needsSync = await repo.needsDailySync();

    if (needsSync) {
      if (mounted) context.go('/sync');
    } else {
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