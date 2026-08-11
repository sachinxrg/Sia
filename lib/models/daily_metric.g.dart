// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyMetricImpl _$$DailyMetricImplFromJson(Map<String, dynamic> json) =>
    _$DailyMetricImpl(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String,
      tasksCreated: (json['tasksCreated'] as num?)?.toInt() ?? 0,
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      tasksOverdue: (json['tasksOverdue'] as num?)?.toInt() ?? 0,
      notificationsSent: (json['notificationsSent'] as num?)?.toInt() ?? 0,
      notificationsActedOn:
          (json['notificationsActedOn'] as num?)?.toInt() ?? 0,
      siaScore: (json['siaScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DailyMetricImplToJson(_$DailyMetricImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'tasksCreated': instance.tasksCreated,
      'tasksCompleted': instance.tasksCompleted,
      'tasksOverdue': instance.tasksOverdue,
      'notificationsSent': instance.notificationsSent,
      'notificationsActedOn': instance.notificationsActedOn,
      'siaScore': instance.siaScore,
      'createdAt': instance.createdAt.toIso8601String(),
    };
