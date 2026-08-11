// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      category: $enumDecode(_$GoalCategoryEnumMap, json['category']),
      targetType: $enumDecode(_$GoalTargetTypeEnumMap, json['targetType']),
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'hours',
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      color: json['color'] as String? ?? '#6C5CE7',
      isActive: json['isActive'] as bool? ?? true,
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$GoalCategoryEnumMap[instance.category]!,
      'targetType': _$GoalTargetTypeEnumMap[instance.targetType]!,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'deadline': instance.deadline?.toIso8601String(),
      'color': instance.color,
      'isActive': instance.isActive,
      'isArchived': instance.isArchived,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$GoalCategoryEnumMap = {
  GoalCategory.academic: 'academic',
  GoalCategory.fitness: 'fitness',
  GoalCategory.skill: 'skill',
  GoalCategory.personal: 'personal',
};

const _$GoalTargetTypeEnumMap = {
  GoalTargetType.dailyHabit: 'dailyHabit',
  GoalTargetType.weeklyTarget: 'weeklyTarget',
  GoalTargetType.deadlineGoal: 'deadlineGoal',
};
