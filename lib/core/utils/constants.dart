library;

/// App-wide constants for SIA.

// Database
const String kDatabaseName = 'sia_database.db';
const int kDatabaseVersion = 1;
const int kDataRetentionDays = 30;

// WhatsApp
const String kWhatsAppPackageName = 'com.whatsapp';
const String kWhatsAppBusinessPackageName = 'com.whatsapp.w4b';

// Google API Scopes
const List<String> kGoogleScopes = [
  'email',
  'profile',
  'https://www.googleapis.com/auth/classroom.courses.readonly',
  'https://www.googleapis.com/auth/classroom.coursework.me.readonly',
  'https://www.googleapis.com/auth/gmail.readonly',
];

// Gemini
const String kGeminiModel = 'gemini-1.5-flash';
const int kGeminiMaxRetries = 2;
const Duration kGeminiTimeout = Duration(seconds: 10);

// Sync Intervals
const Duration kClassroomSyncInterval = Duration(minutes: 30);
const Duration kGmailSyncInterval = Duration(minutes: 30);

// Notification Channels
const String kChannelIdDeadlines = 'sia_deadlines';
const String kChannelNameDeadlines = 'Deadline Reminders';
const String kChannelIdEscalations = 'sia_escalations';
const String kChannelNameEscalations = 'Urgent Escalations';
const String kChannelIdGoals = 'sia_goals';
const String kChannelNameGoals = 'Goal Reminders';
const String kChannelIdStreaks = 'sia_streaks';
const String kChannelNameStreaks = 'Streak Alerts';

// Notification Timing
const List<Duration> kReminderOffsets = [
  Duration(hours: 24),
  Duration(hours: 6),
  Duration(hours: 1),
  Duration(minutes: 15),
];
const int kMaxEscalations = 3;
const Duration kEscalationDelay = Duration(minutes: 30);

// Streak Rules
const int kGoalReminderHour = 18; // 6 PM - nudge about unfulfilled goals

// SharedPreferences Keys
const String kPrefOnboardingComplete = 'onboarding_complete';
const String kPrefLastClassroomSync = 'last_classroom_sync';
const String kPrefLastGmailSync = 'last_gmail_sync';
const String kPrefUserGoogleId = 'user_google_id';
const String kPrefUserDisplayName = 'user_display_name';
const String kPrefUserEmail = 'user_email';
const String kPrefUserPhotoUrl = 'user_photo_url';
const String kPrefCollegeName = 'user_college_name';
const String kPrefAiPersonality = 'ai_personality';
const String kDefaultAiPersonality = 'encouraging_mentor';

// Schedule Generation
const int kMaxTaskBlockMinutes = 120;
const int kBreakDurationMinutes = 15;
const int kFlexibilityMinutes = 60;
