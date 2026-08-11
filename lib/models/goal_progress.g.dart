// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalProgressImpl _$$GoalProgressImplFromJson(Map<String, dynamic> json) =>
    _$GoalProgressImpl(
      id: (json['id'] as num?)?.toInt(),
      goalId: (json['goalId'] as num).toInt(),
      date: json['date'] as String,
      value: (json['value'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GoalProgressImplToJson(_$GoalProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'date': instance.date,
      'value': instance.value,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
    };
