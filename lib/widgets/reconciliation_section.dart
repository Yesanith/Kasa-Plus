import 'package:flutter/material.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class ReconciliationSection extends StatelessWidget {
  final TextEditingController initialCashController;
  final TextEditingController targetAmountController;
  final VoidCallback onInitialCashTap;
  final ValueChanged<String> onTargetAmountChanged;

  const ReconciliationSection({
    super.key,
    required this.initialCashController,
    required this.targetAmountController,
    required this.onInitialCashTap,
    required this.onTargetAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: initialCashController,
            readOnly: true,
            onTap: onInitialCashTap,
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
            controller: targetAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onChanged: onTargetAmountChanged,
          ),
        ),
      ],
    );
  }
}
