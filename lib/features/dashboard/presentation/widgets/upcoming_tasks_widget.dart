import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../goals/providers/goals_providers.dart';
import '../../../schedule/providers/schedule_providers.dart';

class UpcomingTasksWidget extends ConsumerWidget {
  const UpcomingTasksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingTasksAsync = ref.watch(pendingTasksProvider);

    return pendingTasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(spacingL),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.task_alt_rounded,
                      size: 40,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: spacingS),
                    Text(
                      'All caught up! No pending tasks.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final upcoming = tasks.take(3).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final task = upcoming[index];
            return Card(
              margin: const EdgeInsets.only(bottom: spacingS),
              child: ListTile(
                onTap: () => context.go('/schedule/task/${task.id}'),
                leading: IconButton(
                  icon: const Icon(
                    Icons.circle_outlined,
                    color: AppColors.primaryLight,
                  ),
                  onPressed: () async {
                    if (task.id != null) {
                      await ref
                          .read(scheduleServiceProvider)
                          .completeTask(task.id!);
                      ref.invalidate(pendingTasksProvider);
                      ref.invalidate(todayTasksProvider);
                      ref.invalidate(dailyTimelineProvider);
                      ref.invalidate(isTodayStreakSecuredProvider);
                    }
                  },
                ),
                title: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                subtitle: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sourceColor(task.sourceString)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(radiusSm),
                      ),
                      child: Text(
                        task.sourceString,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.sourceColor(task.sourceString),
                        ),
                      ),
                    ),
                    const SizedBox(width: spacingS),
                    if (task.deadline != null)
                      Text(
                        task.deadline!.toRelativeString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: task.isOverdue
                                  ? AppColors.error
                                  : AppColors.onSurfaceVariant,
                              fontWeight: task.isOverdue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                  ],
                ),
                trailing: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.priorityColor(task.priorityString),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error loading tasks: $err'),
    );
  }
}
