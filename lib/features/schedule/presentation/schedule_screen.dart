import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/task.dart';
import '../providers/schedule_providers.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime? selectedDeadline;

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
                'Add Manual Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: spacingM),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g. Read Chapter 4 of OS',
                ),
              ),
              const SizedBox(height: spacingM),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                ),
              ),
              const SizedBox(height: spacingM),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      initialValue: selectedPriority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: TaskPriority.values
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() => selectedPriority = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: spacingS),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setSheetState(() => selectedDeadline = date);
                        }
                      },
                      child: Text(
                        selectedDeadline == null
                            ? 'Set Deadline'
                            : selectedDeadline!.toDateString(),
                      ),
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

                    final task = Task(
                      title: titleController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                      source: TaskSource.manual,
                      priority: selectedPriority,
                      deadline: selectedDeadline,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await ref.read(scheduleServiceProvider).createTask(task);
                    ref.invalidate(pendingTasksProvider);
                    ref.invalidate(todayTasksProvider);
                    ref.invalidate(dailyTimelineProvider);

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Task'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule & Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded),
            tooltip: 'Timetable Editor',
            onPressed: () => context.go('/schedule/timetable'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Overdue'),
            Tab(text: 'Timetable'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(ref.watch(pendingTasksProvider)),
          _buildTaskList(ref.watch(overdueTasksProvider)),
          _buildTimetableTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildTaskList(AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks found in this view'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(spacingM),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key('task_${task.id}'),
              background: Container(
                color: AppColors.error,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: spacingM),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (_) async {
                if (task.id != null) {
                  await ref.read(scheduleServiceProvider).deleteTask(task.id!);
                  ref.invalidate(pendingTasksProvider);
                  ref.invalidate(overdueTasksProvider);
                }
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: spacingS),
                child: ListTile(
                  onTap: () => context.go('/schedule/task/${task.id}'),
                  leading: IconButton(
                    icon: Icon(
                      task.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: task.isCompleted
                          ? AppColors.success
                          : AppColors.primaryLight,
                    ),
                    onPressed: () async {
                      if (task.id != null) {
                        await ref
                            .read(scheduleServiceProvider)
                            .completeTask(task.id!);
                        ref.invalidate(pendingTasksProvider);
                        ref.invalidate(overdueTasksProvider);
                        ref.invalidate(todayTasksProvider);
                        ref.invalidate(dailyTimelineProvider);
                      }
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    '${task.sourceString} • ${task.deadline != null ? task.deadline!.toRelativeString() : "No deadline"}',
                  ),
                  trailing: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.priorityColor(task.priorityString),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildTimetableTab() {
    final timetableAsync = ref.watch(timetableProvider);

    return timetableAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No timetable entries created'),
                const SizedBox(height: spacingM),
                ElevatedButton(
                  onPressed: () => context.go('/schedule/timetable'),
                  child: const Text('Edit Timetable'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(spacingM),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Card(
              child: ListTile(
                title: Text(entry.subject),
                subtitle: Text(
                  '${entry.dayOfWeek} • ${entry.startTime} - ${entry.endTime} ${entry.room != null ? "(${entry.room})" : ""}',
                ),
                leading: const Icon(
                  Icons.school_rounded,
                  color: AppColors.classroom,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
