import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_metric.freezed.dart';
part 'daily_metric.g.dart';

@freezed
class DailyMetric with _$DailyMetric {
  const DailyMetric._();

  const factory DailyMetric({
    int? id,
    required String date,
    @Default(0) int tasksCreated,
    @Default(0) int tasksCompleted,
    @Default(0) int tasksOverdue,
    @Default(0) int notificationsSent,
    @Default(0) int notificationsActedOn,
    @Default(0.0) double siaScore,
    required DateTime createdAt,
  }) = _DailyMetric;

  factory DailyMetric.fromJson(Map<String, dynamic> json) =>
      _$DailyMetricFromJson(json);

  /// Calculates a composite SIA Score from the day's metrics.
  /// Formula: (completed / max(created, 1)) * 70 + (actedOn / max(sent, 1)) * 30
  double get calculatedScore {
    final completionRatio =
        tasksCreated > 0 ? (tasksCompleted / tasksCreated) : 0.0;
    final actionRatio = notificationsSent > 0
        ? (notificationsActedOn / notificationsSent)
        : 0.0;
    return (completionRatio * 70.0 + actionRatio * 30.0).clamp(0.0, 100.0);
  }
}
