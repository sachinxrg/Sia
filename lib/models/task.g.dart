// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      source: $enumDecode(_$TaskSourceEnumMap, json['source']),
      sourceId: (json['sourceId'] as num?)?.toInt(),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.medium,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      scheduledStart: json['scheduledStart'] == null
          ? null
          : DateTime.parse(json['scheduledStart'] as String),
      scheduledEnd: json['scheduledEnd'] == null
          ? null
          : DateTime.parse(json['scheduledEnd'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'source': _$TaskSourceEnumMap[instance.source]!,
      'sourceId': instance.sourceId,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'deadline': instance.deadline?.toIso8601String(),
      'scheduledStart': instance.scheduledStart?.toIso8601String(),
      'scheduledEnd': instance.scheduledEnd?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'isDeleted': instance.isDeleted,
      'aiConfidence': instance.aiConfidence,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$TaskSourceEnumMap = {
  TaskSource.whatsapp: 'whatsapp',
  TaskSource.classroom: 'classroom',
  TaskSource.gmail: 'gmail',
  TaskSource.manual: 'manual',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.critical: 'critical',
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
};
