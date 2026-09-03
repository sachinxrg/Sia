import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/goals_providers.dart';
import 'widgets/heatmap_grid.dart';

class ConsistencyScreen extends ConsumerWidget {
  const ConsistencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(overallStreakProvider);
    final heatmapAsync = ref.watch(heatmapDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consistency & Streaks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Hero Section
            streakAsync.when(
              data: (streak) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(spacingL),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(spacingM),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.warning,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: spacingM),
                        Text(
                          '${streak.currentStreak}',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Days Current Streak',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: spacingS),
                        Text(
                          'All-Time Longest Streak: ${streak.longestStreak} days',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading streak: $err'),
            ),
            const SizedBox(height: spacingL),

            // 90-Day Contribution Heatmap Header
            Text(
              '90-Day Activity Heatmap',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: spacingXs),
            Text(
              'Intensity based on daily SIA productivity score',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: spacingM),

            // Heatmap Grid Widget
            heatmapAsync.when(
              data: (heatmapDays) => HeatmapGrid(days: heatmapDays),
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Text('Error loading heatmap: $err'),
            ),
            const SizedBox(height: spacingL),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Less',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(width: spacingS),
                ...List.generate(
                  5,
                  (index) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.heatmapColors[index],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: spacingS),
                Text(
                  'More',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
