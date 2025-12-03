import 'package:flutter/material.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class InitialCashDialog extends StatefulWidget {
  final Map<double, int> initialCounts;
  final String currency;
  final List<double> denominations;

  const InitialCashDialog({
    super.key,
    required this.initialCounts,
    required this.currency,
    required this.denominations,
  });

  @override
  State<InitialCashDialog> createState() => _InitialCashDialogState();
}

class _InitialCashDialogState extends State<InitialCashDialog> {
  late Map<double, int> _tempCounts;
  final Map<double, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tempCounts = Map.from(widget.initialCounts);
    for (var denom in widget.denominations) {
      _controllers[denom] = TextEditingController(
        text: _tempCounts[denom]?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatDenominationLabel(double denom, String currency) {
    String symbol;
    switch (currency) {
      case 'USD':
        symbol = '\$';
        break;
      case 'EUR':
        symbol = '€';
        break;
      case 'TRY':
        symbol = '₺';
        break;
      default:
        symbol = '';
    }

    if (denom >= 1) {
      return '$symbol${denom.toStringAsFixed(0)}';
    } else {
      if (currency == 'TRY') {
        final kurus = (denom * 100).round();
        return '${kurus}Kr';
      } else {
        return '$symbol${denom.toStringAsFixed(2)}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.initialCash),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.denominations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final denom = widget.denominations[index];
            return TextField(
              controller: _controllers[denom],
              keyboardType: const TextInputType.numberWithOptions(),
              textInputAction: TextInputAction.next,
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
                    _formatDenominationLabel(denom, widget.currency),
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
                  _tempCounts[denom] = count;
                } else {
                  _tempCounts.remove(denom);
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
            Navigator.pop(context, _tempCounts);
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
