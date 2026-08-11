import 'dart:developer' as dev;

import '../../../core/database/database_service.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/consistency_streak.dart';
import '../../../models/heatmap_day.dart';

/// ConsistencyService implementation — manages streak tracking and heatmap analytics.
/// Streak rule: User must complete at least 1 task AND log progress on at least 1 goal per day.
class ConsistencyServiceImpl {
  ConsistencyServiceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;

  /// Evaluates and updates all streaks for the previous day.
  /// Should be called on app launch and at midnight.
  Future<void> evaluateStreaks() async {
    final db = await _databaseService.database;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayStr = yesterday.toDateString();
    final now = DateTime.now();

    // Check if yesterday had activity
    final tasksCompleted = await db.rawQuery(
      'SELECT COUNT(*) as count FROM task WHERE is_completed = 1 AND DATE(completed_at) = ?',
      [yesterdayStr],
    );
    final taskCount = (tasksCompleted.first['count'] as int?) ?? 0;

    final goalsProgressed = await db.rawQuery(
      'SELECT COUNT(DISTINCT goal_id) as count FROM goal_progress WHERE date = ?',
      [yesterdayStr],
    );
    final goalCount = (goalsProgressed.first['count'] as int?) ?? 0;

    // Check if there are any active goals (streak requires at least 1 goal if goals exist)
    final activeGoals = await db.rawQuery(
      'SELECT COUNT(*) as count FROM goal WHERE is_active = 1 AND is_archived = 0',
    );
    final hasActiveGoals = ((activeGoals.first['count'] as int?) ?? 0) > 0;

    final yesterdayMet = taskCount > 0 && (!hasActiveGoals || goalCount > 0);

    // Update overall streak
    await _updateStreak(
      streakType: 'OVERALL',
      goalId: null,
      dayMet: yesterdayMet,
      date: yesterdayStr,
      now: now,
    );

    // Update per-goal streaks
    if (hasActiveGoals) {
      final goals = await db.query(
        'goal',
        columns: ['id'],
        where: 'is_active = 1 AND is_archived = 0',
      );

      for (final goalRow in goals) {
        final goalId = goalRow['id'] as int;
        final goalProgress = await db.rawQuery(
          'SELECT COUNT(*) as count FROM goal_progress WHERE goal_id = ? AND date = ?',
          [goalId, yesterdayStr],
        );
        final goalDayMet = ((goalProgress.first['count'] as int?) ?? 0) > 0;

        await _updateStreak(
          streakType: 'GOAL_SPECIFIC',
          goalId: goalId,
          dayMet: goalDayMet,
          date: yesterdayStr,
          now: now,
        );
      }
    }

    dev.log(
      'Streaks evaluated for $yesterdayStr: tasks=$taskCount, goals=$goalCount, met=$yesterdayMet',
      name: 'ConsistencyService',
    );
  }

