import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class DenominationList extends StatelessWidget {
  final List<double> denominations;
  final Map<double, TextEditingController> controllers;
  final String currency;
  final Locale locale;
  final VoidCallback onChanged;

  const DenominationList({
    super.key,
    required this.denominations,
    required this.controllers,
    required this.currency,
    required this.locale,
    required this.onChanged,
  });

  String _formatCurrency(double value) {
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
    final format = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: symbol,
    );
    return format.format(value);
  }

  String _formatDenominationLabel(double denom) {
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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: denominations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final denom = denominations[index];
        final controller = controllers[denom];

        // Calculate subtotal for this row
        double quantity = 0.0;
        if (controller != null && controller.text.isNotEmpty) {
          quantity = double.tryParse(controller.text) ?? 0.0;
        }
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
                  _formatDenominationLabel(denom),
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
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor:
                        Theme.of(context).inputDecorationTheme.fillColor ??
                        Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => onChanged(),
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
                      _formatCurrency(subtotal),
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
    );
  }
}
