import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _currency = 'USD';
  Locale _locale = const Locale('en');

  /// Optionally provide an initial locale (for device language detection).
  SettingsProvider({Locale? initialLocale}) {
    if (initialLocale != null) {
      // Support only english and turkish for now; fall back to English.
      final code = initialLocale.languageCode.toLowerCase();
      if (code == 'tr') {
        _locale = const Locale('tr');
      } else {
        _locale = const Locale('en');
      }
    }
    _loadSettings();
  }

  String get currency => _currency;
  Locale get locale => _locale;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString('currency');
    if (savedCurrency != null) {
      _currency = savedCurrency;
      notifyListeners();
    }
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