  /// Returns the overall consistency streak.
  Future<ConsistencyStreak> getOverallStreak() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'consistency_streak',
      where: 'streak_type = ? AND goal_id IS NULL',
      whereArgs: ['OVERALL'],
      limit: 1,
    );

    if (rows.isEmpty) {
      return ConsistencyStreak(
        streakType: 'OVERALL',
        updatedAt: DateTime.now(),
      );
    }

    return _streakFromMap(rows.first);
  }

  /// Returns the streak for a specific goal.
  Future<ConsistencyStreak> getGoalStreak(int goalId) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'consistency_streak',
      where: 'streak_type = ? AND goal_id = ?',
      whereArgs: ['GOAL_SPECIFIC', goalId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return ConsistencyStreak(
        streakType: 'GOAL_SPECIFIC',
        goalId: goalId,
        updatedAt: DateTime.now(),
      );
    }

    return _streakFromMap(rows.first);
  }

  /// Returns all active streaks (overall + per-goal).
  Future<List<ConsistencyStreak>> getAllStreaks() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'consistency_streak',
      orderBy: 'current_streak DESC',
    );
    return rows.map(_streakFromMap).toList();
  }

  /// Returns heatmap data for the past N days.
  Future<List<HeatmapDay>> getHeatmapData({int days = 90}) async {
    final db = await _databaseService.database;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final metrics = await db.query(
      'daily_metric',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        startDate.toDateString(),
        endDate.toDateString(),
      ],
      orderBy: 'date ASC',
    );

    // Create a map for quick lookup
    final metricMap = <String, Map<String, dynamic>>{};
    for (final row in metrics) {
      metricMap[row['date'] as String] = row;
    }

    // Generate entries for all days in range
    final heatmapDays = <HeatmapDay>[];
    for (var i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = date.toDateString();
      final metric = metricMap[dateStr];

      if (metric != null) {
        // Count distinct goals with progress on this day
        final goalCount = await db.rawQuery(
          'SELECT COUNT(DISTINCT goal_id) as count FROM goal_progress WHERE date = ?',
          [dateStr],
        );

        heatmapDays.add(HeatmapDay(
          date: dateStr,
          siaScore: (metric['sia_score'] as num?)?.toDouble() ?? 0.0,
          tasksCompleted: (metric['tasks_completed'] as int?) ?? 0,
          goalsProgressed: (goalCount.first['count'] as int?) ?? 0,
        ));
      } else {
        heatmapDays.add(HeatmapDay(date: dateStr));
      }
    }

    return heatmapDays;
  }

  /// Returns whether today's streak conditions are already met.
  Future<bool> isTodayStreakSecured() async {
    final db = await _databaseService.database;
    final today = DateTime.now().toDateString();

    final tasksCompleted = await db.rawQuery(
      'SELECT COUNT(*) as count FROM task WHERE is_completed = 1 AND DATE(completed_at) = ?',
      [today],
    );
    final hasTask = ((tasksCompleted.first['count'] as int?) ?? 0) > 0;

    final activeGoals = await db.rawQuery(
      'SELECT COUNT(*) as count FROM goal WHERE is_active = 1 AND is_archived = 0',
    );
    final hasActiveGoals = ((activeGoals.first['count'] as int?) ?? 0) > 0;

    if (!hasActiveGoals) return hasTask;

    final goalsProgressed = await db.rawQuery(
      'SELECT COUNT(DISTINCT goal_id) as count FROM goal_progress WHERE date = ?',
      [today],
    );
    final hasGoal = ((goalsProgressed.first['count'] as int?) ?? 0) > 0;

    return hasTask && hasGoal;
  }

  // --- Internal ---

  Future<void> _updateStreak({
    required String streakType,
    required int? goalId,
    required bool dayMet,
    required String date,
    required DateTime now,
  }) async {
    final db = await _databaseService.database;

    final whereClause = goalId != null
        ? 'streak_type = ? AND goal_id = ?'
        : 'streak_type = ? AND goal_id IS NULL';
    final whereArgs = goalId != null
        ? [streakType, goalId]
        : [streakType];

    final existing = await db.query(
      'consistency_streak',
      where: whereClause,
      whereArgs: whereArgs,
      limit: 1,
    );

    if (existing.isEmpty) {
      // Create new streak record
      await db.insert('consistency_streak', {
        'streak_type': streakType,
        'goal_id': goalId,
        'current_streak': dayMet ? 1 : 0,
        'longest_streak': dayMet ? 1 : 0,
        'last_active_date': dayMet ? date : null,
        'streak_start_date': dayMet ? date : null,
        'updated_at': now.toIso8601String(),
      });
    } else {
      final current = existing.first;
      final lastActive = current['last_active_date'] as String?;
      var currentStreak = (current['current_streak'] as int?) ?? 0;
      var longestStreak = (current['longest_streak'] as int?) ?? 0;
      var streakStart = current['streak_start_date'] as String?;

      if (dayMet) {
        // Check if this continues the streak (last active was the day before)
        if (lastActive != null) {
          final lastDate = DateTime.tryParse(lastActive);
          final thisDate = DateTime.tryParse(date);
          if (lastDate != null && thisDate != null) {
            final daysDiff = thisDate.difference(lastDate).inDays;
            if (daysDiff == 1) {
              currentStreak += 1;
            } else if (daysDiff > 1) {
              currentStreak = 1;
              streakStart = date;
            }
          }
        } else {
          currentStreak = 1;
          streakStart = date;
        }

        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }

        await db.update(
          'consistency_streak',
          {
            'current_streak': currentStreak,
            'longest_streak': longestStreak,
            'last_active_date': date,
            'streak_start_date': streakStart,
            'updated_at': now.toIso8601String(),
          },
          where: whereClause,
          whereArgs: whereArgs,
        );
      } else {
        // Streak broken
        await db.update(
          'consistency_streak',
          {
            'current_streak': 0,
            'streak_start_date': null,
            'updated_at': now.toIso8601String(),
          },
          where: whereClause,
          whereArgs: whereArgs,
        );
      }
    }
  }

  ConsistencyStreak _streakFromMap(Map<String, dynamic> map) =>
      ConsistencyStreak(
        id: map['id'] as int?,
        streakType: map['streak_type'] as String,
        goalId: map['goal_id'] as int?,
        currentStreak: (map['current_streak'] as int?) ?? 0,
        longestStreak: (map['longest_streak'] as int?) ?? 0,
        lastActiveDate: map['last_active_date'] as String?,
        streakStartDate: map['streak_start_date'] as String?,
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
