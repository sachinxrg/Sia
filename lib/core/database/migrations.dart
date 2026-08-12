library;

/// SQL migration scripts for SIA's local SQLite database.
/// Each migration is a list of SQL statements to run in order.

const Map<int, List<String>> migrations = {
  1: _v1Migration,
};

const List<String> _v1Migration = [
  // User Profile
  '''
  CREATE TABLE IF NOT EXISTS user_profile (
    google_id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    email TEXT NOT NULL,
    photo_url TEXT,
    college_name TEXT,
    onboarding_complete INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
  ''',

  // Timetable
  '''
  CREATE TABLE IF NOT EXISTS timetable_entry (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject TEXT NOT NULL,
    day_of_week TEXT NOT NULL CHECK(day_of_week IN ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY')),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    room TEXT,
    teacher TEXT,
    is_active INTEGER DEFAULT 1,
    created_at TEXT NOT NULL
  )
  ''',

  // Raw WhatsApp Notifications
  '''
  CREATE TABLE IF NOT EXISTS raw_notification (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    package_name TEXT NOT NULL,
    title TEXT,
    body TEXT,
    content_hash TEXT NOT NULL UNIQUE,
    is_processed INTEGER DEFAULT 0,
    received_at TEXT NOT NULL
  )
  ''',

  // Google Classroom Assignments
  '''
  CREATE TABLE IF NOT EXISTS classroom_assignment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    classroom_id TEXT NOT NULL,
    course_name TEXT NOT NULL,
    assignment_id TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    description TEXT,
    due_date TEXT,
    link TEXT,
    state TEXT DEFAULT 'ACTIVE',
    last_synced_at TEXT NOT NULL
  )
  ''',

  // Gmail Items
  '''
  CREATE TABLE IF NOT EXISTS gmail_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    message_id TEXT NOT NULL UNIQUE,
    from_address TEXT NOT NULL,
    subject TEXT,
    snippet TEXT,
    received_at TEXT NOT NULL,
    is_processed INTEGER DEFAULT 0,
    last_synced_at TEXT NOT NULL
  )
  ''',

  // Tasks
  '''
  CREATE TABLE IF NOT EXISTS task (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    source TEXT NOT NULL CHECK(source IN ('WHATSAPP','CLASSROOM','GMAIL','MANUAL')),
    source_id INTEGER,
    priority TEXT DEFAULT 'MEDIUM' CHECK(priority IN ('CRITICAL','HIGH','MEDIUM','LOW')),
    deadline TEXT,
    scheduled_start TEXT,
    scheduled_end TEXT,
    is_completed INTEGER DEFAULT 0,
    is_deleted INTEGER DEFAULT 0,
    ai_confidence TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    completed_at TEXT
  )
  ''',

  // Notification Log
  '''
  CREATE TABLE IF NOT EXISTS notification_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER NOT NULL,
    notification_type TEXT NOT NULL,
    message TEXT NOT NULL,
    scheduled_for TEXT NOT NULL,
    is_sent INTEGER DEFAULT 0,
    is_dismissed INTEGER DEFAULT 0,
    escalation_count INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE
  )
  ''',

  // Daily Metrics
  '''
  CREATE TABLE IF NOT EXISTS daily_metric (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    tasks_created INTEGER DEFAULT 0,
    tasks_completed INTEGER DEFAULT 0,
    tasks_overdue INTEGER DEFAULT 0,
    notifications_sent INTEGER DEFAULT 0,
    notifications_acted_on INTEGER DEFAULT 0,
    sia_score REAL DEFAULT 0.0,
    created_at TEXT NOT NULL
  )
  ''',

  // Goals
  '''
  CREATE TABLE IF NOT EXISTS goal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL CHECK(category IN ('ACADEMIC','FITNESS','SKILL','PERSONAL')),
    target_type TEXT NOT NULL CHECK(target_type IN ('DAILY_HABIT','WEEKLY_TARGET','DEADLINE_GOAL')),
    target_value REAL NOT NULL,
    unit TEXT NOT NULL DEFAULT 'hours',
    deadline TEXT,
    color TEXT DEFAULT '#6C5CE7',
    is_active INTEGER DEFAULT 1,
    is_archived INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
  ''',

  // Goal Progress
  '''
  CREATE TABLE IF NOT EXISTS goal_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    goal_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    value REAL NOT NULL,
    note TEXT,
    created_at TEXT NOT NULL,
    FOREIGN KEY (goal_id) REFERENCES goal(id) ON DELETE CASCADE
  )
  ''',

  // Consistency Streaks
  '''
  CREATE TABLE IF NOT EXISTS consistency_streak (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    streak_type TEXT NOT NULL CHECK(streak_type IN ('OVERALL','GOAL_SPECIFIC')),
    goal_id INTEGER,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_active_date TEXT,
    streak_start_date TEXT,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (goal_id) REFERENCES goal(id) ON DELETE CASCADE
  )
  ''',

  // Performance Indexes
  'CREATE INDEX IF NOT EXISTS idx_task_deadline ON task(deadline)',
  'CREATE INDEX IF NOT EXISTS idx_task_source ON task(source)',
  'CREATE INDEX IF NOT EXISTS idx_task_completed ON task(is_completed)',
  'CREATE INDEX IF NOT EXISTS idx_raw_notification_processed ON raw_notification(is_processed)',
  'CREATE INDEX IF NOT EXISTS idx_raw_notification_hash ON raw_notification(content_hash)',
  'CREATE INDEX IF NOT EXISTS idx_notification_log_task ON notification_log(task_id)',
  'CREATE INDEX IF NOT EXISTS idx_notification_log_scheduled ON notification_log(scheduled_for)',
  'CREATE INDEX IF NOT EXISTS idx_daily_metric_date ON daily_metric(date)',
  'CREATE INDEX IF NOT EXISTS idx_timetable_day ON timetable_entry(day_of_week)',
  'CREATE INDEX IF NOT EXISTS idx_goal_active ON goal(is_active)',
  'CREATE INDEX IF NOT EXISTS idx_goal_category ON goal(category)',
  'CREATE INDEX IF NOT EXISTS idx_goal_progress_goal ON goal_progress(goal_id)',
  'CREATE INDEX IF NOT EXISTS idx_goal_progress_date ON goal_progress(date)',
  'CREATE INDEX IF NOT EXISTS idx_streak_type ON consistency_streak(streak_type)',
  'CREATE INDEX IF NOT EXISTS idx_streak_goal ON consistency_streak(goal_id)',
];
