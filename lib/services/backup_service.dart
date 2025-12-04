import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          var value = prefs.get(key);
          // If it's a JSON string, try to decode it so it looks nice in the backup file
          if (value is String &&
              (value.startsWith('{') || value.startsWith('['))) {
            try {
              value = jsonDecode(value);
            } catch (_) {}
          }
          backupData[key] = value;
        }
      }

      // Add metadata
      backupData['backup_date'] = DateTime.now().toIso8601String();
      backupData['app_version'] = '1.0.0'; // TODO: Get real version

      // Pretty print JSON
      final String jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(backupData);

      final String dateStr = DateFormat(
        'yyyyMMdd_HHmmss',
      ).format(DateTime.now());
      final String fileName = '$_backupFileNamePrefix$dateStr.json';

      // Convert to bytes for mobile platforms
      final Uint8List fileBytes = Uint8List.fromList(utf8.encode(jsonString));

      // Use FilePicker to save the file directly
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Yedek Dosyasını Kaydet',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: fileBytes,
      );

      if (outputFile != null) {
        // On mobile, if bytes are provided, saveFile handles the writing.
        // On desktop/web, we might still need to write if it just returns path,
        // but for this specific error "Bytes are required on Android & iOS",
        // providing bytes solves the mobile issue.
        // If outputFile is returned, it means success.

        // Note: On some platforms/versions, saveFile with bytes writes the file.
        // If we try to write again to 'outputFile', it might work or be redundant.
        // Since the error was about missing bytes, providing them is the fix.
        // We'll assume the plugin handles writing when bytes are passed on mobile.

        if (!Platform.isAndroid && !Platform.isIOS) {
          final File file = File(outputFile);
          await file.writeAsString(jsonString);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yedekleme dosyası başarıyla kaydedildi'),
            ),
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
              if (value is Map || value is List) {
                // It was decoded, so encode it back to string for Prefs
                await prefs.setString(key, jsonEncode(value));
              } else if (value is String) {
                await prefs.setString(key, value);
              } else if (value is int) {
                await prefs.setInt(key, value);
              } else if (value is double) {
                await prefs.setDouble(key, value);
              } else if (value is bool) {
                await prefs.setBool(key, value);
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
