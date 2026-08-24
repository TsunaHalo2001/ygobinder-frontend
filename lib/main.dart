// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Firebase / Isar here

  runApp(
    const ProviderScope( // Required for Riverpod
      child: MyApp(),
    ),
  );
}