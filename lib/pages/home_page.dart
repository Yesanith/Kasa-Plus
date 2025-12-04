import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:money_calc_app/providers/settings_provider.dart';
import 'package:money_calc_app/providers/history_provider.dart';
import 'package:money_calc_app/providers/safe_provider.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';
import 'package:money_calc_app/widgets/app_drawer.dart';
import 'package:money_calc_app/widgets/denomination_list.dart';
import 'package:money_calc_app/widgets/initial_cash_dialog.dart';
import 'package:money_calc_app/widgets/reconciliation_section.dart';
import 'package:money_calc_app/widgets/total_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _total = 0.0;
  double _initialCash = 0.0;
  double _targetAmount = 0.0;

  // Tutorial Keys
  final GlobalKey _totalDisplayKey = GlobalKey();
  final GlobalKey _reconciliationKey = GlobalKey();
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _saveKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();

  // Store controllers for each denomination to persist input
  final Map<double, TextEditingController> _controllers = {};
  // Store initial cash counts
  final Map<double, int> _initialCashCounts = {};

  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _initialCashController = TextEditingController();
  String? _currentCurrency;

  // Define denominations for supported currencies
  static const Map<String, List<double>> _currencyDenominations = {
    'TRY': [200, 100, 50, 20, 10, 5, 1, 0.5, 0.25, 0.1, 0.05],
  };

  List<double> _getDenominations(String currency) {
    return _currencyDenominations['TRY']!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTutorial();
    });
  }

  void _checkTutorial() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.tutorialShown) {
      _showTutorial(context);
    }
  }

  void _showTutorial(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'welcome',
          keyTarget: _totalDisplayKey, // Start with total display as anchor
          contents: [
            TargetContent(
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialWelcomeTitle,
                  description: localizations.tutorialWelcomeDesc,
                  controller: controller,
                  localizations: localizations,
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'total',
          keyTarget: _totalDisplayKey,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialTotalTitle,
                  description: localizations.tutorialTotalDesc,
                  controller: controller,
                  localizations: localizations,
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'initial',
          keyTarget: _reconciliationKey,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialInitialTitle,
                  description: localizations.tutorialInitialDesc,
                  controller: controller,
                  localizations: localizations,
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'list',
          keyTarget: _listKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialListTitle,
                  description: localizations.tutorialListDesc,
                  controller: controller,
                  localizations: localizations,
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'save',
          keyTarget: _saveKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialSaveTitle,
                  description: localizations.tutorialSaveDesc,
                  controller: controller,
                  localizations: localizations,
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'menu',
          keyTarget: _menuKey,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return _buildTutorialContent(
                  title: localizations.tutorialMenuTitle,
                  description: localizations.tutorialMenuDesc,
                  controller: controller,
                  localizations: localizations,
                  isLast: true,
                );
              },
            ),
          ],
        ),
      ],
      textSkip: localizations.skip,
      onFinish: () {
        settings.completeTutorial();
      },
      onSkip: () {
        settings.completeTutorial();
        return true;
      },
    ).show(context: context);
  }

  Widget _buildTutorialContent({
    required String title,
    required String description,
    required TutorialCoachMarkController controller,
    required AppLocalizations localizations,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () {
                controller.next();
              },
              child: Text(isLast ? localizations.finish : localizations.next),
            ),
          ),
        ],
      ),
    );
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
  }

  String _formatCurrency(double value, String currency, Locale locale) {
    final format = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: '₺',
    );
    return format.format(value);
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
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        _initialCashController.text = _formatCurrency(
          initialTotal,
          settings.currency,
          settings.locale,
        );
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
    final denoms = _getDenominations(settings.currency);

    final result = await showDialog<Map<double, int>>(
      context: context,
      builder: (context) => InitialCashDialog(
        initialCounts: _initialCashCounts,
        currency: settings.currency,
        denominations: denoms,
      ),
    );

    if (result != null) {
      setState(() {
        _initialCashCounts.clear();
        _initialCashCounts.addAll(result);
      });
      _calculateTotal();
    }
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
    final settings = Provider.of<SettingsProvider>(context, listen: false);
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
          _formatCurrency(value, currency, settings.locale),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    final denominations = _getDenominations(settings.currency);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        leading: Builder(
          builder: (context) {
            return IconButton(
              key: _menuKey,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Fixed Top Section
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
                  key: _totalDisplayKey,
                  total: _total,
                  initialCash: _initialCash,
                  targetAmount: _targetAmount,
                  currency: settings.currency,
                  locale: settings.locale,
                ),
                const SizedBox(height: 16),
                ReconciliationSection(
                  key: _reconciliationKey,
                  initialCashController: _initialCashController,
                  targetAmountController: _targetAmountController,
                  onInitialCashTap: _showInitialCashDialog,
                  onTargetAmountChanged: (_) => _calculateTotal(),
                ),
                const SizedBox(height: 20),
                Row(
                  key: _saveKey,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Save Button
                    FilledButton.icon(
                      onPressed: _saveRecord,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: Text(localizations.save),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
          ),

          // Scrollable list of denominations
          Expanded(
            child: DenominationList(
              key: _listKey,
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
