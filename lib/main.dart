import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/presentation/screens/initial_sync_screen.dart';
// import 'package:ygobinder/features/collection/presentation/screens/collection_screen.dart'; // Your main screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YGO Binder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// Simple GoRouter setup
final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const InitializationScreen(),
    ),
    GoRoute(
      path: '/sync',
      builder: (context, state) => const InitialSyncScreen(),
    ),
    GoRoute(
      path: '/collection',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Main Collection Screen Goes Here!')),
      ),
    ),
  ],
);

/// This screen checks the database and routes accordingly
class InitializationScreen extends ConsumerWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use FutureBuilder to check the DB count without blocking the UI thread
    return FutureBuilder<int>(
      future: ref.read(databaseProvider).getCollectionSize(), // Or a specific getCardCount() method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If we have cards, go to collection. If not, go to sync.
        final hasCards = (snapshot.data ?? 0) > 0;

        // Use addPostFrameCallback to navigate after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasCards) {
            context.go('/collection');
          } else {
            context.go('/sync');
          }
        });

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}