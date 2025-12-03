import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRecord {
  final String id;
  final String date;
  final String currency;
  final double total;
  final double initialCash;
  final double targetAmount;
  final Map<String, double> items;
  final String type; // 'count' or 'deposit'

  HistoryRecord({
    required this.id,
    required this.date,
    required this.currency,
    required this.total,
    this.initialCash = 0.0,
    this.targetAmount = 0.0,
    required this.items,
    this.type = 'count',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'currency': currency,
      'total': total,
      'initialCash': initialCash,
      'targetAmount': targetAmount,
      'items': items,
      'type': type,
    };
  }

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      id: json['id'],
      date: json['date'],
      currency: json['currency'],
      total: json['total'],
      initialCash: (json['initialCash'] as num?)?.toDouble() ?? 0.0,
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      items: Map<String, double>.from(json['items']),
      type: json['type'] ?? 'count',
    );
  }
}

class HistoryProvider with ChangeNotifier {
  List<HistoryRecord> _records = [];
  List<HistoryRecord> get records => _records;

  HistoryProvider() {
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recordsJson = prefs.getString('history_records');
    if (recordsJson != null) {
      final List<dynamic> decoded = jsonDecode(recordsJson);
      _records = decoded.map((e) => HistoryRecord.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveRecord({
    required String currency,
    required double total,
    double initialCash = 0.0,
    double targetAmount = 0.0,
    required Map<double, double> items, // Denom -> Quantity
    String type = 'count',
  }) async {
    final now = DateTime.now();
    // Format: dd.MM.yyyy HH:mm
    final dateStr =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Convert items to Map<String, double> for JSON compatibility
    final Map<String, double> stringItems = {};
    items.forEach((key, value) {
      if (value > 0) {
        stringItems[key.toString()] = value;
      }
    });

    if (stringItems.isEmpty) return; // Don't save empty records

    final newRecord = HistoryRecord(
      id: now.millisecondsSinceEpoch.toString(),
      date: dateStr,
      currency: currency,
      total: total,
      initialCash: initialCash,
      targetAmount: targetAmount,
      items: stringItems,
      type: type,
    );

    _records.insert(0, newRecord); // Add to top
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> deleteRecord(String id) async {
    final index = _records.indexWhere((r) => r.id == id);
    if (index != -1) {
      if (_records[index].type == 'deposit') {
        // Cannot delete deposit records
        return;
      }
      _records.removeAt(index);
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> clearHistory() async {
    _records.clear();
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_records.map((e) => e.toJson()).toList());
    await prefs.setString('history_records', encoded);
  }
}
