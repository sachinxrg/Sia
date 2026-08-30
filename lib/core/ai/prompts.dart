import '../../models/ai_personality.dart';

/// Prompt templates for the Gemini 1.5 Flash API.
/// All placeholders use {PLACEHOLDER_NAME} format for string interpolation.

class Prompts {
  Prompts._();

  /// Task extraction prompt — processes WhatsApp + Classroom + Gmail data
  /// and returns a JSON array of actionable tasks.
  static String taskExtraction({
    required String currentDate,
    required String whatsappData,
    required String classroomData,
    required String gmailData,
  }) =>
      '''
You are SIA, an AI assistant for college students. Analyze the following data and extract actionable tasks.

RULES:
1. Only extract items that are clearly actionable tasks or deadlines.
2. Ignore casual conversations, memes, greetings, and off-topic messages.
3. For each task, determine a priority: CRITICAL (due in < 24h), HIGH (due in 1-3 days), MEDIUM (due in 3-7 days), LOW (due in > 7 days or no deadline).
4. If a deadline is mentioned but ambiguous (e.g., "submit by tomorrow"), resolve it relative to the current date: $currentDate.
5. Return ONLY a valid JSON array. No explanations, no markdown formatting.

INPUT DATA:

WhatsApp Notifications:
$whatsappData

Google Classroom Assignments:
$classroomData

Gmail Snippets:
$gmailData

OUTPUT FORMAT (strict JSON):
[
  {
    "title": "string",
    "description": "string",
    "deadline": "ISO8601 or null",
    "priority": "CRITICAL|HIGH|MEDIUM|LOW",
    "source": "WHATSAPP|CLASSROOM|GMAIL",
    "confidence": 0.0-1.0
  }
]
''';

