import 'dart:convert';
import 'dart:developer' as dev;
import 'package:crypto/crypto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/constants.dart';
import 'database_service.dart';

/// Manages local data export, schema serialization, SHA-256 checksum generation,
/// and metadata audit logging.
class BackupService {
  BackupService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;

  /// Tables included in full local backup exports.
  static const List<String> _exportTables = [
    'user_profile',
    'task',
    'goal',
    'goal_progress',
    'timetable_entry',
    'daily_metric',
    'consistency_streak',
  ];

  /// Computes SHA-256 checksum string for a serialized data payload.
  String computeChecksum(String payload) {
    final bytes = utf8.encode(payload);
    return sha256.convert(bytes).toString();
  }

  /// Exports all student data to an integrity-protected JSON string.
  Future<String> exportBackup() async {
    final db = await _databaseService.database;
    final Map<String, List<Map<String, dynamic>>> dataMap = {};
    var totalRecords = 0;

    for (final table in _exportTables) {
      try {
        final rows = await db.query(table);
        dataMap[table] = rows;
        totalRecords += rows.length;
      } catch (e) {
        dev.log(
          'WARN: Skipping table $table during export: $e',
          name: 'BackupService',
        );
      }
    }

    final dataJsonString = jsonEncode(dataMap);
    final checksum = computeChecksum(dataJsonString);
    final nowIso = DateTime.now().toIso8601String();

    final backupPayload = {
      'app': 'SIA',
      'version': kDatabaseVersion,
      'exported_at': nowIso,
      'total_records': totalRecords,
      'checksum': checksum,
      'data': dataMap,
    };

    final fullPayloadJson = jsonEncode(backupPayload);

    // Record in user_backup_metadata table if available
    try {
      await db.insert('user_backup_metadata', {
        'backup_timestamp': nowIso,
        'checksum': checksum,
        'record_count': totalRecords,
        'created_at': nowIso,
      });
    } catch (_) {
      // Ignored if table not yet initialized
    }

    dev.log(
      'Exported backup with $totalRecords records (checksum: ${checksum.substring(0, 8)}...)',
      name: 'BackupService',
    );

    return fullPayloadJson;
  }

  /// Restores database records from an integrity-validated JSON backup string.
  /// Executes inside a single atomic SQLite transaction with table clearing and record replacement.
  Future<int> importBackup(String rawPayloadJson) async {
    final Map<String, dynamic> payload =
        jsonDecode(rawPayloadJson) as Map<String, dynamic>;

    if (payload['app'] != 'SIA') {
      throw const FormatException('Invalid backup: Not a SIA backup file');
    }

    final dataMap = payload['data'] as Map<String, dynamic>?;
    if (dataMap == null) {
      throw const FormatException('Corrupted backup: Missing data payload');
    }

    final expectedChecksum = payload['checksum'] as String?;
    final computedChecksum = computeChecksum(jsonEncode(dataMap));

    if (expectedChecksum != computedChecksum) {
      throw const FormatException(
        'Integrity check failed: Checksum mismatch. File may be corrupted.',
      );
    }

    final db = await _databaseService.database;
    var restoredRecords = 0;

    await db.transaction((txn) async {
      for (final table in _exportTables) {
        if (!dataMap.containsKey(table)) continue;
        final rawRows = dataMap[table] as List<dynamic>?;
        if (rawRows == null) continue;

        // Clear existing table content for clean restore
        await txn.delete(table);

        for (final item in rawRows) {
          final row = item as Map<String, dynamic>;
          await txn.insert(
            table,
            row,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          restoredRecords++;
        }
      }
    });

    dev.log(
      'Restored $restoredRecords records successfully from backup',
      name: 'BackupService',
    );

    return restoredRecords;
  }
}
