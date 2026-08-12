import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/schedule_providers.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingTasksAsync = ref.watch(pendingTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            onPressed: () async {
              await ref.read(scheduleServiceProvider).deleteTask(taskId);
              ref.invalidate(pendingTasksProvider);
              ref.invalidate(overdueTasksProvider);
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: pendingTasksAsync.when(
        data: (tasks) {
          final taskList = tasks.where((t) => t.id == taskId).toList();
          if (taskList.isEmpty) {
            return const Center(child: Text('Task not found or completed'));
          }

          final task = taskList.first;

          return Padding(
            padding: const EdgeInsets.all(spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sourceColor(task.sourceString)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(radiusSm),
                      ),
                      child: Text(
                        task.sourceString,
                        style: TextStyle(
                          color: AppColors.sourceColor(task.sourceString),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.priorityColor(task.priorityString)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(radiusSm),
                      ),
                      child: Text(
                        task.priorityString,
                        style: TextStyle(
                          color: AppColors.priorityColor(task.priorityString),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingM),
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: spacingM),
                if (task.description != null && task.description!.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: spacingXs),
                  Text(
                    task.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: spacingL),
                ],
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.alarm_rounded),
                    title: const Text('Deadline'),
                    subtitle: Text(task.deadline != null
                        ? task.deadline!.toIso8601String()
                        : 'No deadline set'),
                  ),
                ),
                if (task.aiConfidence != null) ...[
                  const SizedBox(height: spacingS),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.auto_awesome_rounded,
                          color: AppColors.primaryLight),
                      title: const Text('AI Confidence Score'),
                      subtitle: Text(
                          '${(task.aiConfidence! * 100).toInt()}% extraction confidence'),
                    ),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(scheduleServiceProvider)
                          .completeTask(taskId);
                      ref.invalidate(pendingTasksProvider);
                      ref.invalidate(todayTasksProvider);
                      if (context.mounted) context.pop();
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Mark as Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: spacingM),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
