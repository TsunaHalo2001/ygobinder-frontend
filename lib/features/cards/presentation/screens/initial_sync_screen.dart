import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/core/database/database_provider.dart';

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
        context.go('/collection'); // Navigate to the collection screen after sync
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _error != null ? Icons.cloud_off_rounded : Icons.deck_rounded,
                  size: 80,
                  color: _error != null ? Colors.redAccent : Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),

                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                if (_isSyncing && _error == null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: _progress != null
                        ? LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        )
                        : const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 12),

                  if (_progress != null)
                    Text(
                      '${(_progress! * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startSync,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
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