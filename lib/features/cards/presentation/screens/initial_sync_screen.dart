import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/core/database/database_provider.dart';

import 'package:ygobinder/core/presentation/widgets/spinning_card.dart';

class InitialSyncScreen extends ConsumerStatefulWidget {
  const InitialSyncScreen({super.key});

  @override
  ConsumerState<InitialSyncScreen> createState() => _InitialSyncScreenState();
}

class _InitialSyncScreenState extends ConsumerState<InitialSyncScreen> {
  String _status = 'Initializing...';
  double? _progress;
  String? _error;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSync());
  }

  Future<void> _startSync() async {
    setState(() {
      _isSyncing = true;
      _error = null;
      _status = 'Connecting to Server...';
      _progress = 0.0;
    });

    try {
      final repo = ref.read(cardRepositoryProvider);

      await repo.syncAllCards(
        onStatusChange: (status, progress) {
          setState(() {
            _status = status;
            _progress = progress;
          });
        },
      );

      if (mounted) {
        context.go('/main'); // Navigate to the collection screen after sync
      }
    }
    catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _isSyncing = false;
          _progress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. The Visual (Logo or Spinning Card)
                if (_error != null)
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/icon/logo.png',
                      width: 120,
                      height: 120,
                      color: Colors.redAccent,
                      colorBlendMode: BlendMode.modulate,
                    ),
                  )
                else
                // ✅ REPLACED: Use the Spinning Card instead of a static icon or generic spinner
                  const SpinningCardLoader(width: 60, height: 84),

                const SizedBox(height: 32),

                // 2. Status Text
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Progress Area
                if (_isSyncing && _error == null) ...[
                  SizedBox(
                    width: 300,
                    child: _progress != null
                        ? Column(
                      children: [
                        // Linear bar for downloading
                        LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 12),
                        // Percentage text
                        Text(
                          '${(_progress! * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                    // ✅ REPLACED: If we don't have a percentage (Parsing/Saving),
                    // we just show a subtle text telling them it's working in the background.
                        : Text(
                      'Working in the background...',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                // 4. Error State & Retry Button
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startSync,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}