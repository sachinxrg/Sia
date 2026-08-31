import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/exam_target.dart';
import '../../../models/review_session.dart';
import '../providers/exam_providers.dart';
import 'widgets/crunch_plan_card.dart';
import 'widgets/review_session_sheet.dart';
import 'widgets/syllabus_checklist.dart';

/// Full detail view for a single exam target: countdown hero, syllabus
/// checklist, AI crunch plan generator, and spaced repetition reviews.
class ExamDetailScreen extends ConsumerStatefulWidget {
  const ExamDetailScreen({super.key, required this.examId});

  final int examId;

  @override
  ConsumerState<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends ConsumerState<ExamDetailScreen> {
  List<Map<String, dynamic>> _crunchPlan = [];
  bool _isGenerating = false;

  Color _getUrgencyColor(int days) {
    if (days <= 3) return AppColors.critical;
    if (days <= 7) return AppColors.warning;
    return AppColors.primary;
  }

  Future<void> _generateCrunchPlan(ExamTarget exam) async {
    if (_isGenerating || exam.syllabusTopics.isEmpty) return;
    setState(() => _isGenerating = true);

    try {
      final gemini = ref.read(geminiServiceProvider);
      final plan = await gemini.generateExamCrunchPlan(exam: exam);
      setState(() => _crunchPlan = plan);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate plan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _openReviewSheet(ExamTarget exam) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewSessionSheet(
        examId: exam.id!,
        examSubject: exam.subject,
      ),
    );
  }

  Future<void> _seedReviewSessions(ExamTarget exam) async {
    if (exam.id == null || exam.syllabusTopics.isEmpty) return;

    final service = ref.read(examServiceProvider);
    final now = DateTime.now();

    for (final topic in exam.syllabusTopics) {
      await service.createReviewSession(
        ReviewSession(
          examTargetId: exam.id,
          topic: topic,
          nextReviewDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );
    }

    ref.invalidate(pendingExamReviewsProvider(exam.id!));
    ref.invalidate(dueReviewSessionsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Created ${exam.syllabusTopics.length} review sessions',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(examByIdProvider(widget.examId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Details'),
        actions: [
          examAsync.whenOrNull(
                data: (exam) {
                  if (exam == null) return null;
                  return IconButton(
                    icon: const Icon(Icons.psychology_rounded),
                    tooltip: 'Review Sessions',
                    onPressed: () => _openReviewSheet(exam),
                  );
                },
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: examAsync.when(
        data: (exam) {
          if (exam == null) {
            return const Center(child: Text('Exam not found.'));
          }
          return _buildBody(context, exam);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ExamTarget exam) {
    final days = exam.daysRemaining;
    final urgencyColor = _getUrgencyColor(days);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Countdown Hero Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(spacingL),
              child: Column(
                children: [
                  // Subject title
                  Text(
                    exam.subject,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: spacingM),

                  // Countdown circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: urgencyColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: urgencyColor.withValues(alpha: 0.5),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            days <= 0 ? '!' : '$days',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: urgencyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            days <= 0
                                ? 'TODAY'
                                : days == 1
                                    ? 'DAY'
                                    : 'DAYS',
                            style: TextStyle(
                              color: urgencyColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: spacingM),

                  // Exam date and location
                  Text(
                    'Exam on ${exam.examDate.toDateString()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  if (exam.roomOrLocation != null) ...[
                    const SizedBox(height: spacingXs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: spacingXs),
                        Text(
                          exam.roomOrLocation!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: spacingS),

                  // Target score badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacingM,
                      vertical: spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(radiusXl),
                    ),
                    child: Text(
                      'Target: ${exam.targetScore.toInt()}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: spacingM),

          // Syllabus Checklist
          Text(
            'Syllabus Progress',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: spacingS),
          SyllabusChecklist(exam: exam),
          const SizedBox(height: spacingL),

          // AI Crunch Plan Section
          Text(
            'AI Study Plan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: spacingS),

          if (_crunchPlan.isEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(spacingM),
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(height: spacingS),
                    Text(
                      'Generate a personalized spaced-repetition study roadmap powered by Gemini AI.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: spacingM),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: exam.syllabusTopics.isEmpty
                            ? null
                            : () => _generateCrunchPlan(exam),
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.auto_awesome_rounded, size: 16),
                        label: Text(
                          _isGenerating
                              ? 'Generating...'
                              : 'Generate Crunch Plan',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            CrunchPlanCard(milestones: _crunchPlan),
          ],
          const SizedBox(height: spacingL),

          // Spaced Repetition Quick Actions
          Text(
            'Spaced Repetition',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: spacingS),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: exam.syllabusTopics.isEmpty
                      ? null
                      : () => _seedReviewSessions(exam),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Seed Reviews'),
                ),
              ),
              const SizedBox(width: spacingS),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      exam.id != null ? () => _openReviewSheet(exam) : null,
                  icon: const Icon(Icons.psychology_rounded, size: 16),
                  label: const Text('Open Reviews'),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacingXl),
        ],
      ),
    );
  }
}
