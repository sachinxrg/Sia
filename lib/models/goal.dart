import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

enum GoalCategory { academic, fitness, skill, personal }

enum GoalTargetType { dailyHabit, weeklyTarget, deadlineGoal }

@freezed
class Goal with _$Goal {
  const Goal._();

  const factory Goal({
    int? id,
    required String title,
    String? description,
    required GoalCategory category,
    required GoalTargetType targetType,
    required double targetValue,
    @Default('hours') String unit,
    DateTime? deadline,
    @Default('#6C5CE7') String color,
    @Default(true) bool isActive,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  /// Returns the category as a database-compatible uppercase string.
  String get categoryString => category.name.toUpperCase();

  /// Returns the target type as a database-compatible uppercase string.
  String get targetTypeString {
    switch (targetType) {
      case GoalTargetType.dailyHabit:
        return 'DAILY_HABIT';
      case GoalTargetType.weeklyTarget:
        return 'WEEKLY_TARGET';
      case GoalTargetType.deadlineGoal:
        return 'DEADLINE_GOAL';
    }
  }

  /// Human-readable target description (e.g., "2 hours/day").
  String get targetDescription {
    switch (targetType) {
      case GoalTargetType.dailyHabit:
        return '$targetValue $unit/day';
      case GoalTargetType.weeklyTarget:
        return '$targetValue $unit/week';
      case GoalTargetType.deadlineGoal:
        return '$targetValue $unit total';
    }
  }

  /// Whether this is a deadline-based goal approaching its due date.
  bool get isApproachingDeadline =>
      targetType == GoalTargetType.deadlineGoal &&
      deadline != null &&
      deadline!.difference(DateTime.now()).inDays <= 7 &&
      !deadline!.isBefore(DateTime.now());
}
