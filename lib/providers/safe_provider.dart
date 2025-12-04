import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeProvider with ChangeNotifier {
  // Map<Currency, Map<Denomination, Count>>
  Map<String, Map<String, int>> _inventory = {};
  bool _isLoaded = false;

  SafeProvider() {
    _loadInventory();
  }

  bool get isLoaded => _isLoaded;

  bool get isEmpty {
    if (_inventory.isEmpty) return true;
    // Check if all currencies are empty or have 0 total
    for (var currencyMap in _inventory.values) {
      if (currencyMap.isNotEmpty) {
        // Check if any denomination has count > 0
        for (var count in currencyMap.values) {
          if (count > 0) return false;
        }
      }
    }
    return true;
  }

  Map<String, int> getInventory(String currency) {
    return _inventory[currency] ?? {};
  }

  int getCount(String currency, String denomination) {
    return _inventory[currency]?[denomination] ?? 0;
  }

  double getTotal(String currency) {
    double total = 0;
    final inv = _inventory[currency];
    if (inv != null) {
      inv.forEach((denom, count) {
        total += double.parse(denom) * count;
      });
    }
    return total;
  }

  void updateCount(String currency, String denomination, int count) {
    if (!_inventory.containsKey(currency)) {
      _inventory[currency] = {};
    }
    _inventory[currency]![denomination] = count;
    _saveInventory();
    notifyListeners();
  }

  void addItems(String currency, Map<String, int> items) {
    if (!_inventory.containsKey(currency)) {
      _inventory[currency] = {};
    }
    items.forEach((denom, count) {
      final current = _inventory[currency]![denom] ?? 0;
      _inventory[currency]![denom] = current + count;
    });
    _saveInventory();
    notifyListeners();
  }

  void removeItems(String currency, Map<String, int> items) {
    if (!_inventory.containsKey(currency)) {
      return;
    }
    items.forEach((denom, count) {
      final current = _inventory[currency]![denom] ?? 0;
      final newCount = current - count;
      _inventory[currency]![denom] = newCount < 0 ? 0 : newCount;
    });
    _saveInventory();
    notifyListeners();
  }

  void clearCurrencyInventory(String currency) {
    if (_inventory.containsKey(currency)) {
      _inventory[currency]!.clear();
      _saveInventory();
      notifyListeners();
    }
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('safe_inventory');
    if (data != null) {
      try {
        final decoded = json.decode(data) as Map<String, dynamic>;
        _inventory = decoded.map((key, value) {
          final innerMap = (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v as int),
          );
          return MapEntry(key, innerMap);
        });
        _isLoaded = true;
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading inventory: $e');
        _isLoaded = true;
        notifyListeners();
      }
    } else {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('safe_inventory', json.encode(_inventory));
  }

  Future<void> reload() async {
    await _loadInventory();
  }
}
