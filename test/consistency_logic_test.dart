import 'package:flutter_test/flutter_test.dart';
import 'package:sia/models/daily_metric.dart';
import 'package:sia/models/heatmap_day.dart';

void main() {
  group('Consistency & Productivity Metrics Tests', () {
    test('HeatmapDay intensity calculation based on SIA Score', () {
      const day0 =
          HeatmapDay(date: '2026-08-01', siaScore: 0.0, tasksCompleted: 0);
      const dayLow =
          HeatmapDay(date: '2026-08-02', siaScore: 20.0, tasksCompleted: 1);
      const dayMed =
          HeatmapDay(date: '2026-08-03', siaScore: 45.0, tasksCompleted: 2);
      const dayHigh =
          HeatmapDay(date: '2026-08-04', siaScore: 70.0, tasksCompleted: 3);
      const dayMax =
          HeatmapDay(date: '2026-08-05', siaScore: 95.0, tasksCompleted: 4);

      expect(day0.intensityLevel, equals(0));
      expect(dayLow.intensityLevel, equals(1));
      expect(dayMed.intensityLevel, equals(2));
      expect(dayHigh.intensityLevel, equals(3));
      expect(dayMax.intensityLevel, equals(4));
    });

    test('DailyMetric calculatedScore calculation with edge cases', () {
      final now = DateTime.now();
      final zeroTasks = DailyMetric(
        date: '2026-08-11',
        tasksCreated: 0,
        tasksCompleted: 0,
        createdAt: now,
      );
      expect(zeroTasks.calculatedScore, equals(0.0));

      final partialTasks = DailyMetric(
        date: '2026-08-11',
        tasksCreated: 4,
        tasksCompleted: 3,
        notificationsSent: 2,
        notificationsActedOn: 2,
        createdAt: now,
      );
      // (3/4)*70 + (2/2)*30 = 52.5 + 30 = 82.5
      expect(partialTasks.calculatedScore, equals(82.5));
    });
  });
}
