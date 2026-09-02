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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // Account Section
          if (user != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? const Icon(Icons.person, size: 36) : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.displayName ?? 'Duelist',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (user.email != null && user.email!.isNotEmpty)
                    Text(
                      user.email!,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('LOGOUT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 40, color: Colors.white24),
                  const SizedBox(height: 12),
                  const Text(
                    'GUEST MODE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to sync your inventory and decks across all your devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  if (authState.isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).signInWithGoogle();
                        if (context.mounted && ref.read(authProvider).value != null) {
                          context.go('/splash');
                        }
                      },
                      icon: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                        height: 18,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
                      ),
                      label: const Text('SIGN IN WITH GOOGLE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 28),

          // Database Management Section
          const Text(
            'DATABASE MANAGEMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
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

          const SizedBox(height: 32),

          // Footer / Credits
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'Created by Tsuna2001',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 0.3.4 (Alpha)',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
