import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_calc_app/providers/settings_provider.dart';
import 'package:money_calc_app/providers/safe_provider.dart';
import 'package:money_calc_app/providers/history_provider.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';
import 'package:money_calc_app/widgets/app_drawer.dart';
import 'package:money_calc_app/widgets/denomination_list.dart';
import 'package:money_calc_app/widgets/total_display.dart';

class BankDepositPage extends StatefulWidget {
  const BankDepositPage({super.key});

  @override
  State<BankDepositPage> createState() => _BankDepositPageState();
}

class _BankDepositPageState extends State<BankDepositPage> {
  double _total = 0.0;
  final Map<double, TextEditingController> _controllers = {};
  String? _currentCurrency;

  // Define denominations for supported currencies
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context);
    if (_currentCurrency != settings.currency) {
      _updateControllers(settings.currency);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateControllers(String currency) {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();

    final denoms = _getDenominations(currency);
    for (var denom in denoms) {
      _controllers[denom] = TextEditingController();
    }

    _currentCurrency = currency;
    _total = 0.0;
  }

  void _calculateTotal() {
    double newTotal = 0.0;
    _controllers.forEach((denom, controller) {
      final quantity = double.tryParse(controller.text) ?? 0.0;
      newTotal += denom * quantity;
    });

    setState(() {
      _total = newTotal;
    });
  }

  void _resetTotal() {
    _controllers.forEach((_, controller) {
      controller.clear();
    });
    setState(() {
      _total = 0.0;
    });
  }

  Future<void> _handleDeposit() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final safeProvider = Provider.of<SafeProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    final localizations = AppLocalizations.of(context)!;

    if (_total <= 0) return;

    // Prepare items
    final Map<String, int> depositItems = {};
    final Map<double, double> historyItems = {};
    bool hasInsufficientFunds = false;

    _controllers.forEach((denom, controller) {
      final qty = double.tryParse(controller.text) ?? 0.0;
      if (qty > 0) {
        final intQty = qty.toInt();
        final currentSafeCount = safeProvider.getCount(
          settings.currency,
          denom.toString(),
        );

        if (intQty > currentSafeCount) {
          hasInsufficientFunds = true;
        }

        depositItems[denom.toString()] = intQty;
        historyItems[denom] = qty;
      }
    });

    if (hasInsufficientFunds) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.insufficientFunds),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Confirm Dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.confirmDeposit),
        content: Text(localizations.confirmDepositContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Deduct from Safe
      safeProvider.removeItems(settings.currency, depositItems);

      // Save to History
      await historyProvider.saveRecord(
        currency: settings.currency,
        total: _total,
        items: historyItems,
        type: 'deposit',
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.deposited)));
        _resetTotal();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final denominations = _getDenominations(settings.currency);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.bankDeposit)),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Top Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
            child: Column(
              children: [
                TotalDisplay(
                  total: _total,
                  initialCash: 0,
                  targetAmount: 0,
                  currency: settings.currency,
                  locale: settings.locale,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Currency Selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: settings.currency,
                        underline: Container(),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: ['USD', 'EUR', 'TRY'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'USD'
                                  ? localizations.usd
                                  : value == 'EUR'
                                  ? localizations.eur
                                  : localizations.tl,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            settings.setCurrency(newValue);
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        // Deposit Button
                        FilledButton.icon(
                          onPressed: _handleDeposit,
                          icon: const Icon(
                            Icons.account_balance_rounded,
                            size: 18,
                          ),
                          label: Text(localizations.deposit),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary, // Use secondary color for deposit
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Reset Button
                        IconButton.filledTonal(
                          onPressed: _resetTotal,
                          icon: const Icon(Icons.refresh_rounded),
                          tooltip: localizations.reset,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable list of denominations
          Expanded(
            child: DenominationList(
              denominations: denominations,
              controllers: _controllers,
              currency: settings.currency,
              locale: settings.locale,
              onChanged: () => setState(() => _calculateTotal()),
            ),
          ),
        ],
      ),
    );
  }
}
