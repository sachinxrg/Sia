// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineBlockImpl _$$TimelineBlockImplFromJson(Map<String, dynamic> json) =>
    _$TimelineBlockImpl(
      title: json['title'] as String,
      type: json['type'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      taskId: (json['taskId'] as num?)?.toInt(),
      goalId: (json['goalId'] as num?)?.toInt(),
      subtitle: json['subtitle'] as String?,
      colorHex: json['colorHex'] as String?,
      isFixed: json['isFixed'] as bool? ?? false,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );

Map<String, dynamic> _$$TimelineBlockImplToJson(_$TimelineBlockImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'taskId': instance.taskId,
      'goalId': instance.goalId,
      'subtitle': instance.subtitle,
      'colorHex': instance.colorHex,
      'isFixed': instance.isFixed,
      'isCurrent': instance.isCurrent,
    };
