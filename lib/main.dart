import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/presentation/screens/initial_sync_screen.dart';
import 'package:ygobinder/features/cards/presentation/screens/card_detail_screen.dart';
import 'package:ygobinder/core/presentation/screens/splash_screen.dart';
import 'package:ygobinder/core/presentation/screens/main_shell.dart';
import 'package:ygobinder/features/scanner/presentation/screens/camera_scanner_screen.dart';
import 'package:ygobinder/features/auth/presentation/screens/login_screen.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Detect screen size for adaptive fonts
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isLargeScreen = screenWidth > 600;

    return MaterialApp.router(
      title: 'YGO Binder',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'YuGiOh',
        brightness: Brightness.dark,
        
        // Custom ColorScheme based on your YGO palette
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Pharaoh's Gold
          onPrimary: Color(0xFF1A1A1A), // Obsidian
          secondary: Color(0xFF7E57C2), // Dark Magician
          surface: Color(0xFF0B0C10), // Shadow Void (Main background)
          onSurface: Color(0xFFF0F0F0), // Starlight
          surfaceContainerHighest: Color(0xFF1F2833), // Dark Slate (Cards, etc.)
          onSurfaceVariant: Color(0xFFF0F0F0),
          outline: Color(0xFF45A29E), // Teal/Faint Gold
        ),

        // Applying the adaptive TextTheme
        textTheme: _buildTextTheme(isLargeScreen),
        
        // Themed Card appearance
        cardTheme: CardThemeData(
          color: const Color(0xFF1F2833),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),

        // Themed Input appearance for your search bar
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1F2833),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF45A29E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF333333)),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }

  TextTheme _buildTextTheme(bool isLargeScreen) {
    // Increase base sizes significantly for large screens (from 1.2 to 1.6)
    final double scale = isLargeScreen ? 1.6 : 1.0;
    const double lineHeight = 1.0; // Reduced line height for YGO font
    
    // Subtle shadow to help text pop against varied backgrounds
    final List<Shadow> textShadows = [
      Shadow(
        offset: const Offset(0.5, 0.5),
        blurRadius: 1.0,
        color: Colors.black.withOpacity(0.4),
      ),
    ];

    return TextTheme(
      displayLarge: TextStyle(fontSize: 57 * scale, height: lineHeight, shadows: textShadows),
      displayMedium: TextStyle(fontSize: 45 * scale, height: lineHeight, shadows: textShadows),
      displaySmall: TextStyle(fontSize: 36 * scale, height: lineHeight, shadows: textShadows),
      headlineLarge: TextStyle(fontSize: 32 * scale, height: lineHeight, shadows: textShadows),
      headlineMedium: TextStyle(fontSize: 28 * scale, height: lineHeight, shadows: textShadows),
      headlineSmall: TextStyle(fontSize: 24 * scale, height: lineHeight, shadows: textShadows),
      titleLarge: TextStyle(fontSize: 22 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 14 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16 * scale, height: lineHeight, shadows: textShadows),
      bodyMedium: TextStyle(fontSize: 14 * scale, height: lineHeight, shadows: textShadows),
      bodySmall: TextStyle(fontSize: 12 * scale, height: lineHeight, shadows: textShadows),
      labelLarge: TextStyle(fontSize: 14 * scale, height: lineHeight, shadows: textShadows),
      labelMedium: TextStyle(fontSize: 12 * scale, height: lineHeight, shadows: textShadows),
      labelSmall: TextStyle(fontSize: 11 * scale, height: lineHeight, shadows: textShadows),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Redirection logic can be complex with Riverpod, 
    // for now let's keep it simple and just define the route.
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/sync',
      builder: (context, state) => const InitialSyncScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/card/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CardDetailScreen(cardId: id);
      },
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const CameraScannerScreen(),
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