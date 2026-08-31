import 'package:flutter_test/flutter_test.dart';
import 'package:sia/models/consistency_streak.dart';
import 'package:sia/models/daily_metric.dart';
import 'package:sia/models/energy_level.dart';
import 'package:sia/models/energy_slot.dart';
import 'package:sia/models/goal.dart';
import 'package:sia/models/schedule_block.dart';
import 'package:sia/models/task.dart';
import 'package:sia/models/timetable_entry.dart';

void main() {
  group('Data Model Tests', () {
    test('Task model serialization & priority helper', () {
      final now = DateTime.now();
      final task = Task(
        id: 1,
        title: 'Complete DBMS Assignment',
        description: 'Solve questions 1-5',
        source: TaskSource.classroom,
        priority: TaskPriority.critical,
        deadline: now.add(const Duration(hours: 6)),
        createdAt: now,
        updatedAt: now,
      );

      expect(task.priorityString, equals('CRITICAL'));
      expect(task.sourceString, equals('CLASSROOM'));
      expect(task.isOverdue, isFalse);

      final json = task.toJson();
      final restored = Task.fromJson(json);
      expect(restored.id, equals(1));
      expect(restored.title, equals('Complete DBMS Assignment'));
      expect(restored.priority, equals(TaskPriority.critical));
    });

    test('Goal model targets and progress calculation', () {
      final now = DateTime(2026, 8, 11);
      final goal = Goal(
        id: 10,
        title: 'Daily DSA Practice',
        category: GoalCategory.academic,
        targetType: GoalTargetType.dailyHabit,
        targetValue: 2.0,
        unit: 'hours',
        createdAt: now,
        updatedAt: now,
      );

      expect(goal.categoryString, equals('ACADEMIC'));
      expect(goal.targetTypeString, equals('DAILY_HABIT'));

      final json = goal.toJson();
      final restored = Goal.fromJson(json);
      expect(restored.targetValue, equals(2.0));
      expect(restored.unit, equals('hours'));
    });

    test('TimetableEntry model integrity', () {
      final now = DateTime(2026, 8, 11);
      final entry = TimetableEntry(
        id: 5,
        subject: 'Operating Systems',
        dayOfWeek: 'MONDAY',
        startTime: '09:00',
        endTime: '10:00',
        room: 'Lab 302',
        createdAt: now,
      );

      expect(entry.dayOfWeek, equals('MONDAY'));

      final json = entry.toJson();
      final restored = TimetableEntry.fromJson(json);
      expect(restored.subject, equals('Operating Systems'));
      expect(restored.startTime, equals('09:00'));
    });

    test('DailyMetric SIA score computation', () {
      final now = DateTime(2026, 8, 11);
      final metric = DailyMetric(
        id: 1,
        date: '2026-08-11',
        tasksCreated: 5,
        tasksCompleted: 4,
        tasksOverdue: 0,
        siaScore: 88.5,
        createdAt: now,
      );

      expect(metric.siaScore, equals(88.5));

      final json = metric.toJson();
      final restored = DailyMetric.fromJson(json);
      expect(restored.siaScore, equals(88.5));
    });

    test('ScheduleBlock type parsing', () {
      const block = ScheduleBlock(
        title: 'Study Time',
        type: BlockType.task,
        startTime: '14:00',
        endTime: '16:00',
        taskId: 1,
      );

      expect(block.type, equals(BlockType.task));
    });

    test('ConsistencyStreak type tracking', () {
      final now = DateTime(2026, 8, 11);
      final streak = ConsistencyStreak(
        id: 1,
        streakType: 'OVERALL',
        currentStreak: 7,
        longestStreak: 14,
        lastActiveDate: '2026-08-10',
        updatedAt: now,
      );

      expect(streak.isOverall, isTrue);
      expect(streak.currentStreak, equals(7));
      expect(streak.streakTier, equals('large'));
    });

    test('EnergyLevel model helpers and parsing', () {
      expect(
        EnergyLevel.fromString('high_focus'),
        equals(EnergyLevel.highFocus),
      );
      expect(
        EnergyLevel.fromString('low_energy'),
        equals(EnergyLevel.lowEnergy),
      );
      expect(
        EnergyLevel.fromString('rest_break'),
        equals(EnergyLevel.restBreak),
      );
      expect(
        EnergyLevel.fromString('unknown'),
        equals(EnergyLevel.mediumEnergy),
      );

      expect(
        EnergyLevel.highFocus.toStorageKey(),
        equals('high_focus'),
      );
      expect(
        EnergyLevel.highFocus.displayName,
        contains('High Focus'),
      );
      expect(
        EnergyLevel.highFocus.recommendedTimeWindow,
        equals('08:00 - 12:00'),
      );
    });

    test('EnergySlot model serialization and defaults', () {
      final defaultSlots = EnergySlot.defaultCircadianSlots();
      expect(defaultSlots.length, equals(5));
      expect(defaultSlots.first.energyLevel, equals(EnergyLevel.highFocus));

      const slot = EnergySlot(
        startTime: '09:00',
        endTime: '11:00',
        energyLevel: EnergyLevel.highFocus,
        label: 'Morning Math',
      );

      final json = slot.toJson();
      final restored = EnergySlot.fromJson(json);

      expect(restored.startTime, equals('09:00'));
      expect(restored.endTime, equals('11:00'));
      expect(restored.energyLevel, equals(EnergyLevel.highFocus));
      expect(restored.label, equals('Morning Math'));
    });
  });
}
