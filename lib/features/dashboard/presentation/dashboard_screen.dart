import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_extensions.dart';
import '../../auth/providers/auth_providers.dart';

import '../../goals/providers/goals_providers.dart';
import '../../schedule/providers/schedule_providers.dart';
import 'widgets/metrics_card.dart';
import 'widgets/streak_badge.dart';
import 'widgets/timeline_widget.dart';
import 'widgets/upcoming_tasks_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final todayTasksAsync = ref.watch(todayTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: userAsync.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateTimeExtensions.greeting()}, ${user?.displayName ?? "Student"}! 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (user?.collegeName != null)
                Text(
                  user!.collegeName!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
            ],
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Welcome'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(todayTasksProvider);
              ref.invalidate(dailyTimelineProvider);
              ref.invalidate(overallStreakProvider);
              ref.invalidate(isTodayStreakSecuredProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayTasksProvider);
          ref.invalidate(dailyTimelineProvider);
          ref.invalidate(overallStreakProvider);
          ref.invalidate(isTodayStreakSecuredProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Streak Hero Card
              const StreakBadge(),
              const SizedBox(height: spacingM),

              // Metrics Row
              todayTasksAsync.when(
                data: (tasks) {
                  final completed = tasks.where((t) => t.isCompleted).length;
                  final total = tasks.length;
                  final pending = total - completed;
                  final siaScore = total > 0 ? (completed / total * 100) : 100.0;

                  return MetricsCard(
                    completedCount: completed,
                    pendingCount: pending,
                    siaScore: siaScore,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading metrics: $err'),
              ),
              const SizedBox(height: spacingL),

              // Hour-by-hour Timeline Widget
              Text(
                'Today\'s Timeline',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: spacingS),
              const TimelineWidget(),
              const SizedBox(height: spacingL),

              // Upcoming Tasks List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.go('/schedule'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: spacingS),
              const UpcomingTasksWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
