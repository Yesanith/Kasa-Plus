import 'package:flutter/material.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';
import 'package:money_calc_app/services/backup_service.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final backupService = BackupService();

    return Scaffold(
      appBar: AppBar(title: Text(localizations.options)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.backupRestore,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.upload_file_rounded),
                    title: Text(localizations.backupData),
                    onTap: () => backupService.createBackup(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.download_rounded),
                    title: Text(localizations.restoreData),
                    onTap: () => backupService.restoreBackup(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
