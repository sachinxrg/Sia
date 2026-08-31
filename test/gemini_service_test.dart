import 'package:flutter_test/flutter_test.dart';
import 'package:sia/core/ai/prompts.dart';
import 'package:sia/models/ai_personality.dart';

void main() {
  group('Gemini AI Service & Prompt Tests', () {
    test('Task extraction prompt interpolation', () {
      final prompt = Prompts.taskExtraction(
        currentDate: '2026-08-11T12:00:00Z',
        whatsappData: 'Assignment due tomorrow 5 PM',
        classroomData: 'DBMS Quiz 1',
        gmailData: 'Faculty Notice',
      );

      expect(prompt, contains('2026-08-11T12:00:00Z'));
      expect(prompt, contains('Assignment due tomorrow 5 PM'));
      expect(prompt, contains('DBMS Quiz 1'));
      expect(prompt, contains('Faculty Notice'));
      expect(prompt, contains('JSON'));
    });

    test('Daily schedule prompt interpolation with AI personality', () {
      final prompt = Prompts.dailySchedule(
        timetableJson: '[{"subject": "OS"}]',
        tasksJson: '[{"title": "Assignment"}]',
        goalsJson: '[{"title": "DSA"}]',
        personality: AiPersonality.minimalist,
      );

      expect(prompt, contains('OS'));
      expect(prompt, contains('Assignment'));
      expect(prompt, contains('DSA'));
      expect(prompt, contains('Tone: Minimalist and ultra-concise'));
    });

    test('Notification text prompt formatting with strict coach personality',
        () {
      final prompt = Prompts.notificationText(
        taskTitle: 'Math HW',
        deadline: '2026-08-11T18:00:00Z',
        urgencyLevel: 'HIGH',
        timeRemaining: '2 hours',
        personality: AiPersonality.strictCoach,
      );

      expect(prompt, contains('Math HW'));
      expect(prompt, contains('HIGH'));
      expect(prompt, contains('2 hours'));
      expect(prompt, contains('Direct, disciplined, and urgent'));
    });

    test('Streak nudge prompt generation with encouraging mentor personality',
        () {
      final prompt = Prompts.streakNudge(
        currentStreak: 5,
        longestStreak: 10,
        goalsList: 'DSA Practice, Reading',
        hoursLeft: 4.5,
        personality: AiPersonality.encouragingMentor,
      );

      expect(prompt, contains('5'));
      expect(prompt, contains('10'));
      expect(prompt, contains('DSA Practice, Reading'));
      expect(prompt, contains('Warm, empathetic, and encouraging'));
    });

    test('AiPersonality enum serialization and fallback behavior', () {
      expect(
        AiPersonality.fromString('strict_coach'),
        equals(AiPersonality.strictCoach),
      );
      expect(
        AiPersonality.fromString('minimalist'),
        equals(AiPersonality.minimalist),
      );
      expect(
        AiPersonality.fromString('encouraging_mentor'),
        equals(AiPersonality.encouragingMentor),
      );
      expect(
        AiPersonality.fromString('unknown_value'),
        equals(AiPersonality.encouragingMentor),
      );

      expect(
        AiPersonality.strictCoach.toStorageKey(),
        equals('strict_coach'),
      );
      expect(
        AiPersonality.minimalist.toStorageKey(),
        equals('minimalist'),
      );
      expect(
        AiPersonality.encouragingMentor.toStorageKey(),
        equals('encouraging_mentor'),
      );
    });

    test('Adaptive reschedule prompt formatting with energy slots', () {
      final prompt = Prompts.adaptiveReschedule(
        currentTime: '14:30',
        delayedTaskInfo: 'Task "Lab Work" ran over by 30 minutes.',
        remainingTasksJson: '[{"title": "Math Assignment"}]',
        fixedBlocksJson: '[{"subject": "OS Lab"}]',
        energySlotsJson: '[{"energy_level": "high_focus"}]',
        personality: AiPersonality.strictCoach,
      );

      expect(prompt, contains('14:30'));
      expect(prompt, contains('Task "Lab Work" ran over by 30 minutes.'));
      expect(prompt, contains('Math Assignment'));
      expect(prompt, contains('OS Lab'));
      expect(prompt, contains('high_focus'));
      expect(prompt, contains('Direct, disciplined, and urgent'));
    });
  });
}
