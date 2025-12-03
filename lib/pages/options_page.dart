import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.options)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.currency,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: settings.currency,
                      decoration: const InputDecoration(isDense: true),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.language,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Locale>(
                      value: settings.locale,
                      decoration: const InputDecoration(isDense: true),
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(localizations.english),
                        ),
                        DropdownMenuItem(
                          value: const Locale('tr'),
                          child: Text(localizations.turkish),
                        ),
                      ],
                      onChanged: (Locale? newValue) {
                        if (newValue != null) {
                          settings.setLocale(newValue);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
