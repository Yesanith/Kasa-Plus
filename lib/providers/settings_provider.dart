import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _currency = 'TRY';
  Locale _locale = const Locale('tr');
  bool _tutorialShown = true; // Default to true to prevent premature showing
  bool _isLoading = true;

  SettingsProvider() {
    // Force Turkish locale
    _locale = const Locale('tr');
    _loadSettings();
  }

  String get currency => _currency;
  Locale get locale => _locale;
  bool get tutorialShown => _tutorialShown;
  bool get isLoading => _isLoading;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _tutorialShown = prefs.getBool('tutorial_shown') ?? false;
    _isLoading = false;

    // We only support TRY now, so we don't need to load currency from prefs
    // unless we want to support future currencies.
    // For now, force TRY.
    _currency = 'TRY';
    notifyListeners();
  }

  Future<void> completeTutorial() async {
    _tutorialShown = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_shown', true);
  }

  // Currency is fixed to TRY
  Future<void> setCurrency(String currency) async {
    // No-op or throw error
  }

  // Locale is fixed to TR
  void setLocale(Locale locale) {
    // No-op
  }
}
