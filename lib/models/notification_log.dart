import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_log.freezed.dart';
part 'notification_log.g.dart';

@freezed
class NotificationLog with _$NotificationLog {
  const factory NotificationLog({
    int? id,
    required int taskId,
    required String notificationType,
    required String message,
    required DateTime scheduledFor,
    @Default(false) bool isSent,
    @Default(false) bool isDismissed,
    @Default(0) int escalationCount,
    required DateTime createdAt,
  }) = _NotificationLog;

  factory NotificationLog.fromJson(Map<String, dynamic> json) =>
      _$NotificationLogFromJson(json);
}
