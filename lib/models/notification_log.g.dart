// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationLogImpl _$$NotificationLogImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationLogImpl(
      id: (json['id'] as num?)?.toInt(),
      taskId: (json['taskId'] as num).toInt(),
      notificationType: json['notificationType'] as String,
      message: json['message'] as String,
      scheduledFor: DateTime.parse(json['scheduledFor'] as String),
      isSent: json['isSent'] as bool? ?? false,
      isDismissed: json['isDismissed'] as bool? ?? false,
      escalationCount: (json['escalationCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationLogImplToJson(
        _$NotificationLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'notificationType': instance.notificationType,
      'message': instance.message,
      'scheduledFor': instance.scheduledFor.toIso8601String(),
      'isSent': instance.isSent,
      'isDismissed': instance.isDismissed,
      'escalationCount': instance.escalationCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
