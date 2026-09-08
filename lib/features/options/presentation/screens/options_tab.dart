import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/currency_provider.dart';
import 'package:ygobinder/core/providers/theme_provider.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:ygobinder/features/cards/data/services/card_data_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

bool get _isGoogleSignInSupported =>
    kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

final appVersionCheckProvider = FutureProvider.autoDispose<String?>((ref) async {
  final dataService = CardDataService();
  return dataService.fetchCacheVersion();
});

bool isAppVersionOlder(String appVersion, String serverVersion) {
  try {
    int getBuildNumber(String v) {
      if (v.contains('+')) {
        final parts = v.split('+');
        return int.tryParse(parts.last) ?? 0;
      }
      return 0;
    }

    final appBuild = getBuildNumber(appVersion);
    final serverBuild = getBuildNumber(serverVersion);

    if (appBuild > 0 && serverBuild > 0) {
      return appBuild < serverBuild;
    }

    final appSem = appVersion.split('+').first.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final serverSem = serverVersion.split('+').first.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (var i = 0; i < 3; i++) {
      final a = i < appSem.length ? appSem[i] : 0;
      final s = i < serverSem.length ? serverSem[i] : 0;
      if (a < s) return true;
      if (a > s) return false;
    }
  } catch (e) {
    debugPrint('Error comparing versions: $e');
  }
  return false;
}

class OptionsTab extends ConsumerWidget {
  const OptionsTab({super.key});

