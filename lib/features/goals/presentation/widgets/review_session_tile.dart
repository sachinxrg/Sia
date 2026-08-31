import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/review_session.dart';

/// Single tile widget displaying a spaced-repetition review session
/// with topic name, Leitner box level badge, due date, and recall action buttons.
class ReviewSessionTile extends StatelessWidget {
  const ReviewSessionTile({
    super.key,
    required this.session,
    required this.onRemembered,
    required this.onForgot,
  });

  final ReviewSession session;
  final VoidCallback onRemembered;
  final VoidCallback onForgot;

  Color _levelColor(SpacedRepetitionLevel level) {
    switch (level) {
      case SpacedRepetitionLevel.box1:
        return AppColors.critical;
      case SpacedRepetitionLevel.box2:
        return AppColors.warning;
      case SpacedRepetitionLevel.box3:
        return AppColors.primary;
      case SpacedRepetitionLevel.box4:
        return AppColors.primaryLight;
      case SpacedRepetitionLevel.box5:
        return AppColors.success;
    }
  }

  IconData _levelIcon(SpacedRepetitionLevel level) {
    switch (level) {
      case SpacedRepetitionLevel.box1:
        return Icons.fiber_new_rounded;
      case SpacedRepetitionLevel.box2:
        return Icons.replay_rounded;
      case SpacedRepetitionLevel.box3:
        return Icons.trending_up_rounded;
      case SpacedRepetitionLevel.box4:
        return Icons.verified_outlined;
      case SpacedRepetitionLevel.box5:
        return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(session.level);
    final isDue = session.isDue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: topic + level badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.topic,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingS,
                    vertical: spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(radiusSm),
                    border: Border.all(
                      color: color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_levelIcon(session.level), size: 14, color: color),
                      const SizedBox(width: spacingXs),
                      Text(
                        session.level.label.split(' ').first,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingS),

            // Due status
            Row(
              children: [
                Icon(
                  isDue ? Icons.notification_important_rounded : Icons.schedule_rounded,
                  size: 14,
                  color: isDue ? AppColors.critical : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: spacingXs),
                Text(
                  isDue ? 'Due now — review this topic' : 'Scheduled review',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDue ? AppColors.critical : AppColors.onSurfaceVariant,
                        fontWeight: isDue ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ],
            ),

            if (isDue) ...[
              const SizedBox(height: spacingM),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onForgot,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Forgot'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: spacingS),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRemembered,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Got It'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
