import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_calc_app/providers/settings_provider.dart';
import 'package:money_calc_app/providers/safe_provider.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class SafePage extends StatefulWidget {
  const SafePage({super.key});

  @override
  State<SafePage> createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  // Store controllers for each denomination
  final Map<double, TextEditingController> _controllers = {};
  String? _currentCurrency;

  // Define denominations for supported currencies (same as HomePage)
  static const Map<String, List<double>> _currencyDenominations = {
    'TRY': [200, 100, 50, 20, 10, 5, 1, 0.5, 0.25, 0.1, 0.05],
    'USD': [100, 50, 20, 10, 5, 2, 1, 0.5, 0.25, 0.1, 0.05, 0.01],
    'EUR': [
      500,
      200,
      100,
      50,
      20,
      10,
      5,
      2,
      1,
      0.50,
      0.20,
      0.10,
      0.05,
      0.02,
      0.01,
    ],
  };

  List<double> _getDenominations(String currency) {
    return _currencyDenominations[currency] ?? _currencyDenominations['TRY']!;
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateControllers(String currency, SafeProvider safeProvider) {
    if (_currentCurrency != currency) {
      // Clear old controllers
      for (var controller in _controllers.values) {
        controller.dispose();
      }
      _controllers.clear();

      // Initialize new controllers with values from SafeProvider
      final denoms = _getDenominations(currency);
      for (var denom in denoms) {
        final count = safeProvider.getCount(currency, denom.toString());
        _controllers[denom] = TextEditingController(
          text: count > 0 ? count.toString() : '',
        );
      }

      _currentCurrency = currency;
    }
  }

  void _onQuantityChanged(
    String currency,
    double denom,
    String value,
    SafeProvider safeProvider,
  ) {
    final count = int.tryParse(value) ?? 0;
    safeProvider.updateCount(currency, denom.toString(), count);
  }

  String _formatDenominationLabel(double denom, String currency) {
    if (denom >= 1) {
      return '${_getCurrencySymbol(currency)}${denom.toStringAsFixed(0)}';
    } else {
      if (currency == 'TRY') {
        final kurus = (denom * 100).round();
        return '${kurus}Kr';
      } else {
        return '${_getCurrencySymbol(currency)}${denom.toStringAsFixed(2)}';
      }
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final safeProvider = Provider.of<SafeProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    // Ensure controllers are set up for the current currency
    // We need to do this carefully to avoid resetting user input while typing if provider updates
    // But here the provider IS the source of truth.
    // Ideally, we only init controllers once per currency switch.
    if (safeProvider.isLoaded && _currentCurrency != settings.currency) {
      _updateControllers(settings.currency, safeProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.safe),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: localizations.resetSafe,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.resetSafe),
                  content: Text(localizations.confirmResetSafe),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(localizations.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        safeProvider.clearCurrencyInventory(settings.currency);
                        // Clear all controllers to reflect the change immediately
                        for (var controller in _controllers.values) {
                          controller.clear();
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        localizations.confirm,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: safeProvider.isLoaded
          ? _buildSafeBody(context, settings, safeProvider, localizations)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSafeBody(
    BuildContext context,
    SettingsProvider settings,
    SafeProvider safeProvider,
    AppLocalizations localizations,
  ) {
    final denominations = _getDenominations(settings.currency);
    final total = safeProvider.getTotal(settings.currency);

    return Column(
      children: [
        // Total display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  localizations.total.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_getCurrencySymbol(settings.currency)}${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Scrollable list of denominations
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: denominations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final denom = denominations[index];
              // We use the controller if it exists, otherwise create one (should exist from _updateControllers)
              if (!_controllers.containsKey(denom)) {
                final count = safeProvider.getCount(
                  settings.currency,
                  denom.toString(),
                );
                _controllers[denom] = TextEditingController(
                  text: count > 0 ? count.toString() : '',
                );
              }
              final controller = _controllers[denom]!;

              // Calculate subtotal for this row
              final quantity = safeProvider.getCount(
                settings.currency,
                denom.toString(),
              );
              final subtotal = denom * quantity;

              // Sync controller text if it differs from provider (e.g. initial load or external update)
              // But avoid doing it if the user is typing (focus check?)
              // For simplicity, we initialized them in _updateControllers.
              // If we want real-time sync from other sources, we'd need more complex logic.
              // Here, this page is the only editor, so it's fine.

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Denomination Label
                    Container(
                      width: 70,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatDenominationLabel(denom, settings.currency),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Quantity Input
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(
                                context,
                              ).inputDecorationTheme.fillColor ??
                              Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => _onQuantityChanged(
                          settings.currency,
                          denom,
                          value,
                          safeProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Subtotal Display
                    SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.total,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${_getCurrencySymbol(settings.currency)}${subtotal.toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
