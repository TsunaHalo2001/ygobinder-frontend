import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:ygobinder/features/cards/presentation/screens/collection_tab.dart';
import 'package:ygobinder/features/stats/presentation/screens/stats_tab.dart';
import 'package:ygobinder/features/options/presentation/screens/options_tab.dart';
import 'package:ygobinder/features/decks/presentation/screens/deck_tab.dart';
import 'package:ygobinder/features/decks/presentation/providers/deck_file_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    // ✅ Move tab definition inside build to ensure children are rebuilt correctly
    final List<Widget> tabs = [
      const CollectionTab(),
      const StatsTab(),
      const DeckTab(),
      const OptionsTab(),
    ];

    final List<NavigationDestination> bottomDestinations = const [
      NavigationDestination(icon: Icon(Icons.view_module), label: 'Collection'),
      NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
      NavigationDestination(icon: Icon(Icons.grid_view), label: 'Decks'),
      NavigationDestination(icon: Icon(Icons.settings), label: 'Options'),
    ];

    final List<NavigationRailDestination> sideDestinations = const [
      NavigationRailDestination(icon: Icon(Icons.view_module), label: Text('Collection')),
      NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text('Stats')),
      NavigationRailDestination(icon: Icon(Icons.grid_view), label: Text('Decks')),
      NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Options')),
    ];

    // ✅ Auto-switch to Decks tab when a file is loaded
    ref.listen(deckFileContentProvider, (previous, next) {
      if (next.isNotEmpty && !next.startsWith("Error")) {
        setState(() => _currentIndex = 2); // 2 is the index of Decks tab
      }
    });

    final theme = Theme.of(context);

    return DropTarget(
      onDragDone: (detail) {
        setState(() => _dragging = false);
        
        // 1. Try resolving via files (standard plugin behavior)
        if (detail.files.isNotEmpty) {
          String path = detail.files.first.path;
          if (path.startsWith('file://')) {
            path = Uri.parse(path).toFilePath();
          }
          ref.read(deckFileContentProvider.notifier).loadFromPath(path);
          return;
        }

        // 2. Fallback: Parse rawText (useful on Linux when portal resolution fails)
        final rawText = detail.rawText;
        if (rawText != null && rawText.isNotEmpty) {
          final lines = rawText.split('\n');
          for (var line in lines) {
            final trimmed = line.trim();
            if (trimmed.startsWith('file://')) {
              try {
                final path = Uri.parse(trimmed).toFilePath();
                if (path.endsWith('.ydk')) {
                  ref.read(deckFileContentProvider.notifier).loadFromPath(path);
                  return; // Successfully resolved via fallback
                }
              } catch (_) {}
            }
          }
        }

        // 3. If everything failed, show the error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to resolve dropped file. If you are on Linux, try running with GDK_BACKEND=x11 or install xdg-desktop-portal-gtk.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      },
      onDragEntered: (detail) {
        setState(() => _dragging = true);
      },
      onDragExited: (detail) {
        setState(() => _dragging = false);
      },
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWideScreen = constraints.maxWidth >= 600;

              if (isWideScreen) {
                return Scaffold(
                  body: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (index) {
                          setState(() => _currentIndex = index);
                        },
                        destinations: sideDestinations,
                        labelType: constraints.maxWidth >= 800
                            ? null
                            : NavigationRailLabelType.all,
                        extended: constraints.maxWidth >= 800,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: tabs,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Scaffold(
                  body: IndexedStack(
                    index: _currentIndex,
                    children: tabs,
                  ),
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (index) {
                      setState(() => _currentIndex = index);
                    },
                    destinations: bottomDestinations,
                  ),
                );
              }
            },
          ),
          if (_dragging)
            Positioned.fill(
              child: Container(
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.file_download_rounded, size: 80, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        'Drop .ydk file anywhere to load',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
