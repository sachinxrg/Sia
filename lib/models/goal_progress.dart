import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_progress.freezed.dart';
part 'goal_progress.g.dart';

@freezed
class GoalProgress with _$GoalProgress {
  const factory GoalProgress({
    int? id,
    required int goalId,
    required String date,
    required double value,
    String? note,
    required DateTime createdAt,
  }) = _GoalProgress;

  factory GoalProgress.fromJson(Map<String, dynamic> json) =>
      _$GoalProgressFromJson(json);
}
