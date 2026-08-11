import 'package:freezed_annotation/freezed_annotation.dart';

part 'consistency_streak.freezed.dart';
part 'consistency_streak.g.dart';

@freezed
class ConsistencyStreak with _$ConsistencyStreak {
  const ConsistencyStreak._();

  const factory ConsistencyStreak({
    int? id,
    required String streakType,
    int? goalId,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    String? lastActiveDate,
    String? streakStartDate,
    required DateTime updatedAt,
  }) = _ConsistencyStreak;

  factory ConsistencyStreak.fromJson(Map<String, dynamic> json) =>
      _$ConsistencyStreakFromJson(json);

  /// Whether this is the overall (non-goal-specific) streak.
  bool get isOverall => streakType == 'OVERALL';

  /// Whether the current streak is approaching the all-time record.
  bool get isNearRecord =>
      longestStreak > 0 && currentStreak >= (longestStreak * 0.8);

  /// Whether the current streak IS the all-time record.
  bool get isAtRecord => currentStreak > 0 && currentStreak >= longestStreak;

  /// Returns a tier label based on streak length for UI flame sizing.
  String get streakTier {
    if (currentStreak >= 30) return 'inferno';
    if (currentStreak >= 7) return 'large';
    if (currentStreak >= 3) return 'medium';
    return 'small';
  }
}
