import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/exam_target.dart';
import '../../providers/exam_providers.dart';

/// Interactive syllabus topic checklist with animated checkboxes,
/// progress header, and real-time persistence via ExamServiceImpl.
class SyllabusChecklist extends ConsumerStatefulWidget {
  const SyllabusChecklist({
    super.key,
    required this.exam,
  });

  final ExamTarget exam;

  @override
  ConsumerState<SyllabusChecklist> createState() => _SyllabusChecklistState();
}

class _SyllabusChecklistState extends ConsumerState<SyllabusChecklist> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _initCheckedState();
  }

  @override
  void didUpdateWidget(covariant SyllabusChecklist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exam.id != widget.exam.id ||
        oldWidget.exam.completedTopicsCount !=
            widget.exam.completedTopicsCount) {
      _initCheckedState();
    }
  }

  void _initCheckedState() {
    final total = widget.exam.syllabusTopics.length;
    final completed = widget.exam.completedTopicsCount.clamp(0, total);
    // Mark the first N topics as checked (order-based tracking)
    _checked = List.generate(total, (i) => i < completed);
  }

  int get _completedCount => _checked.where((c) => c).length;

  Future<void> _onToggle(int index, bool? value) async {
    if (widget.exam.id == null) return;

    setState(() => _checked[index] = value ?? false);

    await ref.read(examServiceProvider).toggleSyllabusTopic(
          examId: widget.exam.id!,
          completed: value ?? false,
        );
    ref.invalidate(examByIdProvider(widget.exam.id!));
    ref.invalidate(upcomingExamsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final topics = widget.exam.syllabusTopics;
    if (topics.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(spacingM),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: spacingS),
              Text(
                'No syllabus topics added yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final progress = topics.isEmpty
        ? 0.0
        : (_completedCount / topics.length).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Syllabus Coverage',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$_completedCount / ${topics.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: progress >= 1.0
                            ? AppColors.success
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: spacingS),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusSm),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: animNormal,
                curve: Curves.easeInOut,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: spacingS),

            // Topic checklist
            ...List.generate(topics.length, (index) {
              final isChecked = _checked[index];
              return AnimatedContainer(
                duration: animFast,
                child: CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.success,
                  title: Text(
                    topics[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration:
                              isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked
                              ? AppColors.onSurfaceVariant
                              : AppColors.onSurface,
                        ),
                  ),
                  value: isChecked,
                  onChanged: (val) => _onToggle(index, val),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
