import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/timetable_entry.dart';
import '../providers/schedule_providers.dart';

class TimetableEditorScreen extends ConsumerStatefulWidget {
  const TimetableEditorScreen({super.key});

  @override
  ConsumerState<TimetableEditorScreen> createState() =>
      _TimetableEditorScreenState();
}

class _TimetableEditorScreenState
    extends ConsumerState<TimetableEditorScreen> {
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _teacherController = TextEditingController();

  String _selectedDay = 'MONDAY';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  final List<String> _days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _roomController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Add Class Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject Name'),
                ),
                const SizedBox(height: spacingM),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDay,
                  decoration: const InputDecoration(labelText: 'Day of Week'),
                  items: _days
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => _selectedDay = val);
                    }
                  },
                ),
                const SizedBox(height: spacingM),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (time != null) {
                            setDialogState(() => _startTime = time);
                          }
                        },
                        child: Text('Start: ${_startTime.format(context)}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (time != null) {
                            setDialogState(() => _endTime = time);
                          }
                        },
                        child: Text('End: ${_endTime.format(context)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingM),
                TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(labelText: 'Room / Lab'),
                ),
                const SizedBox(height: spacingM),
                TextField(
                  controller: _teacherController,
                  decoration: const InputDecoration(labelText: 'Teacher'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_subjectController.text.trim().isEmpty) return;

                final entry = TimetableEntry(
                  subject: _subjectController.text.trim(),
                  dayOfWeek: _selectedDay,
                  startTime:
                      '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                  endTime:
                      '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                  room: _roomController.text.trim().isEmpty
                      ? null
                      : _roomController.text.trim(),
                  teacher: _teacherController.text.trim().isEmpty
                      ? null
                      : _teacherController.text.trim(),
                  createdAt: DateTime.now(),
                );

                await ref
                    .read(scheduleServiceProvider)
                    .createTimetableEntry(entry);
                ref.invalidate(timetableProvider);
                ref.invalidate(dailyTimelineProvider);

                _subjectController.clear();
                _roomController.clear();
                _teacherController.clear();

                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timetableAsync = ref.watch(timetableProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Editor'),
      ),
      body: timetableAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No timetable entries added.'));
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
                      '${entry.dayOfWeek} • ${entry.startTime} - ${entry.endTime} ${entry.room != null ? "(${entry.room})" : ""}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () async {
                      if (entry.id != null) {
                        await ref
                            .read(scheduleServiceProvider)
                            .deleteTimetableEntry(entry.id!);
                        ref.invalidate(timetableProvider);
                        ref.invalidate(dailyTimelineProvider);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
