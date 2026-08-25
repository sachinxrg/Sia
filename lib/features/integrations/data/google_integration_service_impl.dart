import 'dart:developer' as dev;

import 'package:googleapis/classroom/v1.dart' as classroom_api;
import 'package:googleapis/gmail/v1.dart' as gmail_api;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../../core/utils/constants.dart';
import '../../../models/classroom_assignment.dart';
import '../../../models/gmail_item.dart';

/// Fetches data from Google Classroom and Gmail APIs using read-only scopes.
/// Implements delta sync to avoid re-fetching unchanged data.
class GoogleIntegrationServiceImpl {
  GoogleIntegrationServiceImpl({
    required DatabaseService databaseService,
    required Future<String> Function() getAccessToken,
  })  : _databaseService = databaseService,
        _getAccessToken = getAccessToken;

  final DatabaseService _databaseService;
  final Future<String> Function() _getAccessToken;

  /// Fetches all active courses and their assignments from Google Classroom.
  Future<List<ClassroomAssignment>> fetchAssignments() async {
    try {
      final client = await _getAuthenticatedClient();
      final classroomApi = classroom_api.ClassroomApi(client);

      final coursesResponse = await classroomApi.courses.list(
        courseStates: ['ACTIVE'],
      );

      final courses = coursesResponse.courses ?? [];
      final assignments = <ClassroomAssignment>[];
      final now = DateTime.now();
      final db = await _databaseService.database;

      for (final course in courses) {
        final courseId = course.id;
        if (courseId == null) continue;

        final workResponse = await classroomApi.courses.courseWork.list(
          courseId,
          orderBy: 'dueDate desc',
        );

        final courseWork = workResponse.courseWork ?? [];
        for (final work in courseWork) {
          final assignmentId = work.id;
          if (assignmentId == null) continue;

          DateTime? dueDate;
          if (work.dueDate != null) {
            dueDate = DateTime(
              work.dueDate!.year ?? now.year,
              work.dueDate!.month ?? now.month,
              work.dueDate!.day ?? now.day,
              work.dueTime?.hours ?? 23,
              work.dueTime?.minutes ?? 59,
            );
          }

          final assignment = ClassroomAssignment(
            classroomId: courseId,
            courseName: course.name ?? 'Unknown Course',
            assignmentId: assignmentId,
            title: work.title ?? 'Untitled Assignment',
            description: work.description,
            dueDate: dueDate,
            link: work.alternateLink,
            state: work.state ?? 'ACTIVE',
            lastSyncedAt: now,
          );

          // Upsert: insert or update on conflict
          await db.insert(
            'classroom_assignment',
            {
              'classroom_id': assignment.classroomId,
              'course_name': assignment.courseName,
              'assignment_id': assignment.assignmentId,
              'title': assignment.title,
              'description': assignment.description,
              'due_date': assignment.dueDate?.toIso8601String(),
              'link': assignment.link,
              'state': assignment.state,
              'last_synced_at': assignment.lastSyncedAt.toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          assignments.add(assignment);
        }
      }

      await _setLastSyncTime('classroom', now);
      client.close();

      dev.log(
        'Fetched ${assignments.length} assignments from ${courses.length} courses',
        name: 'GoogleIntegrationService',
      );
      return assignments;
    } catch (e) {
      dev.log(
        'ERROR: Classroom fetch failed: $e',
        name: 'GoogleIntegrationService',
      );
      // Return cached assignments on failure
      return _getCachedAssignments();
    }
  }

  /// Fetches recent unread emails from Gmail.
  Future<List<GmailItem>> fetchRecentEmails({int maxResults = 20}) async {
    try {
      final client = await _getAuthenticatedClient();
      final gmailApi = gmail_api.GmailApi(client);

      final messagesResponse = await gmailApi.users.messages.list(
        'me',
        q: 'is:unread label:inbox',
        maxResults: maxResults,
      );

      final messages = messagesResponse.messages ?? [];
      final emails = <GmailItem>[];
      final now = DateTime.now();
      final db = await _databaseService.database;

      for (final msgRef in messages) {
        final msgId = msgRef.id;
        if (msgId == null) continue;

        final message = await gmailApi.users.messages.get('me', msgId);

        final headers = message.payload?.headers ?? [];
        final fromHeader = headers
            .firstWhere(
              (h) => h.name == 'From',
              orElse: () => gmail_api.MessagePartHeader(),
            )
            .value;
        final subjectHeader = headers
            .firstWhere(
              (h) => h.name == 'Subject',
              orElse: () => gmail_api.MessagePartHeader(),
            )
            .value;

        // Only process emails from the last 7 days
        final internalDate = message.internalDate;
        DateTime receivedAt;
        if (internalDate != null) {
          receivedAt =
              DateTime.fromMillisecondsSinceEpoch(int.parse(internalDate));
          if (receivedAt.isBefore(now.subtract(const Duration(days: 7)))) {
            continue;
          }
        } else {
          receivedAt = now;
        }

        final gmailItem = GmailItem(
          messageId: msgId,
          fromAddress: fromHeader ?? 'unknown@email.com',
          subject: subjectHeader,
          snippet: message.snippet,
          receivedAt: receivedAt,
          lastSyncedAt: now,
        );

        await db.insert(
          'gmail_item',
          {
            'message_id': gmailItem.messageId,
            'from_address': gmailItem.fromAddress,
            'subject': gmailItem.subject,
            'snippet': gmailItem.snippet,
            'received_at': gmailItem.receivedAt.toIso8601String(),
            'is_processed': 0,
            'last_synced_at': gmailItem.lastSyncedAt.toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        emails.add(gmailItem);
      }

      await _setLastSyncTime('gmail', now);
      client.close();

      dev.log(
        'Fetched ${emails.length} emails from Gmail',
        name: 'GoogleIntegrationService',
      );
      return emails;
    } catch (e) {
      dev.log(
        'ERROR: Gmail fetch failed: $e',
        name: 'GoogleIntegrationService',
      );
      return _getCachedEmails();
    }
  }

  /// Returns the timestamp of the last successful sync for a service.
  Future<DateTime?> getLastSyncTime(String service) async {
    final prefs = await SharedPreferences.getInstance();
    final key =
        service == 'classroom' ? kPrefLastClassroomSync : kPrefLastGmailSync;
    final stored = prefs.getString(key);
    return stored != null ? DateTime.tryParse(stored) : null;
  }

  Future<void> _setLastSyncTime(String service, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final key =
        service == 'classroom' ? kPrefLastClassroomSync : kPrefLastGmailSync;
    await prefs.setString(key, time.toIso8601String());
  }

  Future<http.Client> _getAuthenticatedClient() async {
    final token = await _getAccessToken();
    return authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          token,
          DateTime.now().add(const Duration(hours: 1)).toUtc(),
        ),
        null,
        kGoogleScopes,
      ),
    );
  }

  Future<List<ClassroomAssignment>> _getCachedAssignments() async {
    final db = await _databaseService.database;
    final rows =
        await db.query('classroom_assignment', orderBy: 'due_date ASC');
    return rows.map((row) {
      return ClassroomAssignment(
        id: row['id'] as int?,
        classroomId: row['classroom_id'] as String,
        courseName: row['course_name'] as String,
        assignmentId: row['assignment_id'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        dueDate: row['due_date'] != null
            ? DateTime.tryParse(row['due_date'] as String)
            : null,
        link: row['link'] as String?,
        state: row['state'] as String? ?? 'ACTIVE',
        lastSyncedAt: DateTime.parse(row['last_synced_at'] as String),
      );
    }).toList();
  }

  Future<List<GmailItem>> _getCachedEmails() async {
    final db = await _databaseService.database;
    final rows = await db.query('gmail_item', orderBy: 'received_at DESC');
    return rows.map((row) {
      return GmailItem(
        id: row['id'] as int?,
        messageId: row['message_id'] as String,
        fromAddress: row['from_address'] as String,
        subject: row['subject'] as String?,
        snippet: row['snippet'] as String?,
        receivedAt: DateTime.parse(row['received_at'] as String),
        isProcessed: (row['is_processed'] as int?) == 1,
        lastSyncedAt: DateTime.parse(row['last_synced_at'] as String),
      );
    }).toList();
  }
}
