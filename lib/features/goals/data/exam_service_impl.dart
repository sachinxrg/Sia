import 'dart:developer' as dev;

import '../../../core/database/database_service.dart';
import '../../../models/exam_target.dart';
import '../../../models/review_session.dart';

/// Service managing exam schedules, syllabus tracking, and Leitner spaced-repetition reviews.
class ExamServiceImpl {
  ExamServiceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  final DatabaseService _databaseService;

  /// Creates a new examination target.
  Future<int> createExam(ExamTarget exam) async {
    final db = await _databaseService.database;
    final id = await db.insert('exam_target', exam.toJson());
    dev.log(
      'Created exam target for ${exam.subject} (id: $id)',
      name: 'ExamService',
    );
    return id;
  }

  /// Returns upcoming exams ordered chronologically.
  Future<List<ExamTarget>> getUpcomingExams() async {
    final db = await _databaseService.database;
    final todayIso = DateTime.now().toIso8601String().substring(0, 10);
    final rows = await db.query(
      'exam_target',
      where: 'exam_date >= ?',
      whereArgs: [todayIso],
      orderBy: 'exam_date ASC',
    );
    return rows.map((r) => ExamTarget.fromJson(r)).toList();
  }

  /// Returns all tracked exams.
  Future<List<ExamTarget>> getAllExams() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'exam_target',
      orderBy: 'exam_date ASC',
    );
    return rows.map((r) => ExamTarget.fromJson(r)).toList();
  }

  /// Updates an existing exam target.
  Future<int> updateExam(ExamTarget exam) async {
    if (exam.id == null) return 0;
    final db = await _databaseService.database;
    return await db.update(
      'exam_target',
      exam.toJson(),
      where: 'id = ?',
      whereArgs: [exam.id],
    );
  }

  /// Deletes an exam target and cascading review sessions.
  Future<int> deleteExam(int id) async {
    final db = await _databaseService.database;
    return await db.delete(
      'exam_target',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Creates a spaced-repetition review session for a topic.
  Future<int> createReviewSession(ReviewSession session) async {
    final db = await _databaseService.database;
    return await db.insert('review_session', session.toJson());
  }

  /// Fetches pending review sessions for an exam.
  Future<List<ReviewSession>> getPendingReviewsForExam(int examId) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'review_session',
      where: 'exam_target_id = ? AND is_completed = 0',
      whereArgs: [examId],
      orderBy: 'next_review_date ASC',
    );
    return rows.map((r) => ReviewSession.fromJson(r)).toList();
  }

  /// Advances or resets a review session interval based on student recall performance.
  Future<void> progressReviewSession({
    required ReviewSession session,
    required bool remembered,
  }) async {
    if (session.id == null) return;
    final db = await _databaseService.database;
    final now = DateTime.now();

    final nextLevel = remembered ? session.level.next : session.level.reset;
    final nextDate = now.add(Duration(days: nextLevel.intervalDays));

    await db.update(
      'review_session',
      {
        'level': nextLevel.toStorageKey(),
        'next_review_date': nextDate.toIso8601String(),
        'last_reviewed_at': now.toIso8601String(),
        'is_completed':
            (remembered && session.level == SpacedRepetitionLevel.box5) ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  /// Fetches a single exam target by its database ID.
  Future<ExamTarget?> getExamById(int id) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'exam_target',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ExamTarget.fromJson(rows.first);
  }

  /// Returns all review sessions due today or overdue across all exams.
  Future<List<ReviewSession>> getDueReviewSessions() async {
    final db = await _databaseService.database;
    final endOfToday = DateTime.now();
    final endOfTodayIso = DateTime(
      endOfToday.year,
      endOfToday.month,
      endOfToday.day,
      23,
      59,
      59,
    ).toIso8601String();
    final rows = await db.query(
      'review_session',
      where: 'is_completed = 0 AND next_review_date <= ?',
      whereArgs: [endOfTodayIso],
      orderBy: 'next_review_date ASC',
    );
    return rows.map((r) => ReviewSession.fromJson(r)).toList();
  }

  /// Returns past exams whose exam date has already passed.
  Future<List<ExamTarget>> getPastExams() async {
    final db = await _databaseService.database;
    final todayIso = DateTime.now().toIso8601String().substring(0, 10);
    final rows = await db.query(
      'exam_target',
      where: 'exam_date < ?',
      whereArgs: [todayIso],
      orderBy: 'exam_date DESC',
    );
    return rows.map((r) => ExamTarget.fromJson(r)).toList();
  }

  /// Toggles a syllabus topic as completed or uncompleted by adjusting the count.
  /// [completed] = true increments, false decrements (clamped to 0..topicCount).
  Future<void> toggleSyllabusTopic({
    required int examId,
    required bool completed,
  }) async {
    final db = await _databaseService.database;
    final exam = await getExamById(examId);
    if (exam == null) return;

    final currentCount = exam.completedTopicsCount;
    final maxCount = exam.syllabusTopics.length;
    final newCount = completed
        ? (currentCount + 1).clamp(0, maxCount)
        : (currentCount - 1).clamp(0, maxCount);

    await db.update(
      'exam_target',
      {'completed_topics_count': newCount},
      where: 'id = ?',
      whereArgs: [examId],
    );

    dev.log(
      'Toggled syllabus topic for exam $examId: $currentCount → $newCount',
      name: 'ExamService',
    );
  }
}
