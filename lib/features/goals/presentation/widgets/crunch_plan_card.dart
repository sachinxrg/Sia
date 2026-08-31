import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Card widget displaying Gemini-generated crunch plan study milestones
/// with session type color coding and duration badges.
class CrunchPlanCard extends StatelessWidget {
  const CrunchPlanCard({
    super.key,
    required this.milestones,
  });

  /// List of milestone maps from GeminiService.generateExamCrunchPlan().
  /// Each map contains: topic, study_date, duration_minutes, session_type, recommended_focus.
  final List<Map<String, dynamic>> milestones;

  Color _sessionTypeColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'DEEP_DIVE':
        return AppColors.primary;
      case 'PRACTICE_PROBLEMS':
        return AppColors.warning;
      case 'SPACED_REVIEW':
        return AppColors.primaryLight;
      case 'MOCK_TEST':
        return AppColors.critical;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  IconData _sessionTypeIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'DEEP_DIVE':
        return Icons.menu_book_rounded;
      case 'PRACTICE_PROBLEMS':
        return Icons.edit_note_rounded;
      case 'SPACED_REVIEW':
        return Icons.psychology_rounded;
      case 'MOCK_TEST':
        return Icons.quiz_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _formatSessionType(String? type) {
    switch (type?.toUpperCase()) {
      case 'DEEP_DIVE':
        return 'Deep Dive';
      case 'PRACTICE_PROBLEMS':
        return 'Practice';
      case 'SPACED_REVIEW':
        return 'Review';
      case 'MOCK_TEST':
        return 'Mock Test';
      default:
        return 'Study';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(spacingS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: spacingS),
                Text(
                  'AI Crunch Plan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingS,
                    vertical: spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(radiusSm),
                  ),
                  child: Text(
                    '${milestones.length} sessions',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingM),

            // Milestone list
            ...milestones.asMap().entries.map((entry) {
              final index = entry.key;
              final m = entry.value;
              final sessionType = m['session_type'] as String?;
              final color = _sessionTypeColor(sessionType);
              final isLast = index == milestones.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
                    SizedBox(
                      width: 24,
                      child: Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: AppColors.surfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: spacingS),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: spacingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m['topic'] as String? ?? 'Topic',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                // Session type badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: spacingS,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius:
                                        BorderRadius.circular(radiusSm),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _sessionTypeIcon(sessionType),
                                        size: 12,
                                        color: color,
                                      ),
                                      const SizedBox(width: spacingXs),
                                      Text(
                                        _formatSessionType(sessionType),
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: spacingXs),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: spacingXs),
                                Text(
                                  m['study_date'] as String? ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(width: spacingM),
                                Icon(
                                  Icons.timer_outlined,
                                  size: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: spacingXs),
                                Text(
                                  '${m['duration_minutes'] ?? 60} min',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                            if (m['recommended_focus'] != null) ...[
                              const SizedBox(height: spacingXs),
                              Text(
                                m['recommended_focus'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
