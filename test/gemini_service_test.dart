import 'package:flutter_test/flutter_test.dart';
import 'package:sia/core/ai/prompts.dart';

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

    test('Daily schedule prompt interpolation', () {
      final prompt = Prompts.dailySchedule(
        timetableJson: '[{"subject": "OS"}]',
        tasksJson: '[{"title": "Assignment"}]',
        goalsJson: '[{"title": "DSA"}]',
      );

      expect(prompt, contains('OS'));
      expect(prompt, contains('Assignment'));
      expect(prompt, contains('DSA'));
    });

    test('Notification text prompt formatting', () {
      final prompt = Prompts.notificationText(
        taskTitle: 'Math HW',
        deadline: '2026-08-11T18:00:00Z',
        urgencyLevel: 'HIGH',
        timeRemaining: '2 hours',
      );

      expect(prompt, contains('Math HW'));
      expect(prompt, contains('HIGH'));
      expect(prompt, contains('2 hours'));
    });

    test('Streak nudge prompt generation', () {
      final prompt = Prompts.streakNudge(
        currentStreak: 5,
        longestStreak: 10,
        goalsList: 'DSA Practice, Reading',
        hoursLeft: 4.5,
      );

      expect(prompt, contains('5'));
      expect(prompt, contains('10'));
      expect(prompt, contains('DSA Practice, Reading'));
    });
  });
}
