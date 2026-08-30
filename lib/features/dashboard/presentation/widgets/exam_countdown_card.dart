import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../../models/exam_target.dart';
import '../../../goals/providers/exam_providers.dart';

/// Card widget showcasing upcoming exam countdowns, urgency badges, and syllabus coverage.
class ExamCountdownCard extends ConsumerWidget {
  const ExamCountdownCard({
    super.key,
    this.exam,
  });

  final ExamTarget? exam;

  Color _getUrgencyColor(int days) {
    if (days <= 3) return AppColors.critical;
    if (days <= 7) return AppColors.warning;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (exam != null) {
      return _buildCard(context, exam!);
    }

    final examsAsync = ref.watch(upcomingExamsProvider);

    return examsAsync.when(
      data: (exams) {
        if (exams.isEmpty) return const SizedBox.shrink();
        return _buildCard(context, exams.first);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(BuildContext context, ExamTarget target) {
    final days = target.daysRemaining;
    final urgencyColor = _getUrgencyColor(days);
    final progress = target.syllabusProgress;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(spacingS),
                      decoration: BoxDecoration(
                        color: urgencyColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.timer_outlined,
                        color: urgencyColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: spacingS),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          target.subject,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Exam on ${target.examDate.toDateString()}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingM,
                    vertical: spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: urgencyColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(radiusXl),
                    border:
                        Border.all(color: urgencyColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    days <= 0
                        ? 'EXAM TODAY'
                        : '$days ${days == 1 ? 'DAY' : 'DAYS'} LEFT',
                    style: TextStyle(
                      color: urgencyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Syllabus Coverage',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                Text(
                  '${(progress * 100).toInt()}% (${target.completedTopicsCount}/${target.syllabusTopics.isEmpty ? 0 : target.syllabusTopics.length} Topics)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: spacingXs),
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusSm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(urgencyColor),
              ),
            ),
            if (target.roomOrLocation != null) ...[
              const SizedBox(height: spacingS),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: spacingXs),
                  Text(
                    target.roomOrLocation!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
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
