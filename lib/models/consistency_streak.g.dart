// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consistency_streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsistencyStreakImpl _$$ConsistencyStreakImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsistencyStreakImpl(
      id: (json['id'] as num?)?.toInt(),
      streakType: json['streakType'] as String,
      goalId: (json['goalId'] as num?)?.toInt(),
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
      streakStartDate: json['streakStartDate'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConsistencyStreakImplToJson(
        _$ConsistencyStreakImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'streakType': instance.streakType,
      'goalId': instance.goalId,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastActiveDate': instance.lastActiveDate,
      'streakStartDate': instance.streakStartDate,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
