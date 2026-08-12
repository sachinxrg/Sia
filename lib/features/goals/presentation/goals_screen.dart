import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/goal.dart';
import '../providers/goals_providers.dart';
import 'widgets/goal_card.dart';
import 'widgets/goal_log_sheet.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  String? _selectedCategory;

  void _showCreateGoalSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final targetValueController = TextEditingController(text: '1.0');
    final unitController = TextEditingController(text: 'hours');

    GoalCategory category = GoalCategory.academic;
    GoalTargetType targetType = GoalTargetType.dailyHabit;
    DateTime? deadline;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
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
                'Create Personal Goal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: spacingM),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Goal Title',
                  hintText: 'e.g. Study 2 hours of DSA daily',
                ),
              ),
              const SizedBox(height: spacingM),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<GoalCategory>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: GoalCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => category = val);
                      },
                    ),
                  ),
                  const SizedBox(width: spacingS),
                  Expanded(
                    child: DropdownButtonFormField<GoalTargetType>(
                      initialValue: targetType,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: GoalTargetType.values
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => targetType = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spacingM),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: targetValueController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Target Value'),
                    ),
                  ),
                  const SizedBox(width: spacingS),
                  Expanded(
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(labelText: 'Unit (e.g. hours)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spacingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    final goal = Goal(
                      title: titleController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                      category: category,
                      targetType: targetType,
                      targetValue: double.tryParse(targetValueController.text.trim()) ?? 1.0,
                      unit: unitController.text.trim().isEmpty
                          ? 'hours'
                          : unitController.text.trim(),
                      deadline: deadline,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await ref.read(goalServiceProvider).createGoal(goal);
                    ref.invalidate(activeGoalsProvider);
                    ref.invalidate(goalsNeedingAttentionProvider);

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Goal'),
                ),
              ),
              const SizedBox(height: spacingM),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeGoalsAsync = _selectedCategory == null
        ? ref.watch(activeGoalsProvider)
        : ref.watch(goalsByCategoryProvider(_selectedCategory!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department_rounded,
                color: AppColors.warning),
            onPressed: () => context.go('/goals/consistency'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                  const SizedBox(width: spacingS),
                  ...GoalCategory.values.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: spacingS),
                      child: ChoiceChip(
                        label: Text(cat.name.toUpperCase()),
                        selected: _selectedCategory == cat.name.toUpperCase(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory =
                                selected ? cat.name.toUpperCase() : null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: spacingM),

            // Active Goals List
            activeGoalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(spacingL),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.flag_outlined,
                                size: 48, color: AppColors.onSurfaceVariant),
                            const SizedBox(height: spacingS),
                            Text(
                              'No active goals found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: spacingXs),
                            Text(
                              'Set your first goal and let SIA help you build consistency.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: spacingM,
                    crossAxisSpacing: spacingM,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GoalCard(
                      goal: goal,
                      onTap: () => context.go('/goals/${goal.id}'),
                      onLogTap: () {
                        if (goal.id != null) {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => GoalLogSheet(goal: goal),
                          );
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading goals: $err')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoalSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
