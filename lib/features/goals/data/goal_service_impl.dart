import 'dart:developer' as dev;

import '../../../core/database/database_service.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/goal.dart';
import '../../../models/goal_progress.dart';

/// GoalService implementation — manages personal goals CRUD and progress logging.
class GoalServiceImpl {
  GoalServiceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;

  /// Creates a new personal goal.
  Future<Goal> createGoal(Goal goal) async {
    final db = await _databaseService.database;
    final id = await db.insert('goal', {
      'title': goal.title,
      'description': goal.description,
      'category': goal.categoryString,
      'target_type': goal.targetTypeString,
      'target_value': goal.targetValue,
      'unit': goal.unit,
      'deadline': goal.deadline?.toIso8601String(),
      'color': goal.color,
      'is_active': goal.isActive ? 1 : 0,
      'is_archived': goal.isArchived ? 1 : 0,
      'created_at': goal.createdAt.toIso8601String(),
      'updated_at': goal.updatedAt.toIso8601String(),
    });

    dev.log('Created goal: "${goal.title}" (id=$id)', name: 'GoalService');
    return goal.copyWith(id: id);
  }

  /// Updates an existing goal.
  Future<Goal> updateGoal(Goal goal) async {
    final db = await _databaseService.database;
    await db.update(
      'goal',
      {
        'title': goal.title,
        'description': goal.description,
        'category': goal.categoryString,
        'target_type': goal.targetTypeString,
        'target_value': goal.targetValue,
        'unit': goal.unit,
        'deadline': goal.deadline?.toIso8601String(),
        'color': goal.color,
        'is_active': goal.isActive ? 1 : 0,
        'is_archived': goal.isArchived ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [goal.id],
    );
    dev.log(
      'Updated goal: "${goal.title}" (id=${goal.id})',
      name: 'GoalService',
    );
    return goal;
  }

  /// Archives a goal (soft-remove from active list).
  Future<void> archiveGoal(int goalId) async {
    final db = await _databaseService.database;
    await db.update(
      'goal',
      {
        'is_archived': 1,
        'is_active': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [goalId],
    );
    dev.log('Archived goal id=$goalId', name: 'GoalService');
  }

  /// Permanently deletes a goal and its progress entries.
  Future<void> deleteGoal(int goalId) async {
    final db = await _databaseService.database;
    await db.delete('goal_progress', where: 'goal_id = ?', whereArgs: [goalId]);
    await db.delete('goal', where: 'id = ?', whereArgs: [goalId]);
    dev.log('Deleted goal id=$goalId', name: 'GoalService');
  }

  /// Returns all active (non-archived) goals.
  Future<List<Goal>> getActiveGoals() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'goal',
      where: 'is_active = 1 AND is_archived = 0',
      orderBy: 'created_at DESC',
    );
    return rows.map(_goalFromMap).toList();
  }