  /// Notification text generation — creates a contextual push notification message.
  static String notificationText({
    required String taskTitle,
    required String deadline,
    required String urgencyLevel,
    required String timeRemaining,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) =>
      '''
Generate a short push notification message for a college student.
Task: $taskTitle
Deadline: $deadline
Urgency: $urgencyLevel
Time Remaining: $timeRemaining
${personality.promptDirective}

Rules:
- Maximum 2 sentences.
- Be specific and actionable.
- Adhere strictly to the specified Tone.
- Match urgency tone: casual for LOW, firm for HIGH, urgent for CRITICAL.
- Return only the notification text, no JSON, no quotes.
''';

  /// Daily schedule generation — goal-aware scheduling.
  static String dailySchedule({
    required String timetableJson,
    required String tasksJson,
    required String goalsJson,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) =>
      '''
Generate an optimal daily schedule for a college student.
${personality.promptDirective}

Fixed Blocks (cannot be moved):
$timetableJson

Pending Tasks:
$tasksJson

Active Personal Goals:
$goalsJson

Rules:
1. Schedule tasks in free time slots between fixed blocks.
2. Prioritize CRITICAL and HIGH tasks earlier in the day.
3. Include 15-minute breaks between study blocks.
4. No task block should exceed 2 hours.
5. Leave at least 1 hour of unscheduled time for flexibility.
6. For each DAILY_HABIT goal, allocate a time block matching the target value. Place goal blocks at consistent times when possible.
7. For WEEKLY_TARGET goals, calculate remaining quota for the week and distribute across remaining days.
8. DEADLINE_GOAL items should be treated like HIGH priority tasks if the deadline is within 7 days.
9. Mark goal-linked blocks with the goal_id so the app can track auto-logged progress.
10. Return ONLY valid JSON. No explanations, no markdown formatting.

Output Format:
[
  {
    "title": "string",
    "type": "CLASS|TASK|BREAK|GOAL",
    "start_time": "HH:mm",
    "end_time": "HH:mm",
    "task_id": null,
    "goal_id": null
  }
]
''';

  /// Streak nudge — generates a motivating consistency message.
  static String streakNudge({
    required int currentStreak,
    required int longestStreak,
    required String goalsList,
    required double hoursLeft,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) =>
      '''
Generate a short message for a college student about their consistency streak.

Current Streak: $currentStreak days
Longest Streak: $longestStreak days
Goals Needing Attention Today: $goalsList
Time Remaining Today: ${hoursLeft.toStringAsFixed(1)} hours
${personality.promptDirective}

Rules:
- Maximum 2 sentences.
- Adhere strictly to the specified Tone.
- If streak is about to break, be urgent but fit the tone.
- If streak is strong, celebrate or acknowledge accordingly.
- If near longest streak record, mention it as motivation.
- Reference specific goals by name.
- Return only the message text, no JSON, no quotes.
''';

  /// Adaptive schedule re-planner — dynamically reschedules remaining day blocks
  /// when tasks overrun or when user falls behind, matching tasks to energy slots.
  static String adaptiveReschedule({
    required String currentTime,
    required String delayedTaskInfo,
    required String remainingTasksJson,
    required String fixedBlocksJson,
    required String energySlotsJson,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) =>
      '''
You are SIA, an intelligent adaptive schedule re-planner for college students.
A schedule overrun or delay has occurred. Dynamically recalculate and shift remaining schedule blocks for today starting from: $currentTime.
${personality.promptDirective}

DELAY CONTEXT:
$delayedTaskInfo

REMAINING PENDING TASKS:
$remainingTasksJson

FIXED COMMITMENTS (Classes/Exams cannot be moved):
$fixedBlocksJson

CIRCADIAN ENERGY SLOTS:
$energySlotsJson

ADAPTIVE RE-PLANNING RULES:
1. ONLY schedule blocks strictly after the current time: $currentTime. Never plan backwards into the past.
2. If fixed blocks clash, shift flexible tasks to open subsequent slots.
3. Match high cognitive load tasks (CRITICAL/HIGH priority) to 'high_focus' energy slots where possible.
4. If the day is compressed, shorten lower priority task durations (minimum 25 mins) or defer non-urgent tasks.
5. Preserve 10-15 minute rest intervals between intense study blocks.
6. Return ONLY a valid JSON array of ScheduleBlock objects. No markdown, no commentary.

OUTPUT FORMAT (strict JSON):
[
  {
    "title": "string",
    "type": "CLASS|TASK|BREAK|GOAL",
    "start_time": "HH:mm",
    "end_time": "HH:mm",
    "task_id": null,
    "goal_id": null
  }
]
''';

  /// Exam crunch study planner — generates a spaced-repetition revision schedule leading up to an exam date.
  static String examCrunchSchedule({
    required String subject,
    required String examDate,
    required int daysRemaining,
    required List<String> syllabusTopics,
    required double dailyStudyHours,
    AiPersonality personality = AiPersonality.encouragingMentor,
  }) =>
      '''
You are SIA, an academic study strategist.
Create an intensive, spaced-repetition revision study plan for an upcoming college examination.

EXAMINATION DETAILS:
- Subject: $subject
- Exam Date: $examDate ($daysRemaining days remaining)
- Target Daily Study Allocation: ${dailyStudyHours.toStringAsFixed(1)} hours
- Syllabus Topics: ${syllabusTopics.join(', ')}
${personality.promptDirective}

PLANNING METHODOLOGY (Leitner / Spaced Repetition):
1. Distribute new topic deep-dives across the first 60% of available days.
2. Schedule spaced review intervals (Day 1 anchor, Day 3 review, Day 7 consolidation) for every covered topic.
3. Reserve the final 24-48 hours before the exam exclusively for formula sheets, mock tests, and light rapid recall.
4. Output structured study milestones with recommended revision intensity.

OUTPUT FORMAT (strict JSON array):
[
  {
    "topic": "string",
    "study_date": "YYYY-MM-DD",
    "duration_minutes": 60,
    "session_type": "DEEP_DIVE|PRACTICE_PROBLEMS|SPACED_REVIEW|MOCK_TEST",
    "recommended_focus": "string"
  }
]
''';
}
