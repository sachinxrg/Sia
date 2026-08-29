import 'dart:developer' as dev;

import '../../../core/ai/gemini_service.dart';
import '../../../core/database/database_service.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/ai_personality.dart';
import '../../../models/energy_slot.dart';
import '../../../models/schedule_block.dart';
import '../../../models/task.dart';
import '../../../models/timeline_block.dart';
import '../../../models/timetable_entry.dart';

/// Manages task CRUD operations, schedule queries, and timeline generation.
class ScheduleServiceImpl {
  ScheduleServiceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;

  /// Creates a new task in the database.
  Future<Task> createTask(Task task) async {
    final db = await _databaseService.database;
    final id = await db.insert('task', _taskToMap(task));

    // Update daily metrics
    await _incrementMetric('tasks_created');

    dev.log('Created task: "${task.title}" (id=$id)', name: 'ScheduleService');
    return task.copyWith(id: id);
  }

  /// Updates an existing task.
  Future<Task> updateTask(Task task) async {
    final db = await _databaseService.database;
    await db.update(
      'task',
      _taskToMap(task),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    dev.log(
      'Updated task: "${task.title}" (id=${task.id})',
      name: 'ScheduleService',
    );
    return task;
  }

  /// Soft-deletes a task (sets is_deleted = 1).
  Future<void> deleteTask(int taskId) async {
    final db = await _databaseService.database;
    await db.update(
      'task',
      {'is_deleted': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    dev.log('Soft-deleted task id=$taskId', name: 'ScheduleService');
  }

  /// Marks a task as completed.
  Future<Task> completeTask(int taskId) async {
    final db = await _databaseService.database;
    final now = DateTime.now();
    await db.update(
      'task',
      {
        'is_completed': 1,
        'completed_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );

    await _incrementMetric('tasks_completed');

    final rows = await db.query('task', where: 'id = ?', whereArgs: [taskId]);
    dev.log('Completed task id=$taskId', name: 'ScheduleService');
    return _taskFromMap(rows.first);
  }

  /// Returns all active (non-deleted) tasks for a given date.
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final db = await _databaseService.database;
    final dateStr = date.toDateString();
    final rows = await db.query(
      'task',
      where: '''
        is_deleted = 0 AND (
          (deadline IS NOT NULL AND DATE(deadline) = ?) OR
          (scheduled_start IS NOT NULL AND DATE(scheduled_start) = ?)
        )
      ''',
      whereArgs: [dateStr, dateStr],
      orderBy: 'COALESCE(scheduled_start, deadline) ASC',
    );
    return rows.map(_taskFromMap).toList();
  }

  /// Returns all overdue tasks.
  Future<List<Task>> getOverdueTasks() async {
    final db = await _databaseService.database;
    final now = DateTime.now().toIso8601String();
    final rows = await db.query(
      'task',
      where:
          'is_completed = 0 AND is_deleted = 0 AND deadline IS NOT NULL AND deadline < ?',
      whereArgs: [now],
      orderBy: 'deadline ASC',
    );
    return rows.map(_taskFromMap).toList();
  }

  /// Returns all pending (incomplete, non-deleted) tasks.
  Future<List<Task>> getPendingTasks() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'task',
      where: 'is_completed = 0 AND is_deleted = 0',
      orderBy:
          'CASE priority WHEN "CRITICAL" THEN 0 WHEN "HIGH" THEN 1 WHEN "MEDIUM" THEN 2 ELSE 3 END, deadline ASC',
    );
    return rows.map(_taskFromMap).toList();
  }

  /// Returns the daily timeline merging timetable entries and tasks.
  Future<List<TimelineBlock>> getDailyTimeline(DateTime date) async {
    final blocks = <TimelineBlock>[];

    // 1. Add timetable entries as fixed blocks
    final timetableEntries = await _getTimetableForDay(date);
    for (final entry in timetableEntries) {
      blocks.add(
        TimelineBlock(
          title: entry.subject,
          type: 'CLASS',
          startTime: entry.startTime,
          endTime: entry.endTime,
          subtitle: entry.room,
          colorHex: '#6C5CE7',
          isFixed: true,
        ),
      );
    }

    // 2. Add tasks as editable blocks
    final tasks = await getTasksForDate(date);
    for (final task in tasks) {
      if (task.scheduledStart != null && task.scheduledEnd != null) {
        blocks.add(
          TimelineBlock(
            title: task.title,
            type: task.isCompleted ? 'DONE' : 'TASK',
            startTime: task.scheduledStart!.toTimeString(),
            endTime: task.scheduledEnd!.toTimeString(),
            taskId: task.id,
            colorHex: _priorityToHex(task.priority),
          ),
        );
      }
    }

    // 3. Sort by start time
    blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    // 4. Mark current block
    final now = DateTime.now();
    if (now.isSameDay(date)) {
      final currentTimeStr = now.toTimeString();
      for (var i = 0; i < blocks.length; i++) {
        if (blocks[i].startTime.compareTo(currentTimeStr) <= 0 &&
            blocks[i].endTime.compareTo(currentTimeStr) > 0) {
          blocks[i] = blocks[i].copyWith(isCurrent: true);
          break;
        }
      }
    }

    return blocks;
  }

  /// Adaptively reschedules pending tasks for the remainder of [currentTime]'s day using [geminiService].
  /// Persists newly assigned scheduled_start and scheduled_end times to the database.
  Future<List<ScheduleBlock>> adaptiveReschedule({
    required GeminiService geminiService,
    required DateTime currentTime,
    String? delayedTaskTitle,
    int? delayedMinutes,
    List<EnergySlot>? energySlots,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) async {
    final pendingTasks = await getPendingTasks();
    if (pendingTasks.isEmpty) return [];

    final timetable = await _getTimetableForDay(currentTime);
    final slots = energySlots ?? EnergySlot.defaultCircadianSlots();

    final rescheduledBlocks = await geminiService.rescheduleAdaptive(
      currentTime: currentTime,
      remainingTasks: pendingTasks,
      fixedTimetable: timetable,
      energySlots: slots,
      delayedTaskTitle: delayedTaskTitle,
      delayedMinutes: delayedMinutes,
      personality: personality,
    );

    if (rescheduledBlocks.isEmpty) return [];

    final db = await _databaseService.database;
    final datePrefix = currentTime.toDateString();

    for (final block in rescheduledBlocks) {
      if (block.taskId != null && block.type == BlockType.task) {
        final startIso = '${datePrefix}T${block.startTime}:00';
        final endIso = '${datePrefix}T${block.endTime}:00';

        await db.update(
          'task',
          {
            'scheduled_start': startIso,
            'scheduled_end': endIso,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [block.taskId],
        );
      }
    }

    dev.log(
      'Adaptively rescheduled ${rescheduledBlocks.length} blocks starting from $currentTime',
      name: 'ScheduleService',
    );

    return rescheduledBlocks;
  }

  /// Returns timetable entries for a specific day of the week.
  Future<List<TimetableEntry>> _getTimetableForDay(DateTime date) async {
    final db = await _databaseService.database;
    final dayStr = date.dayOfWeekString;
    final rows = await db.query(
      'timetable_entry',
      where: 'day_of_week = ? AND is_active = 1',
      whereArgs: [dayStr],
      orderBy: 'start_time ASC',
    );
    return rows.map(_timetableFromMap).toList();
  }

  // --- Timetable CRUD ---

  /// Creates a timetable entry.
  Future<TimetableEntry> createTimetableEntry(TimetableEntry entry) async {
    final db = await _databaseService.database;
    final id = await db.insert('timetable_entry', {
      'subject': entry.subject,
      'day_of_week': entry.dayOfWeek,
      'start_time': entry.startTime,
      'end_time': entry.endTime,
      'room': entry.room,
      'teacher': entry.teacher,
      'is_active': entry.isActive ? 1 : 0,
      'created_at': entry.createdAt.toIso8601String(),
    });
    return entry.copyWith(id: id);
  }

  /// Returns all timetable entries.
  Future<List<TimetableEntry>> getAllTimetableEntries() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'timetable_entry',
      where: 'is_active = 1',
      orderBy:
          "CASE day_of_week WHEN 'MONDAY' THEN 0 WHEN 'TUESDAY' THEN 1 WHEN 'WEDNESDAY' THEN 2 WHEN 'THURSDAY' THEN 3 WHEN 'FRIDAY' THEN 4 WHEN 'SATURDAY' THEN 5 ELSE 6 END, start_time ASC",
    );
    return rows.map(_timetableFromMap).toList();
  }

  /// Deletes a timetable entry.
  Future<void> deleteTimetableEntry(int entryId) async {
    final db = await _databaseService.database;
    await db.delete('timetable_entry', where: 'id = ?', whereArgs: [entryId]);
  }

  // --- Helpers ---

  Future<void> _incrementMetric(String field) async {
    final db = await _databaseService.database;
    final today = DateTime.now().toDateString();
    final existing = await db.query(
      'daily_metric',
      where: 'date = ?',
      whereArgs: [today],
    );

    if (existing.isEmpty) {
      final initialScore = field == 'tasks_completed' ? 70.0 : 0.0;
      await db.insert('daily_metric', {
        'date': today,
        field: 1,
        'sia_score': initialScore,
        'created_at': DateTime.now().toIso8601String(),
      });
    } else {
      await db.rawUpdate(
        'UPDATE daily_metric SET $field = $field + 1 WHERE date = ?',
        [today],
      );

      // Recalculate SIA Score dynamically
      final updated = await db.query(
        'daily_metric',
        where: 'date = ?',
        whereArgs: [today],
      );
      if (updated.isNotEmpty) {
        final row = updated.first;
        final created = (row['tasks_created'] as int?) ?? 0;
        final completed = (row['tasks_completed'] as int?) ?? 0;
        final sent = (row['notifications_sent'] as int?) ?? 0;
        final acted = (row['notifications_acted_on'] as int?) ?? 0;

        final compRatio =
            created > 0 ? (completed / created) : (completed > 0 ? 1.0 : 0.0);
        final actRatio = sent > 0 ? (acted / sent) : 0.0;
        final newScore = (compRatio * 70.0 + actRatio * 30.0).clamp(0.0, 100.0);

        await db.update(
          'daily_metric',
          {'sia_score': newScore},
          where: 'date = ?',
          whereArgs: [today],
        );
      }
    }
  }

  Map<String, dynamic> _taskToMap(Task task) => {
        'title': task.title,
        'description': task.description,
        'source': task.sourceString,
        'source_id': task.sourceId,
        'priority': task.priorityString,
        'deadline': task.deadline?.toIso8601String(),
        'scheduled_start': task.scheduledStart?.toIso8601String(),
        'scheduled_end': task.scheduledEnd?.toIso8601String(),
        'is_completed': task.isCompleted ? 1 : 0,
        'is_deleted': task.isDeleted ? 1 : 0,
        'ai_confidence': task.aiConfidence?.toString(),
        'created_at': task.createdAt.toIso8601String(),
        'updated_at': task.updatedAt.toIso8601String(),
        'completed_at': task.completedAt?.toIso8601String(),
      };

  Task _taskFromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String?,
        source: _parseSource(map['source'] as String),
        sourceId: map['source_id'] as int?,
        priority: _parsePriority(map['priority'] as String? ?? 'MEDIUM'),
        deadline: map['deadline'] != null
            ? DateTime.tryParse(map['deadline'] as String)
            : null,
        scheduledStart: map['scheduled_start'] != null
            ? DateTime.tryParse(map['scheduled_start'] as String)
            : null,
        scheduledEnd: map['scheduled_end'] != null
            ? DateTime.tryParse(map['scheduled_end'] as String)
            : null,
        isCompleted: (map['is_completed'] as int?) == 1,
        isDeleted: (map['is_deleted'] as int?) == 1,
        aiConfidence: map['ai_confidence'] != null
            ? double.tryParse(map['ai_confidence'].toString())
            : null,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        completedAt: map['completed_at'] != null
            ? DateTime.tryParse(map['completed_at'] as String)
            : null,
      );

  TimetableEntry _timetableFromMap(Map<String, dynamic> map) => TimetableEntry(
        id: map['id'] as int?,
        subject: map['subject'] as String,
        dayOfWeek: map['day_of_week'] as String,
        startTime: map['start_time'] as String,
        endTime: map['end_time'] as String,
        room: map['room'] as String?,
        teacher: map['teacher'] as String?,
        isActive: (map['is_active'] as int?) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  TaskSource _parseSource(String source) {
    switch (source.toUpperCase()) {
      case 'WHATSAPP':
        return TaskSource.whatsapp;
      case 'CLASSROOM':
        return TaskSource.classroom;
      case 'GMAIL':
        return TaskSource.gmail;
      default:
        return TaskSource.manual;
    }
  }

  TaskPriority _parsePriority(String priority) {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
        return TaskPriority.critical;
      case 'HIGH':
        return TaskPriority.high;
      case 'LOW':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  String _priorityToHex(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return '#E17055';
      case TaskPriority.high:
        return '#FF6B6B';
      case TaskPriority.medium:
        return '#FDCB6E';
      case TaskPriority.low:
        return '#A29BFE';
    }
  }
}
