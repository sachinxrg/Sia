import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/exam_target.dart';
import '../../providers/exam_providers.dart';

/// Modal bottom sheet for creating a new exam target with subject, date,
/// syllabus topics, target score, and optional room/location.
class CreateExamDialog extends ConsumerStatefulWidget {
  const CreateExamDialog({super.key});

  @override
  ConsumerState<CreateExamDialog> createState() => _CreateExamDialogState();
}

class _CreateExamDialogState extends ConsumerState<CreateExamDialog> {
  final _subjectController = TextEditingController();
  final _topicsController = TextEditingController();
  final _roomController = TextEditingController();
  DateTime _examDate = DateTime.now().add(const Duration(days: 7));
  double _targetScore = 80.0;

  @override
  void dispose() {
    _subjectController.dispose();
    _topicsController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _examDate = picked);
    }
  }

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) return;

    final topicsRaw = _topicsController.text.trim();
    final topics = topicsRaw.isEmpty
        ? <String>[]
        : topicsRaw
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

    final exam = ExamTarget(
      subject: subject,
      examDate: _examDate,
      targetScore: _targetScore,
      syllabusTopics: topics,
      roomOrLocation: _roomController.text.trim().isEmpty
          ? null
          : _roomController.text.trim(),
      createdAt: DateTime.now(),
    );

    await ref.read(examServiceProvider).createExam(exam);
    ref.invalidate(upcomingExamsProvider);
    ref.invalidate(allExamsProvider);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final daysUntil = _examDate.difference(DateTime.now()).inDays;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: spacingM,
        right: spacingM,
        top: spacingM,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Exam Target',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: spacingM),

            // Subject
            TextField(
              controller: _subjectController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g. Data Structures & Algorithms',
              ),
            ),
            const SizedBox(height: spacingM),

            // Exam Date Picker
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(radiusMd),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Exam Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_examDate.day}/${_examDate.month}/${_examDate.year}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: spacingS,
                            vertical: spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: daysUntil <= 7
                                ? AppColors.critical.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(radiusSm),
                          ),
                          child: Text(
                            '$daysUntil days',
                            style: TextStyle(
                              color: daysUntil <= 7
                                  ? AppColors.critical
                                  : AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: spacingS),
                        const Icon(Icons.calendar_month_rounded, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: spacingM),

            // Target Score Slider
            Text(
              'Target Score: ${_targetScore.toInt()}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            Slider(
              value: _targetScore,
              min: 30,
              max: 100,
              divisions: 14,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.surfaceVariant,
              onChanged: (val) => setState(() => _targetScore = val),
            ),
            const SizedBox(height: spacingS),

            // Syllabus Topics
            TextField(
              controller: _topicsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Syllabus Topics (comma-separated)',
                hintText: 'e.g. Arrays, Trees, Graphs, DP',
              ),
            ),
            const SizedBox(height: spacingM),

            // Room / Location
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(
                labelText: 'Room / Location (optional)',
                hintText: 'e.g. Hall A, Room 302',
              ),
            ),
            const SizedBox(height: spacingL),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Exam Target'),
              ),
            ),
            const SizedBox(height: spacingM),
          ],
        ),
      ),
    );
  }
}
