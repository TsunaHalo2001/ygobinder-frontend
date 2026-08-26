import 'package:flutter/material.dart';
import 'package:ygobinder/features/cards/presentation/screens/collection_tab.dart';
import 'package:ygobinder/features/stats/presentation/screens/stats_tab.dart';
import 'package:ygobinder/features/options/presentation/screens/options_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // The actual screens for each tab - Options moved to the end
  final List<Widget> _tabs = const [
    CollectionTab(),
    StatsTab(),
    Center(child: Text('Deck Builder (Coming Soon)', style: TextStyle(fontSize: 24))),
    OptionsTab(),
  ];

  // Destinations for Bottom Navigation (Phone)
  final List<NavigationDestination> _bottomDestinations = const [
    NavigationDestination(icon: Icon(Icons.view_module), label: 'Collection'),
    NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
    NavigationDestination(icon: Icon(Icons.grid_view), label: 'Decks'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Options'),
  ];

  // Destinations for Side Navigation (Tablet/Desktop)
  final List<NavigationRailDestination> _sideDestinations = const [
    NavigationRailDestination(icon: Icon(Icons.view_module), label: Text('Collection')),
    NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text('Stats')),
    NavigationRailDestination(icon: Icon(Icons.grid_view), label: Text('Decks')),
    NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Options')),
  ];

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder gives us the constraints (width/height) of the available space
    return LayoutBuilder(
      builder: (context, constraints) {
        // 600px is the standard Material Design breakpoint for tablets
        final bool isWideScreen = constraints.maxWidth >= 600;

        if (isWideScreen) {
          // ==========================================
          // WIDE SCREEN: Side Navigation (NavigationRail)
          // ==========================================
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  destinations: _sideDestinations,
                  // ✅ FIXED: Only set labelType when NOT extended
                  labelType: constraints.maxWidth >= 800
                      ? null  // Extended mode shows labels automatically
                      : NavigationRailLabelType.all, // Compact mode needs explicit labelType
                  extended: constraints.maxWidth >= 800,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                const VerticalDivider(thickness: 1, width: 1), // Separator line
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _tabs,
                  ),
                ),
              ],
            ),
          );
        } else {
          // ==========================================
          // NARROW SCREEN: Bottom Navigation (NavigationBar)
          // ==========================================
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: _bottomDestinations,
            ),
          );
        }
      },
    );
  }
}