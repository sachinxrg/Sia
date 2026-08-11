import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/database_service.dart';
import 'core/notifications/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize core services safely
    await DatabaseService.instance.database;
  } catch (e) {
    dev.log('WARN: Database init deferred/fallback: $e', name: 'main');
  }

  try {
    await LocalNotificationService.instance.initialize();
  } catch (e) {
    dev.log('WARN: Notification init skipped on web/desktop: $e', name: 'main');
  }

  try {
    await DatabaseService.instance.pruneOldData();
  } catch (e) {
    dev.log('WARN: Prune old data skipped: $e', name: 'main');
  }

  runApp(
    const ProviderScope(
      child: SiaApp(),
    ),
  );
}
