import 'package:flutter_test/flutter_test.dart';
import 'package:sia/core/ai/prompts.dart';
import 'package:sia/core/database/database_service.dart';
import 'package:sia/features/goals/data/exam_service_impl.dart';
import 'package:sia/models/ai_personality.dart';
import 'package:sia/models/exam_target.dart';
import 'package:sia/models/review_session.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late ExamServiceImpl examService;

  setUp(() async {
    dbService = DatabaseService.instance;
    await dbService.database;
    examService = ExamServiceImpl(databaseService: dbService);
  });

  tearDown(() async {
    await dbService.close();
  });

  group('ExamTarget & Spaced Repetition Logic Tests', () {
    test('ExamTarget model calculations and serialization', () {
      final now = DateTime.now();
      final examDate = now.add(const Duration(days: 5));

      final exam = ExamTarget(
        id: 1,
        subject: 'Compiler Design',
        examDate: examDate,
        targetScore: 95.0,
        syllabusTopics: ['Lexical Analysis', 'Parsing', 'Code Gen'],
        completedTopicsCount: 2,
        roomOrLocation: 'Hall 4',
        createdAt: now,
      );

      expect(exam.daysRemaining, inInclusiveRange(4, 5));
      expect(exam.isCrunchTime, isTrue);
      expect(exam.syllabusProgress, closeTo(2 / 3, 0.01));

      final json = exam.toJson();
      final restored = ExamTarget.fromJson(json);

      expect(restored.subject, equals('Compiler Design'));
      expect(restored.syllabusTopics.length, equals(3));
      expect(restored.completedTopicsCount, equals(2));
      expect(restored.roomOrLocation, equals('Hall 4'));
    });

    test('SpacedRepetitionLevel Leitner box progression and reset', () {
      expect(SpacedRepetitionLevel.box1.intervalDays, equals(1));
      expect(SpacedRepetitionLevel.box2.intervalDays, equals(3));
      expect(SpacedRepetitionLevel.box3.intervalDays, equals(7));
      expect(SpacedRepetitionLevel.box4.intervalDays, equals(14));
      expect(SpacedRepetitionLevel.box5.intervalDays, equals(30));

      expect(
          SpacedRepetitionLevel.box1.next, equals(SpacedRepetitionLevel.box2));
      expect(
          SpacedRepetitionLevel.box2.next, equals(SpacedRepetitionLevel.box3));
      expect(
          SpacedRepetitionLevel.box3.next, equals(SpacedRepetitionLevel.box4));
      expect(
          SpacedRepetitionLevel.box4.next, equals(SpacedRepetitionLevel.box5));
      expect(
          SpacedRepetitionLevel.box5.next, equals(SpacedRepetitionLevel.box5));

      expect(
          SpacedRepetitionLevel.box4.reset, equals(SpacedRepetitionLevel.box1));

      expect(
        SpacedRepetitionLevel.fromString('box3'),
        equals(SpacedRepetitionLevel.box3),
      );
      expect(
        SpacedRepetitionLevel.fromString('invalid'),
        equals(SpacedRepetitionLevel.box1),
      );
    });

    test('ReviewSession model serialization and isDue check', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 2));
      final futureDate = DateTime.now().add(const Duration(days: 4));

      final dueReview = ReviewSession(
        topic: 'LL(1) Parsing Table',
        nextReviewDate: pastDate,
        createdAt: DateTime.now(),
      );
      expect(dueReview.isDue, isTrue);

      final upcomingReview = ReviewSession(
        topic: 'LR(1) Parsing Table',
        nextReviewDate: futureDate,
        createdAt: DateTime.now(),
      );
      expect(upcomingReview.isDue, isFalse);

      final json = dueReview.toJson();
      final restored = ReviewSession.fromJson(json);
      expect(restored.topic, equals('LL(1) Parsing Table'));
      expect(restored.isCompleted, isFalse);
    });

    test(
        'Prompts.examCrunchSchedule string formatting and personality injection',
        () {
      final prompt = Prompts.examCrunchSchedule(
        subject: 'Computer Networks',
        examDate: '2026-09-15',
        daysRemaining: 16,
        syllabusTopics: ['TCP/IP', 'Routing Algorithms', 'DNS & HTTP'],
        dailyStudyHours: 2.5,
        personality: AiPersonality.strictCoach,
      );

      expect(prompt, contains('Computer Networks'));
      expect(prompt, contains('2026-09-15'));
      expect(prompt, contains('16 days remaining'));
      expect(prompt, contains('2.5 hours'));
      expect(prompt, contains('TCP/IP, Routing Algorithms, DNS & HTTP'));
      expect(prompt, contains('Direct, disciplined, and urgent'));
    });

    test('ExamServiceImpl CRUD lifecycle and review progression', () async {
      final db = await dbService.database;
      await db.delete('exam_target');
      await db.delete('review_session');

      final now = DateTime.now();
      final exam = ExamTarget(
        subject: 'Data Structures',
        examDate: now.add(const Duration(days: 10)),
        targetScore: 90.0,
        syllabusTopics: ['Trees', 'Graphs', 'DP'],
        createdAt: now,
      );

      final examId = await examService.createExam(exam);
      expect(examId, greaterThan(0));

      final upcoming = await examService.getUpcomingExams();
      expect(upcoming.length, equals(1));
      expect(upcoming.first.subject, equals('Data Structures'));

      // Create a review session
      final session = ReviewSession(
        examTargetId: examId,
        topic: 'Dynamic Programming',
        level: SpacedRepetitionLevel.box1,
        nextReviewDate: now,
        createdAt: now,
      );

      final sessionId = await examService.createReviewSession(session);
      expect(sessionId, greaterThan(0));

      final reviews = await examService.getPendingReviewsForExam(examId);
      expect(reviews.length, equals(1));

      // Progress review with remembered = true
      await examService.progressReviewSession(
        session: reviews.first,
        remembered: true,
      );

      final updatedRows = await db.query(
        'review_session',
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      expect(updatedRows.first['level'], equals('box2'));
    });
  });
}
