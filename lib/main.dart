import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ygobinder/firebase_options.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/presentation/screens/initial_sync_screen.dart';
import 'package:ygobinder/features/cards/presentation/screens/card_detail_screen.dart';
import 'package:ygobinder/core/presentation/screens/splash_screen.dart';
import 'package:ygobinder/core/presentation/screens/main_shell.dart';
import 'package:ygobinder/features/scanner/presentation/screens/camera_scanner_screen.dart';
import 'package:ygobinder/features/auth/presentation/screens/login_screen.dart';
import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Guard Firebase initialization: Only run on supported platforms
  // (Android, iOS, macOS, Web). Linux and Windows require additional setup.
  if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
    }
  } else {
    debugPrint('Firebase is not supported on this platform (${Platform.operatingSystem}). Skipping initialization.');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Detect device type using shortestSide (tablets vs phones in portrait/landscape)
    final bool isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return MaterialApp.router(
      title: 'YGOBinder',
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
        textTheme: _buildTextTheme(isTablet),
        
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

  TextTheme _buildTextTheme(bool isTablet) {
    // Scale 1.0 for phones (portrait & landscape), 1.2 for tablet devices
    final double scale = isTablet ? 1.2 : 1.0;
    const double lineHeight = 1.1;
    
    // Subtle shadow to help text pop against varied backgrounds
    final List<Shadow> textShadows = [
      Shadow(
        offset: const Offset(0.5, 0.5),
        blurRadius: 1.0,
        color: Colors.black.withValues(alpha: 0.4),
      ),
    ];

    return TextTheme(
      displayLarge: TextStyle(fontSize: 48 * scale, height: lineHeight, shadows: textShadows),
      displayMedium: TextStyle(fontSize: 40 * scale, height: lineHeight, shadows: textShadows),
      displaySmall: TextStyle(fontSize: 32 * scale, height: lineHeight, shadows: textShadows),
      headlineLarge: TextStyle(fontSize: 28 * scale, height: lineHeight, shadows: textShadows),
      headlineMedium: TextStyle(fontSize: 24 * scale, height: lineHeight, shadows: textShadows),
      headlineSmall: TextStyle(fontSize: 20 * scale, height: lineHeight, shadows: textShadows),
      titleLarge: TextStyle(fontSize: 20 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 17 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 15 * scale, height: lineHeight, shadows: textShadows, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16.5 * scale, height: lineHeight, shadows: textShadows),
      bodyMedium: TextStyle(fontSize: 14.5 * scale, height: lineHeight, shadows: textShadows),
      bodySmall: TextStyle(fontSize: 13 * scale, height: lineHeight, shadows: textShadows),
      labelLarge: TextStyle(fontSize: 14.5 * scale, height: lineHeight, shadows: textShadows),
      labelMedium: TextStyle(fontSize: 13 * scale, height: lineHeight, shadows: textShadows),
      labelSmall: TextStyle(fontSize: 11.5 * scale, height: lineHeight, shadows: textShadows),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Android can launch the app with a content/file URI as the route location
    // when opening a shared .ydk file. Route those to the app shell instead.
    final location = state.uri.toString();
    if (location.startsWith('content://') || location.startsWith('file://')) {
      return '/main';
    }
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