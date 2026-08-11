import 'package:freezed_annotation/freezed_annotation.dart';

part 'heatmap_day.freezed.dart';
part 'heatmap_day.g.dart';

@freezed
class HeatmapDay with _$HeatmapDay {
  const HeatmapDay._();

  const factory HeatmapDay({
    required String date,
    @Default(0.0) double siaScore,
    @Default(0) int tasksCompleted,
    @Default(0) int goalsProgressed,
  }) = _HeatmapDay;

  factory HeatmapDay.fromJson(Map<String, dynamic> json) =>
      _$HeatmapDayFromJson(json);

  /// Returns the intensity level (0-4) for heatmap coloring.
  /// 0 = empty, 1 = light (1-25), 2 = medium (26-50),
  /// 3 = strong (51-75), 4 = intense (76-100).
  int get intensityLevel {
    if (siaScore <= 0) return 0;
    if (siaScore <= 25) return 1;
    if (siaScore <= 50) return 2;
    if (siaScore <= 75) return 3;
    return 4;
  }

  /// Whether any activity occurred on this day.
  bool get hasActivity => tasksCompleted > 0 || goalsProgressed > 0;
}