  /// Returns all goals for a given category.
  Future<List<Goal>> getGoalsByCategory(String category) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'goal',
      where: 'category = ? AND is_active = 1 AND is_archived = 0',
      whereArgs: [category.toUpperCase()],
    );
    return rows.map(_goalFromMap).toList();
  }

  /// Returns all archived goals.
  Future<List<Goal>> getArchivedGoals() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'goal',
      where: 'is_archived = 1',
      orderBy: 'updated_at DESC',
    );
    return rows.map(_goalFromMap).toList();
  }

  /// Logs progress for a goal on a specific date.
  Future<GoalProgress> logProgress({
    required int goalId,
    required double value,
    required DateTime date,
    String? note,
  }) async {
    final db = await _databaseService.database;
    final now = DateTime.now();

    final progress = GoalProgress(
      goalId: goalId,
      date: date.toDateString(),
      value: value,
      note: note,
      createdAt: now,
    );

    final id = await db.insert('goal_progress', {
      'goal_id': progress.goalId,
      'date': progress.date,
      'value': progress.value,
      'note': progress.note,
      'created_at': progress.createdAt.toIso8601String(),
    });

    dev.log(
      'Logged progress: goal=$goalId, value=$value, date=${progress.date}',
      name: 'GoalService',
    );
    return progress.copyWith(id: id);
  }

  /// Returns progress entries for a goal within a date range.
  Future<List<GoalProgress>> getProgress({
    required int goalId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'goal_progress',
      where: 'goal_id = ? AND date >= ? AND date <= ?',
      whereArgs: [
        goalId,
        startDate.toDateString(),
        endDate.toDateString(),
      ],
      orderBy: 'date DESC',
    );
    return rows.map(_progressFromMap).toList();
  }

  /// Returns today's total progress value for a goal.
  Future<double> getTodayProgressValue(int goalId) async {
    final db = await _databaseService.database;
    final today = DateTime.now().toDateString();
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(value), 0.0) as total FROM goal_progress WHERE goal_id = ? AND date = ?',
      [goalId, today],
    );
    return (result.first['total'] as num).toDouble();
  }

  /// Returns today's completion percentage for a daily habit goal.
  Future<double> getTodayCompletionPercent(int goalId) async {
    final goal = await _getGoalById(goalId);
    if (goal == null || goal.targetValue <= 0) return 0.0;
    final todayValue = await getTodayProgressValue(goalId);
    return (todayValue / goal.targetValue * 100).clamp(0.0, 100.0);
  }

  /// Returns this week's completion percentage for a weekly target goal.
  Future<double> getWeekCompletionPercent(int goalId) async {
    final goal = await _getGoalById(goalId);
    if (goal == null || goal.targetValue <= 0) return 0.0;

    final db = await _databaseService.database;
    final now = DateTime.now();
    final weekStart = now.startOfWeek.toDateString();
    final weekEnd = now.endOfWeek.toDateString();

    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(value), 0.0) as total FROM goal_progress WHERE goal_id = ? AND date >= ? AND date <= ?',
      [goalId, weekStart, weekEnd],
    );
    final weekTotal = (result.first['total'] as num).toDouble();
    return (weekTotal / goal.targetValue * 100).clamp(0.0, 100.0);
  }

  /// Returns goals that need attention today (active daily habits with no progress logged).
  Future<List<Goal>> getGoalsNeedingAttention() async {
    final db = await _databaseService.database;
    final today = DateTime.now().toDateString();

    final rows = await db.rawQuery(
      '''
      SELECT g.* FROM goal g
      WHERE g.is_active = 1 AND g.is_archived = 0
      AND g.target_type = 'DAILY_HABIT'
      AND g.id NOT IN (
        SELECT DISTINCT goal_id FROM goal_progress WHERE date = ?
      )
    ''',
      [today],
    );

    return rows.map(_goalFromMap).toList();
  }

  Future<Goal?> _getGoalById(int goalId) async {
    final db = await _databaseService.database;
    final rows = await db.query('goal', where: 'id = ?', whereArgs: [goalId]);
    if (rows.isEmpty) return null;
    return _goalFromMap(rows.first);
  }

  Goal _goalFromMap(Map<String, dynamic> map) => Goal(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String?,
        category: _parseCategory(map['category'] as String),
        targetType: _parseTargetType(map['target_type'] as String),
        targetValue: (map['target_value'] as num).toDouble(),
        unit: map['unit'] as String? ?? 'hours',
        deadline: map['deadline'] != null
            ? DateTime.tryParse(map['deadline'] as String)
            : null,
        color: map['color'] as String? ?? '#6C5CE7',
        isActive: (map['is_active'] as int?) == 1,
        isArchived: (map['is_archived'] as int?) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  GoalProgress _progressFromMap(Map<String, dynamic> map) => GoalProgress(
        id: map['id'] as int?,
        goalId: map['goal_id'] as int,
        date: map['date'] as String,
        value: (map['value'] as num).toDouble(),
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  GoalCategory _parseCategory(String category) {
    switch (category.toUpperCase()) {
      case 'FITNESS':
        return GoalCategory.fitness;
      case 'SKILL':
        return GoalCategory.skill;
      case 'PERSONAL':
        return GoalCategory.personal;
      default:
        return GoalCategory.academic;
    }
  }

  GoalTargetType _parseTargetType(String targetType) {
    switch (targetType.toUpperCase()) {
      case 'WEEKLY_TARGET':
        return GoalTargetType.weeklyTarget;
      case 'DEADLINE_GOAL':
        return GoalTargetType.deadlineGoal;
      default:
        return GoalTargetType.dailyHabit;
    }
  }
}
