import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';

import '../../../core/database/database_service.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/hash_utils.dart';
import '../../../models/raw_notification.dart';

/// Intercepts Android notifications, filters for WhatsApp, deduplicates,
/// and stores raw notification data in SQLite.
class WhatsAppHandler {
  WhatsAppHandler({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _notificationController = StreamController<RawNotification>.broadcast();

  /// Stream of incoming WhatsApp notifications after deduplication.
  Stream<RawNotification> get notificationStream =>
      _notificationController.stream;

  /// Starts listening for Android notifications.
  Future<void> startListening() async {
    NotificationsListener.receivePort?.listen((evt) {
      if (evt is NotificationEvent) {
        _onNotificationReceived(evt);
      }
    });
    dev.log('WhatsApp notification listener started', name: 'WhatsAppHandler');
  }

  /// Stops listening for notifications.
  Future<void> stopListening() async {
    _notificationController.close();
    dev.log('WhatsApp notification listener stopped', name: 'WhatsAppHandler');
  }

  /// Checks if the notification listener permission is granted.
  Future<bool> hasPermission() async {
    try {
      final hasAccess = await NotificationsListener.hasPermission ?? false;
      return hasAccess;
    } catch (e) {
      dev.log('WARN: Could not check notification permission: $e',
          name: 'WhatsAppHandler');
      return false;
    }
  }

  /// Opens the system settings page for notification listener.
  Future<void> requestPermission() async {
    await NotificationsListener.openPermissionSettings();
  }

  /// Handles incoming notifications from the Android system.
  Future<void> _onNotificationReceived(NotificationEvent event) async {
    // Filter: only process WhatsApp notifications
    final packageName = event.packageName ?? '';
    if (packageName != kWhatsAppPackageName &&
        packageName != kWhatsAppBusinessPackageName) {
      return;
    }

    final title = event.title;
    final body = event.text;
    final receivedAt = DateTime.now();

    // Generate deduplication hash
    final hash = generateNotificationHash(
      packageName: packageName,
      title: title,
      body: body,
      timestamp: receivedAt,
    );

    // Check for duplicates in the database
    final db = await _databaseService.database;
    final existing = await db.query(
      'raw_notification',
      where: 'content_hash = ?',
      whereArgs: [hash],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      dev.log('Duplicate notification skipped (hash: ${hash.substring(0, 8)}...)',
          name: 'WhatsAppHandler');
      return;
    }

    // Store in database
    final notification = RawNotification(
      packageName: packageName,
      title: title,
      body: body,
      contentHash: hash,
      receivedAt: receivedAt,
    );

    final id = await db.insert('raw_notification', {
      'package_name': notification.packageName,
      'title': notification.title,
      'body': notification.body,
      'content_hash': notification.contentHash,
      'is_processed': 0,
      'received_at': notification.receivedAt.toIso8601String(),
    });

    final saved = notification.copyWith(id: id);
    _notificationController.add(saved);

    dev.log(
      'Captured WhatsApp notification: "${title ?? "no title"}" (id=$id)',
      name: 'WhatsAppHandler',
    );
  }
}
