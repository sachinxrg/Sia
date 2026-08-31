import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/review_session.dart';
import '../../providers/exam_providers.dart';
import 'review_session_tile.dart';

/// Bottom sheet listing all pending spaced-repetition review sessions
/// for a specific exam, with "Remembered" / "Forgot" recall actions.
class ReviewSessionSheet extends ConsumerWidget {
  const ReviewSessionSheet({
    super.key,
    required this.examId,
    required this.examSubject,
  });

  final int examId;
  final String examSubject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(pendingExamReviewsProvider(examId));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: spacingS),
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: spacingM),

            // Header
            Row(
              children: [
                const Icon(
                  Icons.psychology_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spaced Repetition',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        examSubject,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingM),

            // Review list
            Expanded(
              child: reviewsAsync.when(
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 48,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: spacingS),
                          Text(
                            'All caught up!',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: spacingXs),
                          Text(
                            'No pending reviews for this exam.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  final dueNow = reviews.where((r) => r.isDue).toList();
                  final upcoming = reviews.where((r) => !r.isDue).toList();

                  return ListView(
                    controller: scrollController,
                    children: [
                      if (dueNow.isNotEmpty) ...[
                        _SectionHeader(
                          title: 'Due Now',
                          count: dueNow.length,
                          color: AppColors.critical,
                        ),
                        ...dueNow.map(
                          (session) => _buildTile(context, ref, session),
                        ),
                        const SizedBox(height: spacingM),
                      ],
                      if (upcoming.isNotEmpty) ...[
                        _SectionHeader(
                          title: 'Upcoming',
                          count: upcoming.length,
                          color: AppColors.onSurfaceVariant,
                        ),
                        ...upcoming.map(
                          (session) => _buildTile(context, ref, session),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    Center(child: Text('Error loading reviews: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    WidgetRef ref,
    ReviewSession session,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: spacingS),
      child: ReviewSessionTile(
        session: session,
        onRemembered: () async {
          await ref
              .read(examServiceProvider)
              .progressReviewSession(session: session, remembered: true);
          ref.invalidate(pendingExamReviewsProvider(examId));
          ref.invalidate(dueReviewSessionsProvider);
        },
        onForgot: () async {
          await ref
              .read(examServiceProvider)
              .progressReviewSession(session: session, remembered: false);
          ref.invalidate(pendingExamReviewsProvider(examId));
          ref.invalidate(dueReviewSessionsProvider);
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: spacingS),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: spacingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radiusSm),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
