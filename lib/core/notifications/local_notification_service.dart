import 'dart:developer' as dev;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../utils/constants.dart';

/// Implementation of LocalNotificationService.
/// Manages Android notification channels, scheduling, and cancellation.
class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes the notification plugin with Android channels and permissions.
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          kChannelIdDeadlines,
          kChannelNameDeadlines,
          description: 'Reminders for upcoming task deadlines',
          importance: Importance.high,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          kChannelIdEscalations,
          kChannelNameEscalations,
          description: 'Urgent follow-up notifications for ignored deadlines',
          importance: Importance.max,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          kChannelIdGoals,
          kChannelNameGoals,
          description: 'Reminders about personal goal progress',
          importance: Importance.defaultImportance,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          kChannelIdStreaks,
          kChannelNameStreaks,
          description: 'Alerts about consistency streaks',
          importance: Importance.high,
        ),
      );

      // Request notification permission (Android 13+)
      await androidPlugin.requestNotificationsPermission();
    }

    _isInitialized = true;
    dev.log(
      'Notification service initialized with 4 channels',
      name: 'LocalNotificationService',
    );
  }

  /// Schedules a notification for a specific time.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
  }) async {
    final scheduledTz = tz.TZDateTime.from(scheduledTime, tz.local);

    // Don't schedule notifications in the past
    if (scheduledTz.isBefore(tz.TZDateTime.now(tz.local))) {
      dev.log(
        'WARN: Skipping past notification (id=$id, time=$scheduledTime)',
        name: 'LocalNotificationService',
      );
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _channelName(channelId),
      importance:
          channelId == kChannelIdEscalations ? Importance.max : Importance.high,
      priority:
          channelId == kChannelIdEscalations ? Priority.max : Priority.high,
      styleInformation: BigTextStyleInformation(body),
      autoCancel: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTz,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );

    dev.log(
      'Scheduled notification id=$id for $scheduledTime on channel=$channelId',
      name: 'LocalNotificationService',
    );
  }

  /// Cancels a specific notification by ID.
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
    dev.log('Cancelled notification id=$id', name: 'LocalNotificationService');
  }

  /// Cancels all notifications for a specific task.
  /// Uses ID range convention: taskId * 100 + offset (0-99).
  Future<void> cancelAllForTask(int taskId) async {
    for (var offset = 0; offset < 100; offset++) {
      await _plugin.cancel(taskId * 100 + offset);
    }
    dev.log(
      'Cancelled all notifications for task=$taskId',
      name: 'LocalNotificationService',
    );
  }

  /// Cancels all pending notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    dev.log(
      'Cancelled all pending notifications',
      name: 'LocalNotificationService',
    );
  }

  /// Returns all pending notification requests.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  String _channelName(String channelId) {
    switch (channelId) {
      case kChannelIdDeadlines:
        return kChannelNameDeadlines;
      case kChannelIdEscalations:
        return kChannelNameEscalations;
      case kChannelIdGoals:
        return kChannelNameGoals;
      case kChannelIdStreaks:
        return kChannelNameStreaks;
      default:
        return 'SIA Notifications';
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    dev.log(
      'Notification tapped: id=${response.id}, payload=${response.payload}',
      name: 'LocalNotificationService',
    );
  }
}
