import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../goals/providers/goals_providers.dart';

class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(overallStreakProvider);
    final isSecuredAsync = ref.watch(isTodayStreakSecuredProvider);

    return streakAsync.when(
      data: (streak) {
        final isSecured = isSecuredAsync.asData?.value ?? false;

        return Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
            side: BorderSide(
              color: isSecured
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.warning.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => context.go('/goals/consistency'),
            borderRadius: BorderRadius.circular(radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(spacingS),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.warning,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${streak.currentStreak} Day Streak',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: spacingS),
                            if (isSecured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: spacingS,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.success.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(radiusSm),
                                ),
                                child: Text(
                                  'Secured Today ✓',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          streak.longestStreak > 0
                              ? 'Best: ${streak.longestStreak} days • Tap for heatmap'
                              : 'Complete a task & log a goal daily to grow your streak!',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