  void _showSyncConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-fetch Card Data?'),
        content: const Text(
          'This will redownload all Yu-Gi-Oh! card data from the server. '
          'It may take a few minutes depending on your internet connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/sync'); // Reuse the initial sync screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('RE-FETCH'),
          ),
        ],
      ),
    );
  }

  void _showClearQuoteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Quote Collection (#0)?'),
        content: const Text(
          'Are you sure you want to delete all temporary quoted cards from Collection #0? '
          'Your real collection items will remain untouched.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final repo = ref.read(cardRepositoryProvider);
                final count = await repo.clearQuoteCollection();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cleared $count quote items from Collection #0')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error clearing quote collection: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }

  void _showUpdateOwnedPricesDialog(BuildContext context, WidgetRef ref) {
    var processed = 0;
    var total = 0;
    var currentSetName = 'Initializing...';
    var isCancelled = false;
    var isCompleted = false;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (processed == 0 && !isCancelled && errorMessage == null && !isCompleted) {
              final repo = ref.read(cardRepositoryProvider);
              repo.updateOwnedSetCardPrices(
                onProgress: (p, t, setName) {
                  if (context.mounted) {
                    setDialogState(() {
                      processed = p;
                      total = t;
                      currentSetName = setName;
                    });
                  }
                },
                isCancelled: () => isCancelled,
              ).then((_) {
                if (context.mounted) {
                  setDialogState(() {
                    isCompleted = true;
                  });
                }
              }).catchError((e) {
                if (context.mounted) {
                  setDialogState(() {
                    errorMessage = e.toString().replaceAll('Exception: ', '');
                  });
                }
              });
            }

            final progressRatio = total > 0 ? (processed / total).clamp(0.0, 1.0) : 0.0;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : (errorMessage != null ? Icons.error_rounded : Icons.price_change_rounded),
                    color: isCompleted
                        ? Colors.greenAccent
                        : (errorMessage != null ? Colors.redAccent : Colors.amber),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isCompleted
                          ? 'Prices Updated!'
                          : (errorMessage != null ? 'Update Failed' : 'Updating Prices...'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    )
                  else if (isCompleted)
                    Text(
                      'Successfully updated prices for $total owned sets!',
                      style: const TextStyle(fontSize: 13),
                    )
                  else ...[
                    Text(
                      'Processing set $processed of $total',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentSetName,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progressRatio,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation(Colors.amber),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ],
              ),
              actions: [
                if (!isCompleted && errorMessage == null)
                  TextButton(
                    onPressed: () {
                      isCancelled = true;
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CLOSE'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final theme = Theme.of(context);
    final versionAsync = ref.watch(appVersionCheckProvider);
    const String currentAppVersion = '1.4.0+17';

    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // App Update Notification Banner
          versionAsync.when(
            data: (serverVersion) {
              if (serverVersion != null && isAppVersionOlder(currentAppVersion, serverVersion)) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.system_update_rounded, color: Colors.amber, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Update your App',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // Account Section
          if (user != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? const Icon(Icons.person, size: 36) : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.displayName ?? 'Duelist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  if (user.email != null && user.email!.isNotEmpty)
                    Text(
                      user.email!,
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: theme.brightness == Brightness.dark ? Colors.redAccent : Colors.red.shade800,
                    ),
                    label: Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: theme.brightness == Brightness.dark ? Colors.redAccent : Colors.red.shade800,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.brightness == Brightness.dark ? Colors.redAccent : Colors.red.shade800,
                      side: BorderSide(
                        color: theme.brightness == Brightness.dark ? Colors.redAccent : Colors.red.shade800,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    _isGoogleSignInSupported ? Icons.cloud_off_rounded : Icons.storage_rounded,
                    size: 40,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isGoogleSignInSupported ? 'GUEST MODE' : 'LOCAL MODE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isGoogleSignInSupported
                        ? 'Sign in to sync your inventory and decks across all your devices.'
                        : 'Your inventory and decks are saved locally on this device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
                  ),
                  if (_isGoogleSignInSupported) ...[
                    const SizedBox(height: 16),
                    if (authState.isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).signInWithGoogle();
                          if (context.mounted && ref.read(authProvider).value != null) {
                            context.go('/splash');
                          }
                        },
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                          height: 18,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
                        ),
                        label: const Text('SIGN IN WITH GOOGLE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 28),

          // Preferences Section
          Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.currency_exchange_rounded, color: Colors.amber),
            title: const Text('Currency Conversion'),
            subtitle: Text('Select preferred display currency for card values.', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            onTap: () => _showCurrencySelectorBottomSheet(context),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.brightness_medium_rounded, color: Colors.purpleAccent),
            title: const Text('App Theme'),
            subtitle: Text('Select Light, Dark, or System Default theme.', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            onTap: () => _showThemeSelectorBottomSheet(context),
          ),

          const SizedBox(height: 28),

          // Database Management Section
          Text(
            'DATABASE MANAGEMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
            title: const Text('Re-fetch Card Data'),
            subtitle: Text('Redownload all card info and sets from the server.', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            onTap: () => _showSyncConfirmation(context),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.price_change_rounded, color: Colors.greenAccent),
            title: const Text('Update owned card prices'),
            subtitle: Text('Download latest set pricing for sets in your collection (1 set/sec).', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            onTap: () => _showUpdateOwnedPricesDialog(context, ref),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.delete_sweep_rounded, color: Colors.orangeAccent),
            title: const Text('Clear Quote Collection (#0)'),
            subtitle: Text('Remove all temporary quote items from Collection #0.', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            onTap: () => _showClearQuoteConfirmation(context, ref),
          ),

          const SizedBox(height: 32),

          // Legal Disclaimer & Credits Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gavel_rounded, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                    const SizedBox(width: 8),
                    Text(
                      'LEGAL DISCLAIMER & ATTRIBUTION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'YGOBinder is an unofficial fan-made application and is not affiliated with, endorsed by, or sponsored by Konami Digital Entertainment or Studio Dice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yu-Gi-Oh! and all related card text, images, and trademarks belong to Studio Dice, SHUEISHA, TV TOKYO, and KONAMI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.api_rounded, size: 14, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    const Text(
                      'Card data, prices & sets powered by ',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    InkWell(
                      onTap: () async {
                        final uri = Uri.parse('https://ygoprodeck.com');
                        try {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          debugPrint('Could not launch URL: $e');
                        }
                      },
                      child: const Text(
                        'YGOPRODeck',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(' & ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    InkWell(
                      onTap: () async {
                        final uri = Uri.parse('https://openapi.tcgtracking.com');
                        try {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          debugPrint('Could not launch URL: $e');
                        }
                      },
                      child: const Text(
                        'TCGTracking API',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  'Created by Tsuna2001',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.4.0',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('https://ko-fi.com/tsunas200121679');
                    try {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      debugPrint('Could not launch URL: $e');
                    }
                  },
                  icon: const Icon(Icons.coffee_rounded, color: Color(0xFF22C55E), size: 18),
                  label: const Text('Support on Ko-fi', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF22C55E),
                    side: const BorderSide(color: Color(0xFF22C55E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

void _showCurrencySelectorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _CurrencySelectorBottomSheet(),
  );
}

class _CurrencySelectorBottomSheet extends ConsumerStatefulWidget {
  const _CurrencySelectorBottomSheet();

  @override
  ConsumerState<_CurrencySelectorBottomSheet> createState() => _CurrencySelectorBottomSheetState();
}

class _CurrencySelectorBottomSheetState extends ConsumerState<_CurrencySelectorBottomSheet> {
  late TextEditingController _customRateController;

  static const _currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'United States Dollar', 'flag': '🇺🇸'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound Sterling', 'flag': '🇬🇧'},
    {'code': 'MXN', 'symbol': '\$', 'name': 'Mexican Peso', 'flag': '🇲🇽'},
    {'code': 'CAD', 'symbol': '\$', 'name': 'Canadian Dollar', 'flag': '🇨🇦'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
    {'code': 'BRL', 'symbol': 'R\$', 'name': 'Brazilian Real', 'flag': '🇧🇷'},
    {'code': 'ARS', 'symbol': '\$', 'name': 'Argentine Peso', 'flag': '🇦🇷'},
    {'code': 'CLP', 'symbol': '\$', 'name': 'Chilean Peso', 'flag': '🇨🇱'},
    {'code': 'PEN', 'symbol': 'S/', 'name': 'Peruvian Sol', 'flag': '🇵🇪'},
    {'code': 'COP', 'symbol': '\$', 'name': 'Colombian Peso', 'flag': '🇨🇴'},
    {'code': 'CUSTOM', 'symbol': '\$', 'name': 'Custom Rate Multiplier', 'flag': '🛠️'},
  ];

  @override
  void initState() {
    super.initState();
    _customRateController = TextEditingController(
      text: ref.read(customCurrencyRateProvider).toString(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardRepositoryProvider).syncCurrencyRatesIfNeeded();
    });
  }

  @override
  void dispose() {
    _customRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.65,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.currency_exchange_rounded, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'CURRENCY CONVERSION',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2, color: theme.colorScheme.onSurface),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, size: 20, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select your preferred currency for card prices and statistics.',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),

          // Stream of exchange rates
          Expanded(
            child: StreamBuilder<List<DriftCurrencyRate>>(
              stream: db.watchAllCurrencyRates(),
              builder: (context, snapshot) {
                final ratesList = snapshot.data ?? [];
                final rateMap = <String, double>{};
                for (final r in ratesList) {
                  rateMap[r.currencyCode.toUpperCase()] = r.rateToUsd;
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _currencies.length,
                  itemBuilder: (context, index) {
                    final curr = _currencies[index];
                    final code = curr['code']!;
                    final symbol = curr['symbol']!;
                    final name = curr['name']!;
                    final flag = curr['flag']!;
                    final isSelected = selectedCurrency == code;
                    final isCustom = code == 'CUSTOM';
                    final customRateVal = ref.watch(customCurrencyRateProvider);
                    final rate = rateMap[code.toUpperCase()];

                    String subtitleText;
                    if (code == 'USD') {
                      subtitleText = '1 USD = \$1.00 USD (Base)';
                    } else if (isCustom) {
                      subtitleText = 'Multiplier: ${customRateVal}x USD';
                    } else if (rate != null) {
                      subtitleText = '1 USD = $symbol${rate.toStringAsFixed(2)} $code';
                    } else {
                      subtitleText = 'Symbol: $symbol';
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(flag, style: const TextStyle(fontSize: 24)),
                              title: Text(
                                '$name ($code)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                subtitleText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.8) : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              trailing: Radio<String>(
                                value: code,
                                groupValue: selectedCurrency,
                                activeColor: theme.colorScheme.primary,
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(selectedCurrencyProvider.notifier).setCurrency(val);
                                  }
                                },
                              ),
                              onTap: () {
                                ref.read(selectedCurrencyProvider.notifier).setCurrency(code);
                              },
                            ),
                            if (isSelected && isCustom) ...[
                              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Multiplier (1 USD = ):',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _customRateController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'e.g. 20.5',
                                          prefixText: '\$ ',
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onChanged: (val) {
                                          final parsed = double.tryParse(val);
                                          if (parsed != null && parsed > 0) {
                                            ref.read(customCurrencyRateProvider.notifier).setRate(parsed);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showThemeSelectorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ThemeSelectorBottomSheet(),
  );
}

class _ThemeSelectorBottomSheet extends ConsumerWidget {
  const _ThemeSelectorBottomSheet();

  static const _themes = [
    {
      'mode': ThemeMode.system,
      'name': 'System Default',
      'desc': 'Follow device system theme settings',
      'icon': Icons.brightness_auto_rounded,
      'color': Colors.blueAccent,
    },
    {
      'mode': ThemeMode.light,
      'name': 'Light Mode',
      'desc': 'Bright and clean light appearance',
      'icon': Icons.light_mode_rounded,
      'color': Colors.amber,
    },
    {
      'mode': ThemeMode.dark,
      'name': 'Dark Mode',
      'desc': 'Pharaoh & Shadow Void dark appearance',
      'icon': Icons.dark_mode_rounded,
      'color': Colors.purpleAccent,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentMode = ref.watch(themeModeProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(Icons.palette_rounded, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'APP THEME',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2, color: theme.colorScheme.onSurface),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, size: 20, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose your preferred visual appearance for YGOBinder.',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
          const SizedBox(height: 12),

          // Theme Options List
          ..._themes.map((opt) {
            final mode = opt['mode'] as ThemeMode;
            final name = opt['name'] as String;
            final desc = opt['desc'] as String;
            final icon = opt['icon'] as IconData;
            final color = opt['color'] as Color;
            final isSelected = currentMode == mode;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.12)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(icon, color: color, size: 26),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(desc, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  trailing: Radio<ThemeMode>(
                    value: mode,
                    groupValue: currentMode,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(val);
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
