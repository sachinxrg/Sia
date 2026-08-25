import 'dart:convert';
import 'dart:developer' as dev;

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../models/classroom_assignment.dart';
import '../../models/gmail_item.dart';
import '../../models/goal.dart';
import '../../models/raw_notification.dart';
import '../../models/schedule_block.dart';
import '../../models/task.dart';
import '../../models/timetable_entry.dart';
import '../utils/constants.dart';
import '../utils/date_extensions.dart';
import 'prompts.dart';

/// Implementation of GeminiAIService using google_generative_ai package.
/// Handles task extraction, schedule generation, notification text, and streak nudges.
/// Features defensive markdown code fence stripping to guarantee valid JSON decoding.
class GeminiService {
  GeminiService({required String apiKey})
      : _model = GenerativeModel(
          model: kGeminiModel,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.3,
            maxOutputTokens: 4096,
          ),
        ),
        _textModel = GenerativeModel(
          model: kGeminiModel,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 256,
          ),
        );

  final GenerativeModel _model;
  final GenerativeModel _textModel;

  /// Extracts actionable tasks from raw data sources via Gemini.
  /// Retries up to [kGeminiMaxRetries] times on malformed responses.
  Future<List<Task>> extractTasks({
    required List<RawNotification> notifications,
    required List<ClassroomAssignment> assignments,
    required List<GmailItem> emails,
  }) async {
    final whatsappData = notifications.isEmpty
        ? 'No WhatsApp notifications.'
        : notifications.map((n) => '- [${n.title}]: ${n.body}').join('\n');

    final classroomData = assignments.isEmpty
        ? 'No Classroom assignments.'
        : assignments
            .map(
              (a) =>
                  '- [${a.courseName}] ${a.title} (Due: ${a.dueDate?.toIso8601String() ?? "No deadline"})',
            )
            .join('\n');

    final gmailData = emails.isEmpty
        ? 'No Gmail items.'
        : emails
            .map(
              (e) =>
                  '- From: ${e.fromAddress} | Subject: ${e.subject} | ${e.snippet}',
            )
            .join('\n');

    final prompt = Prompts.taskExtraction(
      currentDate: DateTime.now().toIso8601String(),
      whatsappData: whatsappData,
      classroomData: classroomData,
      gmailData: gmailData,
    );

    final jsonResponse = await _sendWithRetry(prompt);
    if (jsonResponse == null) return [];

    try {
      final List<dynamic> taskList = jsonDecode(jsonResponse) as List<dynamic>;
      final now = DateTime.now();

      return taskList.map((item) {
        final map = item as Map<String, dynamic>;
        return Task(
          title: map['title'] as String? ?? 'Untitled Task',
          description: map['description'] as String?,
          source: _parseSource(map['source'] as String?),
          priority: _parsePriority(map['priority'] as String?),
          deadline: map['deadline'] != null
              ? DateTime.tryParse(map['deadline'] as String)
              : null,
          aiConfidence: (map['confidence'] as num?)?.toDouble(),
          createdAt: now,
          updatedAt: now,
        );
      }).toList();
    } catch (e) {
      dev.log(
        'ERROR: Failed to parse task extraction response: $e',
        name: 'GeminiService',
      );
      return [];
    }
  }

  /// Generates a contextual notification message for a task.
  Future<String> generateNotificationText({
    required Task task,
    required String urgencyLevel,
  }) async {
    final timeRemaining = task.deadline != null
        ? '${task.deadline!.hoursRemaining.toStringAsFixed(1)} hours'
        : 'No deadline set';

    final prompt = Prompts.notificationText(
      taskTitle: task.title,
      deadline: task.deadline?.toIso8601String() ?? 'No deadline',
      urgencyLevel: urgencyLevel,
      timeRemaining: timeRemaining,
    );

    try {
      final content = [Content.text(prompt)];
      final response =
          await _textModel.generateContent(content).timeout(kGeminiTimeout);
      return response.text?.trim() ??
          'You have a task coming up: ${task.title}';
    } catch (e) {
      dev.log(
        'WARN: Notification text generation failed, using fallback: $e',
        name: 'GeminiService',
      );
      return 'Reminder: ${task.title} needs your attention.';
    }
  }

  /// Generates a goal-aware daily schedule.
  Future<List<ScheduleBlock>> generateDailySchedule({
    required List<TimetableEntry> timetable,
    required List<Task> pendingTasks,
    required List<Goal> activeGoals,
    required DateTime date,
  }) async {
    final timetableJson = jsonEncode(
      timetable
          .map(
            (t) => {
              'subject': t.subject,
              'start_time': t.startTime,
              'end_time': t.endTime,
              'room': t.room,
            },
          )
          .toList(),
    );

    final tasksJson = jsonEncode(
      pendingTasks
          .map(
            (t) => {
              'id': t.id,
              'title': t.title,
              'priority': t.priorityString,
              'deadline': t.deadline?.toIso8601String(),
            },
          )
          .toList(),
    );

    final goalsJson = jsonEncode(
      activeGoals
          .map(
            (g) => {
              'id': g.id,
              'title': g.title,
              'target_type': g.targetTypeString,
              'target_value': g.targetValue,
              'unit': g.unit,
              'deadline': g.deadline?.toIso8601String(),
            },
          )
          .toList(),
    );

    final prompt = Prompts.dailySchedule(
      timetableJson: timetableJson,
      tasksJson: tasksJson,
      goalsJson: goalsJson,
    );

    final jsonResponse = await _sendWithRetry(prompt);
    if (jsonResponse == null) return [];

    try {
      final List<dynamic> blockList = jsonDecode(jsonResponse) as List<dynamic>;
      return blockList.map((item) {
        final map = item as Map<String, dynamic>;
        return ScheduleBlock(
          title: map['title'] as String? ?? '',
          type: _parseBlockType(map['type'] as String?),
          startTime: map['start_time'] as String? ?? '00:00',
          endTime: map['end_time'] as String? ?? '00:00',
          taskId: map['task_id'] as int?,
          goalId: map['goal_id'] as int?,
        );
      }).toList();
    } catch (e) {
      dev.log(
        'ERROR: Failed to parse schedule response: $e',
        name: 'GeminiService',
      );
      return [];
    }
  }

  /// Generates a motivating streak nudge message.
  Future<String> generateStreakNudge({
    required int currentStreak,
    required int longestStreak,
    required List<Goal> goalsNeedingAttention,
  }) async {
    final goalsList = goalsNeedingAttention.isEmpty
        ? 'None — great job!'
        : goalsNeedingAttention.map((g) => g.title).join(', ');

    final now = DateTime.now();
    final hoursLeft = (24 - now.hour) - (now.minute / 60.0);

    final prompt = Prompts.streakNudge(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      goalsList: goalsList,
      hoursLeft: hoursLeft,
    );

    try {
      final content = [Content.text(prompt)];
      final response =
          await _textModel.generateContent(content).timeout(kGeminiTimeout);
      return response.text?.trim() ??
          'Keep your $currentStreak-day streak alive!';
    } catch (e) {
      dev.log(
        'WARN: Streak nudge generation failed: $e',
        name: 'GeminiService',
      );
      return 'You\'re on a $currentStreak-day streak. Don\'t let it break!';
    }
  }

  /// Sends a JSON-mode prompt to Gemini with retry logic and markdown code fence cleaning.
  Future<String?> _sendWithRetry(String prompt) async {
    for (var attempt = 0; attempt <= kGeminiMaxRetries; attempt++) {
      try {
        final content = [Content.text(prompt)];
        final response =
            await _model.generateContent(content).timeout(kGeminiTimeout);

        final text = response.text;
        if (text == null || text.isEmpty) {
          dev.log(
            'WARN: Empty response from Gemini (attempt ${attempt + 1})',
            name: 'GeminiService',
          );
          continue;
        }

        // Clean markdown code blocks (e.g. ```json ... ```)
        String cleaned = text.trim();
        if (cleaned.startsWith('```json')) {
          cleaned = cleaned.substring(7);
        } else if (cleaned.startsWith('```')) {
          cleaned = cleaned.substring(3);
        }
        if (cleaned.endsWith('```')) {
          cleaned = cleaned.substring(0, cleaned.length - 3);
        }
        cleaned = cleaned.trim();

        // Validate it's parseable JSON
        jsonDecode(cleaned);
        return cleaned;
      } catch (e) {
        dev.log(
          'WARN: Gemini request failed (attempt ${attempt + 1}/${kGeminiMaxRetries + 1}): $e',
          name: 'GeminiService',
        );

        if (attempt < kGeminiMaxRetries) {
          // Exponential backoff: 1s, 2s
          await Future<void>.delayed(
            Duration(seconds: (attempt + 1)),
          );
        }
      }
    }

    dev.log('ERROR: All Gemini retries exhausted', name: 'GeminiService');
    return null;
  }

  TaskSource _parseSource(String? source) {
    switch (source?.toUpperCase()) {
      case 'WHATSAPP':
        return TaskSource.whatsapp;
      case 'CLASSROOM':
        return TaskSource.classroom;
      case 'GMAIL':
        return TaskSource.gmail;
      default:
        return TaskSource.manual;
    }
  }

  TaskPriority _parsePriority(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'CRITICAL':
        return TaskPriority.critical;
      case 'HIGH':
        return TaskPriority.high;
      case 'LOW':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  BlockType _parseBlockType(String? type) {
    switch (type?.toUpperCase()) {
      case 'CLASS':
        return BlockType.classBlock;
      case 'BREAK':
        return BlockType.breakBlock;
      case 'GOAL':
        return BlockType.goal;
      default:
        return BlockType.task;
    }
  }
}
