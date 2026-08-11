import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_service.dart';

/// Singleton provider for the DatabaseService.
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});
