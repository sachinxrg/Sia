import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backup_service.dart';
import 'database_service.dart';

/// Singleton provider for the DatabaseService.
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provider for the BackupService singleton.
final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupService(databaseService: db);
});
