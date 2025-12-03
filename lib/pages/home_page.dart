import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../providers/safe_provider.dart';
import '../l10n/app_localizations.dart';
import 'options_page.dart';
import 'history_page.dart';
import 'safe_page.dart';
import 'statistics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _total = 0.0;
  double _initialCash = 0.0;
  double _targetAmount = 0.0;

  // Store controllers for each denomination to persist input
  final Map<double, TextEditingController> _controllers = {};
  // Store initial cash counts
  final Map<double, int> _initialCashCounts = {};

  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _initialCashController = TextEditingController();
  String? _currentCurrency;
  bool _hasCheckedSafe = false;

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
  void initState() {
    super.initState();
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
    _targetAmountController.dispose();
    _initialCashController.dispose();
    super.dispose();
  }

  void _updateControllers(String currency) {
    // Clear old controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _initialCashCounts.clear();

    // Initialize new controllers
    final denoms = _getDenominations(currency);
    for (var denom in denoms) {
      _controllers[denom] = TextEditingController();
    }

    _currentCurrency = currency;
    _total = 0.0;
    _initialCash = 0.0;
    _initialCashController.clear();
    // We don't call setState here because this method is called
    // either from didChangeDependencies (which happens before build)
    // or explicitly. If called from didChangeDependencies, build will follow.
  }

  void _calculateTotal() {
    double newTotal = 0.0;
    _controllers.forEach((denom, controller) {
      final quantity = double.tryParse(controller.text) ?? 0.0;
      newTotal += denom * quantity;
    });

    double initialTotal = 0.0;
    _initialCashCounts.forEach((denom, count) {
      initialTotal += denom * count;
    });

    final target = double.tryParse(_targetAmountController.text) ?? 0.0;

    setState(() {
      _total = newTotal;
      _initialCash = initialTotal;
      _targetAmount = target;
      if (initialTotal > 0) {
        _initialCashController.text =
            '${_getCurrencySymbol(_currentCurrency ?? "TRY")}${initialTotal.toStringAsFixed(2)}';
      } else {
        _initialCashController.text = '';
      }
    });
  }

  void _resetTotal() {
    _controllers.forEach((_, controller) {
      controller.clear();
    });
    _initialCashCounts.clear();
    _targetAmountController.clear();
    _initialCashController.clear();
    setState(() {
      _total = 0.0;
      _initialCash = 0.0;
      _targetAmount = 0.0;
    });
  }

  Future<void> _showInitialCashDialog() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;
    final denoms = _getDenominations(settings.currency);

    // Temporary map to hold changes
    final Map<double, int> tempCounts = Map.from(_initialCashCounts);
    final Map<double, TextEditingController> tempControllers = {};

    for (var denom in denoms) {
      tempControllers[denom] = TextEditingController(
        text: tempCounts[denom]?.toString() ?? '',
      );
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.initialCash),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: denoms.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final denom = denoms[index];
              return TextField(
                controller: tempControllers[denom],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                decoration: InputDecoration(
                  prefixIcon: Container(
                    width: 80,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      _formatDenominationLabel(denom, settings.currency),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  final count = int.tryParse(value) ?? 0;
                  if (count > 0) {
                    tempCounts[denom] = count;
                  } else {
                    tempCounts.remove(denom);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _initialCashCounts.clear();
                _initialCashCounts.addAll(tempCounts);
              });
              _calculateTotal();
              Navigator.pop(context);
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );

    for (var c in tempControllers.values) {
      c.dispose();
    }
  }

  void _showEmptySafeDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.safeEmptyTitle),
        content: Text(localizations.safeEmptyMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(localizations.later),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SafePage()),
              );
            },
            child: Text(localizations.goToSafe),
          ),
        ],
      ),
    );
  }

  void _saveRecord() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final history = Provider.of<HistoryProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    if (_total <= 0) return;

    final Map<double, double> items = {};
    _controllers.forEach((denom, controller) {
      final qty = double.tryParse(controller.text) ?? 0.0;
      if (qty > 0) {
        items[denom] = qty;
      }
    });

    history.saveRecord(
      currency: settings.currency,
      total: _total,
      initialCash: _initialCash,
      targetAmount: _targetAmount,
      items: items,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.saved)));

    // Calculate items to add to safe (Total Count - Initial Cash Count)
    final Map<String, int> safeItems = {};
    double actualAddedAmount = 0.0;

    // We iterate through all denominations that have either count or initial cash
    final allDenoms = {...items.keys, ..._initialCashCounts.keys}.toList();

    for (final denom in allDenoms) {
      final totalCount = items[denom]?.toInt() ?? 0;
      final initialCount = _initialCashCounts[denom] ?? 0;
      final netCount = totalCount - initialCount;

      if (netCount != 0) {
        safeItems[denom.toString()] = netCount;
        actualAddedAmount += netCount * denom;
      }
    }

    // Ask to add to safe
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.safeDropTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow(
              localizations.totalCounted,
              _total,
              settings.currency,
            ),
            const SizedBox(height: 8),
            _buildDialogRow(
              localizations.deductedInitial,
              _initialCash,
              settings.currency,
              color: Colors.red.shade700,
            ),
            const Divider(height: 24),
            _buildDialogRow(
              localizations.toBeAdded,
              actualAddedAmount,
              settings.currency,
              isBold: true,
              color: actualAddedAmount >= 0
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Provider.of<SafeProvider>(
                context,
                listen: false,
              ).addItems(settings.currency, safeItems);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.addedToSafe)),
              );
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(
    String label,
    double value,
    String currency, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          '${_getCurrencySymbol(currency)}${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
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

    // Check safe status once loaded
    if (safeProvider.isLoaded && !_hasCheckedSafe) {
      if (safeProvider.isEmpty) {
        _hasCheckedSafe = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showEmptySafeDialog();
        });
      } else {
        _hasCheckedSafe = true;
      }
    }

    final denominations = _getDenominations(settings.currency);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.savings_rounded),
            tooltip: localizations.safe,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SafePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: localizations.statistics,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OptionsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Total display (fixed at top)
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 24,
                  ),
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
                        '${_getCurrencySymbol(settings.currency)}${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      if (_initialCash > 0 || _targetAmount > 0) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    localizations.netTotal,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${_getCurrencySymbol(settings.currency)}${(_total - _initialCash).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              Column(
                                children: [
                                  Text(
                                    localizations.difference,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${_getCurrencySymbol(settings.currency)}${((_total - _initialCash) - _targetAmount).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color:
                                          ((_total - _initialCash) -
                                                  _targetAmount) >=
                                              0
                                          ? Colors.white
                                          : const Color(0xFFFF8A80),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Reconciliation Inputs
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _initialCashController,
                        readOnly: true,
                        onTap: _showInitialCashDialog,
                        decoration: InputDecoration(
                          labelText: localizations.initialCash,
                          prefixIcon: const Icon(Icons.input_rounded, size: 20),
                          isDense: true,
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _targetAmountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: localizations.targetAmount,
                          prefixIcon: const Icon(Icons.flag_rounded, size: 20),
                          isDense: true,
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) => _calculateTotal(),
                      ),
                    ),
                  ],
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
                        // Save Button
                        FilledButton.icon(
                          onPressed: _saveRecord,
                          icon: const Icon(Icons.save_rounded, size: 18),
                          label: Text(localizations.save),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: denominations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final denom = denominations[index];
                final controller = _controllers[denom];

                // Calculate subtotal for this row
                final quantity =
                    double.tryParse(controller?.text ?? '0') ?? 0.0;
                final subtotal = denom * quantity;

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
                          onChanged: (_) => _calculateTotal(),
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
      ),
    );
  }
}
