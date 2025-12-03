import 'package:flutter/material.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';
import 'package:money_calc_app/pages/history_page.dart';
import 'package:money_calc_app/pages/home_page.dart';
import 'package:money_calc_app/pages/options_page.dart';
import 'package:money_calc_app/pages/safe_page.dart';
import 'package:money_calc_app/pages/bank_deposit_page.dart';
import 'package:money_calc_app/pages/statistics_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.appTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.calculate_rounded,
                  title: localizations.appTitle,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.savings_rounded,
                  title: localizations.safe,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SafePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_rounded,
                  title: localizations.bankDeposit,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BankDepositPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bar_chart_rounded,
                  title: localizations.statistics,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  title: localizations.history,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: localizations.options,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OptionsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('v1.0.0', style: TextStyle(color: theme.hintColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
