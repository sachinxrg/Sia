import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/goal_progress.dart';
import '../providers/goals_providers.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({required this.goalId, super.key});

  final int goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoalsAsync = ref.watch(activeGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archive Goal',
            onPressed: () async {
              await ref.read(goalServiceProvider).archiveGoal(goalId);
              ref.invalidate(activeGoalsProvider);
              if (context.mounted) context.pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            onPressed: () async {
              await ref.read(goalServiceProvider).deleteGoal(goalId);
              ref.invalidate(activeGoalsProvider);
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: activeGoalsAsync.when(
        data: (goals) {
          final matching = goals.where((g) => g.id == goalId).toList();
          if (matching.isEmpty) {
            return const Center(child: Text('Goal not found or archived'));
          }

          final goal = matching.first;

          return SingleChildScrollView(
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
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(radiusSm),
                      ),
                      child: Text(
                        goal.categoryString,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
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
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(radiusSm),
                      ),
                      child: Text(
                        goal.targetTypeString,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingM),
                Text(
                  goal.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: spacingS),
                Text(
                  'Target: ${goal.targetDescription}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryLight,
                      ),
                ),
                if (goal.description != null && goal.description!.isNotEmpty) ...[
                  const SizedBox(height: spacingM),
                  Text(
                    goal.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
                const SizedBox(height: spacingXl),

                Text(
                  'Recent Progress Logs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: spacingM),
                FutureBuilder<List<GoalProgress>>(
                  future: ref.read(goalServiceProvider).getProgress(
                        goalId: goalId,
                        startDate: DateTime.now().subtract(const Duration(days: 30)),
                        endDate: DateTime.now(),
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final logs = snapshot.data ?? [];
                    if (logs.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(spacingM),
                          child: Text('No progress logged in the last 30 days.'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: spacingS),
                          child: ListTile(
                            title: Text('+${log.value} ${goal.unit}'),
                            subtitle: Text(log.note ?? 'Logged on ${log.date}'),
                            trailing: Text(
                              log.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
