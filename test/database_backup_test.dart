import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sia/core/database/backup_service.dart';
import 'package:sia/core/database/database_service.dart';
import 'package:sia/core/database/migrations.dart';
import 'package:sia/core/utils/constants.dart';
import 'package:sia/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late BackupService backupService;

  setUp(() async {
    dbService = DatabaseService.instance;
    await dbService.database;
    backupService = BackupService(databaseService: dbService);
  });

  tearDown(() async {
    await dbService.close();
  });

  group('Database V2 Migration & Backup Service Tests', () {
    test('Migrations map includes v1 and v2 scripts', () {
      expect(migrations.containsKey(1), isTrue);
      expect(migrations.containsKey(2), isTrue);
      expect(kDatabaseVersion, equals(2));
    });

    test('V2 migration introduces user_backup_metadata table and task columns',
        () async {
      final db = await dbService.database;

      // Verify user_backup_metadata table exists
      final metadataTable = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='user_backup_metadata'",
      );
      expect(metadataTable.isNotEmpty, isTrue);

      // Verify task table has energy_level column
      final taskColumns = await db.rawQuery('PRAGMA table_info(task)');
      final columnNames = taskColumns.map((col) => col['name'] as String).toList();

      expect(columnNames, contains('energy_level'));
      expect(columnNames, contains('estimated_minutes'));
    });

    test('BackupService computes valid SHA-256 checksum', () {
      const testPayload = '{"task":[{"title":"Study AI"}]}';
      final checksum1 = backupService.computeChecksum(testPayload);
      final checksum2 = backupService.computeChecksum(testPayload);

      expect(checksum1, equals(checksum2));
      expect(checksum1.length, equals(64));
    });

    test('Export and import backup round-trip lifecycle', () async {
      final db = await dbService.database;
      final now = DateTime.now();

      await db.delete('task');

      // Seed a task
      await db.insert('task', {
        'title': 'Operating Systems Assignment',
        'description': 'Process scheduling problems',
        'source': 'CLASSROOM',
        'priority': 'HIGH',
        'energy_level': 'high_focus',
        'estimated_minutes': 45,
        'is_completed': 0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });

      // Export backup
      final backupJson = await backupService.exportBackup();
      final Map<String, dynamic> parsed = jsonDecode(backupJson);

      expect(parsed['app'], equals('SIA'));
      expect(parsed['version'], equals(2));
      expect(parsed['total_records'], greaterThanOrEqualTo(1));
      expect(parsed['checksum'], isNotNull);

      final data = parsed['data'] as Map<String, dynamic>;
      final tasks = data['task'] as List<dynamic>;
      expect(tasks.length, equals(1));
      expect(tasks.first['title'], equals('Operating Systems Assignment'));

      // Wipe task table
      await db.delete('task');
      final emptyCheck = await db.query('task');
      expect(emptyCheck.isEmpty, isTrue);

      // Restore from backup
      final restoredCount = await backupService.importBackup(backupJson);
      expect(restoredCount, greaterThanOrEqualTo(1));

      final restoredTasks = await db.query('task');
      expect(restoredTasks.length, equals(1));
      expect(restoredTasks.first['title'], equals('Operating Systems Assignment'));
    });

    test('Import backup rejects tampered checksums', () async {
      final backupJson = await backupService.exportBackup();
      final Map<String, dynamic> parsed = jsonDecode(backupJson);

      // Tamper checksum
      parsed['checksum'] = '0000000000000000000000000000000000000000000000000000000000000000';
      final tamperedJson = jsonEncode(parsed);

      expect(
        () async => backupService.importBackup(tamperedJson),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
