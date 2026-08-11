import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/goal.dart';
import '../../providers/goals_providers.dart';

class GoalLogSheet extends ConsumerStatefulWidget {
  const GoalLogSheet({required this.goal, super.key});

  final Goal goal;

  @override
  ConsumerState<GoalLogSheet> createState() => _GoalLogSheetState();
}

class _GoalLogSheetState extends ConsumerState<GoalLogSheet> {
  final _valueController = TextEditingController(text: '1.0');
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitLog() async {
    final value = double.tryParse(_valueController.text.trim());
    if (value == null || value <= 0 || widget.goal.id == null) return;

    setState(() => _isLoading = true);
    try {
      final goalService = ref.read(goalServiceProvider);
      await goalService.logProgress(
        goalId: widget.goal.id!,
        value: value,
        date: DateTime.now(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      // Re-evaluate consistency streaks
      final consistencyService = ref.read(consistencyServiceProvider);
      await consistencyService.evaluateStreaks();

      ref.invalidate(activeGoalsProvider);
      ref.invalidate(goalsNeedingAttentionProvider);
      ref.invalidate(overallStreakProvider);
      ref.invalidate(isTodayStreakSecuredProvider);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log progress: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: spacingM,
        right: spacingM,
        top: spacingM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Progress for ${widget.goal.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: spacingS),
          Text(
            'Target: ${widget.goal.targetDescription}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: spacingM),
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Progress Value (${widget.goal.unit})',
              hintText: 'e.g. 1.5',
            ),
          ),
          const SizedBox(height: spacingM),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (Optional)',
              hintText: 'Completed module 2',
            ),
          ),
          const SizedBox(height: spacingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: spacingM),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Log Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: spacingM),
        ],
      ),
    );
  }
}
