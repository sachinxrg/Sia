// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heatmap_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HeatmapDayImpl _$$HeatmapDayImplFromJson(Map<String, dynamic> json) =>
    _$HeatmapDayImpl(
      date: json['date'] as String,
      siaScore: (json['siaScore'] as num?)?.toDouble() ?? 0.0,
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      goalsProgressed: (json['goalsProgressed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HeatmapDayImplToJson(_$HeatmapDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'siaScore': instance.siaScore,
      'tasksCompleted': instance.tasksCompleted,
      'goalsProgressed': instance.goalsProgressed,
    };
