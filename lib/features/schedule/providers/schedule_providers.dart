import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../../models/task.dart';
import '../../../models/timeline_block.dart';
import '../../../models/timetable_entry.dart';
import '../data/schedule_service_impl.dart';

/// Provider for the ScheduleService.
final scheduleServiceProvider = Provider<ScheduleServiceImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return ScheduleServiceImpl(databaseService: db);
});

/// Provider for today's tasks.
final todayTasksProvider = FutureProvider<List<Task>>((ref) async {
  final service = ref.watch(scheduleServiceProvider);
  return service.getTasksForDate(DateTime.now());
});

/// Provider for overdue tasks.
final overdueTasksProvider = FutureProvider<List<Task>>((ref) async {
  final service = ref.watch(scheduleServiceProvider);
  return service.getOverdueTasks();
});

/// Provider for pending tasks.
final pendingTasksProvider = FutureProvider<List<Task>>((ref) async {
  final service = ref.watch(scheduleServiceProvider);
  return service.getPendingTasks();
});

/// Provider for today's timeline.
final dailyTimelineProvider = FutureProvider<List<TimelineBlock>>((ref) async {
  final service = ref.watch(scheduleServiceProvider);
  return service.getDailyTimeline(DateTime.now());
});

/// Provider for all timetable entries.
final timetableProvider = FutureProvider<List<TimetableEntry>>((ref) async {
  final service = ref.watch(scheduleServiceProvider);
  return service.getAllTimetableEntries();
});
