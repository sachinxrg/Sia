import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/heatmap_day.dart';

class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({required this.days, super.key});

  final List<HeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const Center(child: Text('No heatmap data available'));
    }

    // Organize into columns (weeks) of 7 days each
    final numWeeks = (days.length / 7).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(numWeeks, (weekIndex) {
          return Column(
            children: List.generate(7, (dayIndex) {
              final dataIndex = weekIndex * 7 + dayIndex;
              if (dataIndex >= days.length) {
                return const SizedBox(width: 14, height: 14);
              }

              final item = days[dataIndex];
              final color = AppColors.heatmapColors[item.intensityLevel];

              return Tooltip(
                message:
                    '${item.date}: SIA Score ${item.siaScore.toInt()} (${item.tasksCompleted} tasks, ${item.goalsProgressed} goals)',
                child: Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
