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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'YuGiOh',
        textTheme: _buildTextTheme(isLargeScreen),
      ),
      // TODO: Add GoRouter here later
      home: const Scaffold(
        body: Center(child: Text('Folder structure is ready!')),
      ),
    );
  }

  TextTheme _buildTextTheme(bool isLargeScreen) {
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
