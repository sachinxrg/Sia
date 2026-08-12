import 'dart:developer' as dev;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/constants.dart';
import 'migrations.dart';

/// Singleton service managing the database lifecycle.
/// Fully fool-proof for Web, Mobile, and Desktop platforms.
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  /// Returns the open database instance, initializing if needed.
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // Use in-memory FFI database for Web preview
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      return await openDatabase(
        inMemoryDatabasePath,
        version: kDatabaseVersion,
        onCreate: _onCreate,
      );
    }

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, kDatabaseName);

      dev.log('Initializing SIA database at: $path', name: 'DatabaseService');

      return await openDatabase(
        path,
        version: kDatabaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
        onOpen: (db) async {
          dev.log('Database opened successfully (version: $kDatabaseVersion)',
              name: 'DatabaseService');
          await _runIntegrityCheck(db);
        },
      );
    } catch (e) {
      dev.log('WARN: Falling back to FFI in-memory database: $e',
          name: 'DatabaseService');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      return await openDatabase(
        inMemoryDatabasePath,
        version: kDatabaseVersion,
        onCreate: _onCreate,
      );
    }
  }

  /// Enables foreign key support (required for CASCADE deletes).
  Future<void> _onConfigure(Database db) async {
    try {
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (_) {}
  }

  /// Runs the initial migration to create all tables.
  Future<void> _onCreate(Database db, int version) async {
    dev.log('Creating database schema (version $version)',
        name: 'DatabaseService');
    await _runMigration(db, 1, version);
  }

  /// Runs incremental migrations from oldVersion to newVersion.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    dev.log('Upgrading database from v$oldVersion to v$newVersion',
        name: 'DatabaseService');
    await _runMigration(db, oldVersion + 1, newVersion);
  }

  /// Executes all SQL statements for the given version range.
  Future<void> _runMigration(
    Database db,
    int fromVersion,
    int toVersion,
  ) async {
    for (var version = fromVersion; version <= toVersion; version++) {
      final migrationStatements = migrations[version];
      if (migrationStatements == null) continue;

      final batch = db.batch();
      for (final sql in migrationStatements) {
        batch.execute(sql.trim());
      }
      await batch.commit(noResult: true);
    }
  }

  /// Runs a SQLite integrity check on startup.
  Future<void> _runIntegrityCheck(Database db) async {
    try {
      final result = await db.rawQuery('PRAGMA integrity_check');
      final status = result.first.values.first as String;
      if (status != 'ok') {
        dev.log('WARNING: Integrity check: $status', name: 'DatabaseService');
      }
    } catch (_) {}
  }

  /// Auto-prunes data older than the retention period.
  Future<void> pruneOldData() async {
    try {
      final db = await database;
      final cutoffDate = DateTime.now()
          .subtract(const Duration(days: kDataRetentionDays))
          .toIso8601String();

      final batch = db.batch();
      batch.delete('raw_notification',
          where: 'received_at < ?', whereArgs: [cutoffDate]);
      batch.delete('gmail_item',
          where: 'received_at < ?', whereArgs: [cutoffDate]);
      batch.delete('notification_log',
          where: 'created_at < ?', whereArgs: [cutoffDate]);
      batch.delete('daily_metric',
          where: 'date < ?',
          whereArgs: [cutoffDate.substring(0, 10)]);

      await batch.commit();
    } catch (e) {
      dev.log('Prune old data skipped: $e', name: 'DatabaseService');
    }
  }

  /// Closes the database connection.
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
