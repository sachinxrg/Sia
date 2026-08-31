import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../../models/exam_target.dart';
import '../../../models/review_session.dart';
import '../data/exam_service_impl.dart';

/// Provider for the ExamServiceImpl instance.
final examServiceProvider = Provider<ExamServiceImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return ExamServiceImpl(databaseService: db);
});

/// Provider returning list of upcoming active examinations.
final upcomingExamsProvider = FutureProvider<List<ExamTarget>>((ref) async {
  final service = ref.watch(examServiceProvider);
  return service.getUpcomingExams();
});

/// Provider returning all examinations.
final allExamsProvider = FutureProvider<List<ExamTarget>>((ref) async {
  final service = ref.watch(examServiceProvider);
  return service.getAllExams();
});

/// Family provider for fetching a single exam target by ID.
final examByIdProvider =
    FutureProvider.family<ExamTarget?, int>((ref, examId) async {
  final service = ref.watch(examServiceProvider);
  return service.getExamById(examId);
});

/// Family provider for fetching pending spaced repetition reviews for a specific exam.
final pendingExamReviewsProvider =
    FutureProvider.family<List<ReviewSession>, int>((ref, examId) async {
  final service = ref.watch(examServiceProvider);
  return service.getPendingReviewsForExam(examId);
});

/// Provider returning all review sessions due today across all exams.
final dueReviewSessionsProvider =
    FutureProvider<List<ReviewSession>>((ref) async {
  final service = ref.watch(examServiceProvider);
  return service.getDueReviewSessions();
});
