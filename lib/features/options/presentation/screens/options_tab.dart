import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class OptionsTab extends ConsumerWidget {
  const OptionsTab({super.key});

  void _showSyncConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-fetch Card Data?'),
        content: const Text(
          'This will redownload all Yu-Gi-Oh! card data from the server. '
          'It may take a few minutes depending on your internet connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/sync'); // Reuse the initial sync screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('RE-FETCH'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? const Icon(Icons.person, size: 40) : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'Duelist',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('LOGOUT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 8),
                const Text(
                  'DATABASE MANAGEMENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
                  title: const Text('Re-fetch Card Data'),
                  subtitle: const Text('Redownload all card info and sets from the server.'),
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  tileColor: Colors.white.withValues(alpha: 0.05),
                  onTap: () => _showSyncConfirmation(context),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'More settings coming soon...',
                    style: TextStyle(color: Colors.white24, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          // Credits and Version at the bottom
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                Text(
                  'Created by Tsuna2001',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 0.3.2 (Alpha)',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
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
