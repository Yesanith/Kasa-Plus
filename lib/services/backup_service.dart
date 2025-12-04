import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:money_calc_app/providers/history_provider.dart';
import 'package:money_calc_app/providers/safe_provider.dart';

class BackupService {
  static const String _backupFileNamePrefix = 'kasa_plus_backup_';

  // Keys to backup
  static const List<String> _keysToBackup = [
    'history_records',
    'safe_inventory',
    'currency', // Even though hardcoded now, good to keep
  ];

  Future<void> createBackup(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> backupData = {};

      for (final key in _keysToBackup) {
        if (prefs.containsKey(key)) {
          // We store everything as whatever type it is in prefs,
          // but SharedPreferences only supports basic types.
          // Our complex data is stored as JSON strings.
          final value = prefs.get(key);
          backupData[key] = value;
        }
      }

      // Add metadata
      backupData['backup_date'] = DateTime.now().toIso8601String();
      backupData['app_version'] = '1.0.0'; // TODO: Get real version

      final String jsonString = jsonEncode(backupData);

      // Create a temporary file
      final directory = await getTemporaryDirectory();
      final String dateStr = DateFormat(
        'yyyyMMdd_HHmmss',
      ).format(DateTime.now());
      final String fileName = '$_backupFileNamePrefix$dateStr.json';
      final File file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonString);

      // Share the file
      // ignore: deprecated_member_use
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Kasa+ Backup',
        text: 'Kasa+ data backup file created on $dateStr',
      );

      if (result.status == ShareResultStatus.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yedekleme dosyası oluşturuldu')),
          );
        }
      }
    } catch (e) {
      debugPrint('Backup error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Yedekleme hatası: $e')));
      }
    }
  }

  Future<void> restoreBackup(BuildContext context) async {
    try {
      // Pick file
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        final String jsonString = await file.readAsString();

        try {
          final Map<String, dynamic> data = jsonDecode(jsonString);

          // Validate backup file
          if (!data.containsKey('history_records') &&
              !data.containsKey('safe_inventory')) {
            throw Exception('Geçersiz yedekleme dosyası');
          }

          final prefs = await SharedPreferences.getInstance();

          // Restore keys
          for (final key in _keysToBackup) {
            if (data.containsKey(key)) {
              final value = data[key];
              if (value is String) {
                await prefs.setString(key, value);
              } else if (value is int) {
                await prefs.setInt(key, value);
              } else if (value is double) {
                await prefs.setDouble(key, value);
              } else if (value is bool) {
                await prefs.setBool(key, value);
              } else if (value is List) {
                await prefs.setStringList(key, List<String>.from(value));
              }
            }
          }

          // Reload providers
          if (context.mounted) {
            await Provider.of<HistoryProvider>(context, listen: false).reload();
          }

          if (context.mounted) {
            await Provider.of<SafeProvider>(context, listen: false).reload();
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veriler başarıyla geri yüklendi')),
            );
          }
        } catch (e) {
          debugPrint('Parse error: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Hatalı veya bozuk yedekleme dosyası'),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Restore error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Geri yükleme hatası: $e')));
      }
    }
  }
}
