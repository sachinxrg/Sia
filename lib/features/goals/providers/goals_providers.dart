import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../data/goal_service_impl.dart';
import '../data/consistency_service_impl.dart';
import '../../../models/goal.dart';
import '../../../models/consistency_streak.dart';
import '../../../models/heatmap_day.dart';

/// Provider for the GoalService.
final goalServiceProvider = Provider<GoalServiceImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return GoalServiceImpl(databaseService: db);
});

/// Provider for the ConsistencyService.
final consistencyServiceProvider = Provider<ConsistencyServiceImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return ConsistencyServiceImpl(databaseService: db);
});

/// Provider for all active goals.
final activeGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  final service = ref.watch(goalServiceProvider);
  return service.getActiveGoals();
});

/// Provider for goals filtered by category.
final goalsByCategoryProvider =
    FutureProvider.family<List<Goal>, String>((ref, category) async {
  final service = ref.watch(goalServiceProvider);
  return service.getGoalsByCategory(category);
});

/// Provider for goals needing attention today.
final goalsNeedingAttentionProvider = FutureProvider<List<Goal>>((ref) async {
  final service = ref.watch(goalServiceProvider);
  return service.getGoalsNeedingAttention();
});

/// Provider for archived goals.
final archivedGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  final service = ref.watch(goalServiceProvider);
  return service.getArchivedGoals();
});

/// Provider for the overall consistency streak.
final overallStreakProvider = FutureProvider<ConsistencyStreak>((ref) async {
  final service = ref.watch(consistencyServiceProvider);
  return service.getOverallStreak();
});

/// Provider for all streaks.
final allStreaksProvider =
    FutureProvider<List<ConsistencyStreak>>((ref) async {
  final service = ref.watch(consistencyServiceProvider);
  return service.getAllStreaks();
});

/// Provider for heatmap data (90 days).
final heatmapDataProvider = FutureProvider<List<HeatmapDay>>((ref) async {
  final service = ref.watch(consistencyServiceProvider);
  return service.getHeatmapData();
});

/// Provider for whether today's streak is secured.
final isTodayStreakSecuredProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(consistencyServiceProvider);
  return service.isTodayStreakSecured();
});
