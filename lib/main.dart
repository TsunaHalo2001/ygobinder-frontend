/*// lib/main.dart
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
}*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _testDatabase();
  }

  Future<void> _testDatabase() async {
    try {
      final db = ref.read(databaseProvider);
      final repo = CardRepository(db);

      // Create a test card
      final testCard = YgoCard(
        id: 89631139, // Blue-Eyes White Dragon
        name: 'Blue-Eyes White Dragon',
        type: 'Monster',
        desc: 'This legendary dragon is a powerful engine of destruction.',
        race: 'Dragon',
        ygoProDeckUrl: 'https://ygoprodeck.com/card/blue-eyes-white-dragon',
        cardImages: [
          CardImage(
            id: 89631139,
            imageUrl: 'https://images.ygoprodeck.com/card_images/89631139.jpg',
            imageUrlSmall: 'https://images.ygoprodeck.com/card_images_small/89631139.jpg',
            imageUrlCropped: 'https://images.ygoprodeck.com/card_images_cropped/89631139.jpg',
          ),
        ],
        cardPrices: [
          CardPrice(cardMarketPrice: 25.50),
        ],
      );

      // Save it
      await repo.saveCards([testCard]);

      // Read it back
      final loaded = await repo.getCardWithDetails(89631139);

      setState(() {
        _status = '✅ Database works!\nLoaded: ${loaded?.name}';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}