import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sia/core/theme/app_theme.dart';
import 'package:sia/features/dashboard/presentation/widgets/exam_countdown_card.dart';
import 'package:sia/features/goals/presentation/exams_screen.dart';
import 'package:sia/features/goals/presentation/widgets/crunch_plan_card.dart';
import 'package:sia/features/goals/presentation/widgets/review_session_tile.dart';
import 'package:sia/features/goals/presentation/widgets/syllabus_checklist.dart';
import 'package:sia/features/goals/providers/exam_providers.dart';
import 'package:sia/models/exam_target.dart';
import 'package:sia/models/review_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testExam = ExamTarget(
    id: 1,
    subject: 'Distributed Systems',
    examDate: DateTime.now().add(const Duration(days: 5)),
    targetScore: 90.0,
    syllabusTopics: const ['Raft Consensus', 'Vector Clocks', 'MapReduce'],
    completedTopicsCount: 1,
    roomOrLocation: 'Hall B',
    createdAt: DateTime.now(),
  );

  Widget createTestWidget(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: child),
      ),
    );
  }

  group('Exam Target & Spaced Repetition UI Widget Tests', () {
    testWidgets('ExamCountdownCard renders subject, days remaining, and progress',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ExamCountdownCard(exam: testExam),
        ),
      );
      await tester.pump();

      expect(find.text('Distributed Systems'), findsOneWidget);
      expect(find.textContaining('DAYS LEFT'), findsOneWidget);
      expect(find.textContaining('33% (1/3 Topics)'), findsOneWidget);
      expect(find.text('Hall B'), findsOneWidget);
    });

    testWidgets('SyllabusChecklist displays topic checklist and coverage',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          SyllabusChecklist(exam: testExam),
        ),
      );
      await tester.pump();

      expect(find.text('Syllabus Coverage'), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(find.text('Raft Consensus'), findsOneWidget);
      expect(find.text('Vector Clocks'), findsOneWidget);
      expect(find.text('MapReduce'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(3));
    });

    testWidgets('ReviewSessionTile renders Leitner level and recall action buttons when due',
        (tester) async {
      final dueSession = ReviewSession(
        id: 1,
        examTargetId: 1,
        topic: 'Raft Consensus',
        level: SpacedRepetitionLevel.box2,
        nextReviewDate: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now(),
      );

      var rememberedCalled = false;
      var forgotCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          ReviewSessionTile(
            session: dueSession,
            onRemembered: () => rememberedCalled = true,
            onForgot: () => forgotCalled = true,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Raft Consensus'), findsOneWidget);
      expect(find.text('Due now — review this topic'), findsOneWidget);
      expect(find.text('Got It'), findsOneWidget);
      expect(find.text('Forgot'), findsOneWidget);

      await tester.tap(find.text('Got It'));
      await tester.pump();
      expect(rememberedCalled, isTrue);

      await tester.tap(find.text('Forgot'));
      await tester.pump();
      expect(forgotCalled, isTrue);
    });

    testWidgets('CrunchPlanCard renders study milestones with session badges',
        (tester) async {
      final milestones = [
        {
          'topic': 'Raft Consensus',
          'study_date': '2026-09-01',
          'duration_minutes': 60,
          'session_type': 'DEEP_DIVE',
          'recommended_focus': 'Focus on leader election and log replication',
        },
        {
          'topic': 'Vector Clocks',
          'study_date': '2026-09-02',
          'duration_minutes': 45,
          'session_type': 'PRACTICE_PROBLEMS',
          'recommended_focus': 'Solve causal consistency concurrency graphs',
        },
      ];

      await tester.pumpWidget(
        createTestWidget(
          CrunchPlanCard(milestones: milestones),
        ),
      );
      await tester.pump();

      expect(find.text('AI Crunch Plan'), findsOneWidget);
      expect(find.text('2 sessions'), findsOneWidget);
      expect(find.text('Raft Consensus'), findsOneWidget);
      expect(find.text('Deep Dive'), findsOneWidget);
      expect(find.text('Vector Clocks'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
    });

    testWidgets('ExamsScreen displays tabs and renders upcoming exam card',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ExamsScreen(),
          overrides: [
            upcomingExamsProvider.overrideWith((ref) async => [testExam]),
            pastExamsProvider.overrideWith((ref) async => []),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Exam Targets'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);
      expect(find.text('Distributed Systems'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
