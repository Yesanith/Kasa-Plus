import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_calc_app/providers/history_provider.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.history),
        actions: [
          if (historyProvider.records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: localizations.clearAll,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.clearAll),
                    content: Text(localizations.confirmDelete),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(localizations.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          historyProvider.clearHistory();
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
      body: historyProvider.records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    localizations.noHistory,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: historyProvider.records.length,
              itemBuilder: (context, index) {
                final record = historyProvider.records[index];
                final isDeposit = record.type == 'deposit';

                return Dismissible(
                  key: Key(record.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  onDismissed: (direction) {
                    historyProvider.deleteRecord(record.id);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    child: ExpansionTile(
                      shape: const Border(), // Remove default borders
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDeposit
                              ? Colors.orange.withValues(alpha: 0.1)
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDeposit
                              ? Icons.account_balance_rounded
                              : Icons.receipt_long_rounded,
                          color: isDeposit
                              ? Colors.orange
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            record.date,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (isDeposit) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                localizations.bankDeposit,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${record.currency} - ${record.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDeposit
                              ? Colors.orange
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Column(
                            children: [
                              if (record.initialCash > 0 ||
                                  record.targetAmount > 0) ...[
                                const Divider(),
                                _buildSummaryRow(
                                  context,
                                  localizations.total,
                                  record.total,
                                  isBold: true,
                                ),
                                if (record.initialCash > 0)
                                  _buildSummaryRow(
                                    context,
                                    localizations.initialCash,
                                    record.initialCash,
                                    isPositive: true,
                                  ),
                                if (record.initialCash > 0)
                                  _buildSummaryRow(
                                    context,
                                    localizations.netTotal,
                                    record.total + record.initialCash,
                                    isBold: true,
                                  ),
                                if (record.targetAmount > 0)
                                  _buildSummaryRow(
                                    context,
                                    localizations.targetAmount,
                                    record.targetAmount,
                                    color: Colors.blue,
                                  ),
                                if (record.targetAmount > 0)
                                  _buildSummaryRow(
                                    context,
                                    localizations.difference,
                                    (record.total + record.initialCash) -
                                        record.targetAmount,
                                    isBold: true,
                                    color:
                                        ((record.total + record.initialCash) -
                                                record.targetAmount) >=
                                            0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                              ],
                              const Divider(),
                              ...record.items.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${entry.key} x ${entry.value.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        (double.parse(entry.key) * entry.value)
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 12),
                              if (!isDeposit)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        historyProvider.deleteRecord(record.id),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                    ),
                                    label: Text(localizations.delete),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red.shade400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double value, {
    bool isBold = false,
    bool isPositive = false,
    bool isNegative = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
              color:
                  color ??
                  (isPositive
                      ? Colors.green
                      : isNegative
                      ? Colors.red
                      : Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }
}
