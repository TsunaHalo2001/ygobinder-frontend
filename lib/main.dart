import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/presentation/screens/initial_sync_screen.dart';
import 'package:ygobinder/core/presentation/screens/splash_screen.dart';
import 'package:ygobinder/core/presentation/screens/main_shell.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';
// import 'package:ygobinder/features/collection/presentation/screens/collection_screen.dart'; // Your main screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Detect screen size
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isLargeScreen = screenWidth > 600;

    return MaterialApp.router(
      title: 'YGO Binder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'YuGiOh',
        // 2. Apply dynamic TextTheme
        textTheme: _buildTextTheme(isLargeScreen),
      ),
      routerConfig: _router,
    );
  }

  TextTheme _buildTextTheme(bool isLargeScreen) {
    // Increase base sizes by ~20% for large screens
    final double scale = isLargeScreen ? 1.2 : 1.0;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 57 * scale),
      displayMedium: TextStyle(fontSize: 45 * scale),
      displaySmall: TextStyle(fontSize: 36 * scale),
      headlineLarge: TextStyle(fontSize: 32 * scale),
      headlineMedium: TextStyle(fontSize: 28 * scale),
      headlineSmall: TextStyle(fontSize: 24 * scale),
      titleLarge: TextStyle(fontSize: 22 * scale),
      titleMedium: TextStyle(fontSize: 16 * scale),
      titleSmall: TextStyle(fontSize: 14 * scale),
      bodyLarge: TextStyle(fontSize: 16 * scale),
      bodyMedium: TextStyle(fontSize: 14 * scale),
      bodySmall: TextStyle(fontSize: 12 * scale),
      labelLarge: TextStyle(fontSize: 14 * scale),
      labelMedium: TextStyle(fontSize: 12 * scale),
      labelSmall: TextStyle(fontSize: 11 * scale),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash', // ← Start here
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sync',
      builder: (context, state) => const InitialSyncScreen(),
    ),
    GoRoute(
      path: '/collection',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Main Collection Screen')),
      ),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainShell(), // <-- Change this
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
            body: Center(child: SpinningCardLoader()),
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
          body: Center(child: SpinningCardLoader()),
        );
      },
    );
  }
}