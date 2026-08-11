import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class MetricsCard extends StatelessWidget {
  const MetricsCard({
    required this.completedCount,
    required this.pendingCount,
    required this.siaScore,
    super.key,
  });

  final int completedCount;
  final int pendingCount;
  final double siaScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SIA Score Card
        Expanded(
          flex: 4,
          child: Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: siaScore / 100,
                          strokeWidth: 6,
                          backgroundColor: AppColors.surfaceVariant,
                          color: siaScore > 75
                              ? AppColors.success
                              : (siaScore > 40
                                  ? AppColors.warning
                                  : AppColors.error),
                        ),
                      ),
                      Text(
                        '${siaScore.toInt()}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingS),
                  Text(
                    'SIA Score',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: spacingS),

        // Completed Tasks Card
        Expanded(
          flex: 3,
          child: Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      color: AppColors.success, size: 28),
                  const SizedBox(height: spacingXs),
                  Text(
                    '$completedCount',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                  ),
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: spacingS),

        // Pending Tasks Card
        Expanded(
          flex: 3,
          child: Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Column(
                children: [
                  const Icon(Icons.pending_actions_rounded,
                      color: AppColors.warning, size: 28),
                  const SizedBox(height: spacingXs),
                  Text(
                    '$pendingCount',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                  ),
                  Text(
                    'Pending',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
