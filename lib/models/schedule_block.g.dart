// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleBlockImpl _$$ScheduleBlockImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleBlockImpl(
      title: json['title'] as String,
      type: $enumDecode(_$BlockTypeEnumMap, json['type']),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      taskId: (json['taskId'] as num?)?.toInt(),
      goalId: (json['goalId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ScheduleBlockImplToJson(_$ScheduleBlockImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$BlockTypeEnumMap[instance.type]!,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'taskId': instance.taskId,
      'goalId': instance.goalId,
    };

const _$BlockTypeEnumMap = {
  BlockType.classBlock: 'classBlock',
  BlockType.task: 'task',
  BlockType.breakBlock: 'breakBlock',
  BlockType.goal: 'goal',
};
