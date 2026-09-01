// lib/app.dart
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isLargeScreen = screenWidth > 600;

    return MaterialApp(
      title: 'YGO Inventory',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'YuGiOh',
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          onPrimary: Color(0xFF1A1A1A),
          secondary: Color(0xFF7E57C2),
          surface: Color(0xFF0B0C10), // Shadow Void
          onSurface: Color(0xFFF0F0F0),
          surfaceContainerHighest: Color(0xFF1F2833), // Dark Slate
          outline: Color(0xFF45A29E),
        ),
        textTheme: _buildTextTheme(isLargeScreen),
        cardTheme: CardThemeData(
          color: const Color(0xFF1F2833),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // TODO: Add GoRouter here later
      home: const Scaffold(
        body: Center(child: Text('Folder structure is ready!')),
      ),
    );
  }

  TextTheme _buildTextTheme(bool isLargeScreen) {
    final double scale = isLargeScreen ? 1.6 : 1.0;
    const double lineHeight = 1.0;
    final List<Shadow> textShadows = [
      Shadow(
        offset: const Offset(0.5, 0.5),
        blurRadius: 1.0,
        color: Colors.black.withValues(alpha: 0.4),
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
