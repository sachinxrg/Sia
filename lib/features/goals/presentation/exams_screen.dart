import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/exam_target.dart';
import '../../dashboard/presentation/widgets/exam_countdown_card.dart';
import '../providers/exam_providers.dart';
import 'widgets/create_exam_dialog.dart';

/// Dedicated exam targets listing screen with active/past tab bar,
/// ExamCountdownCard list items, and a FAB for creating new exams.
class ExamsScreen extends ConsumerWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exam Targets'),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ExamListTab(
              provider: upcomingExamsProvider,
              emptyIcon: Icons.event_note_rounded,
              emptyTitle: 'No upcoming exams',
              emptySubtitle:
                  'Add your first exam target and let SIA create a study plan.',
            ),
            _ExamListTab(
              provider: pastExamsProvider,
              emptyIcon: Icons.history_rounded,
              emptyTitle: 'No past exams',
              emptySubtitle: 'Completed exams will appear here.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const CreateExamDialog(),
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}

class _ExamListTab extends ConsumerWidget {
  const _ExamListTab({
    required this.provider,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final FutureProvider<List<ExamTarget>> provider;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(provider);

    return examsAsync.when(
      data: (exams) {
        if (exams.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    emptyIcon,
                    size: 48,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: spacingS),
                  Text(
                    emptyTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: spacingXs),
                  Text(
                    emptySubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(upcomingExamsProvider);
            ref.invalidate(pastExamsProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(spacingM),
            itemCount: exams.length,
            separatorBuilder: (_, __) => const SizedBox(height: spacingS),
            itemBuilder: (context, index) {
              final exam = exams[index];
              return GestureDetector(
                onTap: () => context.go('/goals/exams/${exam.id}'),
                child: ExamCountdownCard(exam: exam),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading exams: $err')),
    );
  }
}
