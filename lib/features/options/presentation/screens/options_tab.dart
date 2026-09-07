import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygobinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:ygobinder/core/database/database_provider.dart';
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/core/providers/currency_provider.dart';
import 'package:ygobinder/features/cards/data/repositories/card_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

bool get _isGoogleSignInSupported =>
    kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

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
                  setDialogState(() {
                    processed = p;
                    total = t;
                    currentSetName = setName;
                  });
                },
                isCancelled: () => isCancelled,
              ).then((_) {
                setDialogState(() {
                  isCompleted = true;
                });
              }).catchError((e) {
                setDialogState(() {
                  errorMessage = e.toString().replaceAll('Exception: ', '');
                });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // Account Section
          if (user != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (user.email != null && user.email!.isNotEmpty)
                    Text(
                      user.email!,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('LOGOUT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  Icon(
                    _isGoogleSignInSupported ? Icons.cloud_off_rounded : Icons.storage_rounded,
                    size: 40,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isGoogleSignInSupported ? 'GUEST MODE' : 'LOCAL MODE',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isGoogleSignInSupported
                        ? 'Sign in to sync your inventory and decks across all your devices.'
                        : 'Your inventory and decks are saved locally on this device.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
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
          const Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.currency_exchange_rounded, color: Colors.amber),
            title: const Text('Currency Conversion'),
            subtitle: const Text('Select preferred display currency for card values.'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            tileColor: Colors.white.withValues(alpha: 0.05),
            onTap: () => _showCurrencySelectorBottomSheet(context),
          ),

          const SizedBox(height: 28),

          // Database Management Section
          const Text(
            'DATABASE MANAGEMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
            title: const Text('Re-fetch Card Data'),
            subtitle: const Text('Redownload all card info and sets from the server.'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            tileColor: Colors.white.withValues(alpha: 0.05),
            onTap: () => _showSyncConfirmation(context),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.price_change_rounded, color: Colors.greenAccent),
            title: const Text('Update owned card prices'),
            subtitle: const Text('Download latest set pricing for sets in your collection (1 set/sec).'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            tileColor: Colors.white.withValues(alpha: 0.05),
            onTap: () => _showUpdateOwnedPricesDialog(context, ref),
          ),

          const SizedBox(height: 32),

          // Legal Disclaimer & Credits Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gavel_rounded, size: 16, color: Colors.white38),
                    SizedBox(width: 8),
                    Text(
                      'LEGAL DISCLAIMER & ATTRIBUTION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'YGOBinder is an unofficial fan-made application and is not affiliated with, endorsed by, or sponsored by Konami Digital Entertainment or Studio Dice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Yu-Gi-Oh! and all related card text, images, and trademarks belong to Studio Dice, SHUEISHA, TV TOKYO, and KONAMI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
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
                  'Version 1.1.0',
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
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.currency_exchange_rounded, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'CURRENCY CONVERSION',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select your preferred currency for card prices and statistics.',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Colors.white10),

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
                            : Colors.white.withValues(alpha: 0.03),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? theme.colorScheme.primary : Colors.white10,
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
                                  color: isSelected ? theme.colorScheme.primary : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                subtitleText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.8) : Colors.white54,
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
                              const Divider(height: 1, color: Colors.white10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Multiplier (1 USD = ):',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
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
