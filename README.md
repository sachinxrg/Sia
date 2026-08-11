# SIA — Smart Intelligent Assistant 🚀

> **100% Free-to-Operate, AI-Powered Daily Planning & Productivity Engine for College Students.**  
> *Intercepts local WhatsApp notifications, syncs Google Classroom & Gmail, runs them through Gemini 1.5 Flash AI, and schedules intelligent local push notifications.*

---

## 📸 Overview & Visual Identity

SIA is built on a **"Calm Intelligence"** design philosophy — a sleek, dark-themed, glassmorphic productivity assistant designed specifically for college students. It solves notification overload and fragmented assignment deadlines without requiring expensive backend infrastructure or monthly subscriptions.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                             SIA SYSTEM ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  [ WhatsApp Alerts ]     [ Google Classroom ]       [ Gmail Notifications ] │
│           │                       │                            │            │
│           ▼                       ▼                            ▼            │
│  (Notification Listener)  (Classroom API v1)            (Gmail API v1)      │
│           │                       │                            │            │
│           └───────────────────────┼────────────────────────────┘            │
│                                   │                                         │
│                                   ▼                                         │
│                       [ Google Gemini 1.5 Flash ]                           │
│                       (Task Extraction & Schedule)                          │
│                                   │                                         │
│                                   ▼                                         │
│                       [ SQLite Local Persistence ]                          │
│                       (11 Tables + 15 Indexes)                              │
│                                   │                                         │
│                 ┌─────────────────┴─────────────────┐                       │
│                 ▼                                   ▼                       │
│     [ Smart Push Notifications ]          [ Consistency & Heatmap ]         │
│     (4 Android Priority Channels)         (90-Day Contribution Grid)        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌟 Key Features

### 📩 1. Local WhatsApp Interceptor
- Intercepts incoming WhatsApp class group messages and submission alerts locally via Android's `NotificationListenerService`.
- Deduplicates incoming alerts using **SHA-256 content hashing** with a 2-minute tolerance window.
- Extracted text is sanitized and passed to Gemini 1.5 Flash for automatic task parsing.

### 📚 2. Google Classroom & Gmail Delta Sync
- Connects directly to Google Classroom API to extract coursework, due dates, and submission links.
- Scans recent unread Gmail threads for exam alerts and professor announcements.
- Operates on **strictly read-only OAuth2 scopes** (`.readonly`) preserving 100% user privacy.

### 🧠 3. Gemini 1.5 Flash AI Planning Engine
- **Task Extraction:** Converts unstructured notifications into structured JSON tasks with assigned priority (`CRITICAL`, `HIGH`, `MEDIUM`, `LOW`).
- **Goal-Aware Dynamic Scheduling:** Generates daily timeline blocks (`CLASS`, `TASK`, `BREAK`, `GOAL`) factoring in fixed timetable entries and personal goals.
- **Smart Notification Copy:** Generates tone-matched, motivating push notification text based on deadline urgency.

### 🎯 4. Personal Goals & Consistency Engine
- Create custom **Daily Habit**, **Weekly Target**, or **Deadline-based** goals (e.g., *"Study 2 hours of DSA daily"*).
- Quick progress logging sheet with real-time target completion percentages.
- **90-Day Activity Heatmap:** GitHub-style contribution grid displaying productivity density based on composite SIA Scores (0-100).
- **Streak Tracker:** Dynamic fire flame badges celebrating consecutive days of task completion and goal progress.

### 🔔 5. Multi-Channel Local Push Notifications
- 4 dedicated Android Notification Channels:
  - `sia_deadlines`: Standard task reminders (24h, 6h, 1h, 15m)
  - `sia_escalations`: Max-priority alerts for overdue critical items
  - `sia_goals`: Daily habit progress nudges (6 PM trigger)
  - `sia_streaks`: Motivational streak retention warnings

---

## 🛠️ Zero-Cost Tech Stack

| Layer | Technology | Rationale |
|---|---|---|
| **Framework** | Flutter (Dart 3+ Null Safety) | Cross-platform UI with 60fps native performance |
| **State Management** | `flutter_riverpod` + `flutter_hooks` | Reactive, testable, dependency-injected state |
| **AI Engine** | `google_generative_ai` (Gemini 1.5 Flash) | High-speed, zero-cost LLM text/JSON extraction |
| **Local Database** | `sqflite` + `sqflite_common_ffi` | 11 relational tables, zero server hosting costs |
| **Notification Listener** | `flutter_notification_listener_plus` | Native Android notification interception |
| **Push Notifications** | `flutter_local_notifications` | Timezone-aware local push notifications |
| **Navigation** | `go_router` | ShellRoute bottom navigation & auth guards |

---

## 📁 Repository Structure

```text
Sia/
├── android/               # Native Android manifest & notification listener config
├── assets/                # Design assets and icon fonts
├── docs/                  # Architectural specs & Developer Onboarding Guide
├── lib/
│   ├── core/
│   │   ├── ai/            # Gemini API service & prompt templates
│   │   ├── database/      # SQLite DatabaseService & v1 migration DDL
│   │   ├── notifications/ # LocalNotificationService & Android channels
│   │   ├── theme/         # AppColors, AppTypography, AppTheme tokens
│   │   └── utils/         # Constants, DateExtensions, HashUtils
│   ├── features/
│   │   ├── auth/          # LoginScreen & OnboardingScreen
│   │   ├── dashboard/     # DashboardScreen, MetricsCard, StreakBadge, Timeline
│   │   ├── goals/         # GoalsScreen, GoalDetailScreen, ConsistencyScreen & Heatmap
│   │   ├── integrations/  # WhatsAppHandler & Google Integration services
│   │   └── schedule/      # ScheduleScreen, TaskDetailScreen, TimetableEditor
│   ├── models/            # 15 Freezed data models + serialization
│   ├── app.dart           # GoRouter route hierarchy & MainShell nav bar
│   └── main.dart          # Application entry point
├── pubspec.yaml           # Dependency declaration
└── README.md              # Project documentation
```

---

## 🚀 Installation & Setup Guide

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10.0 or higher)
- [Android Studio](https://developer.android.com/studio) with Android SDK & Command-line Tools
- Google Gemini API Key from [Google AI Studio](https://aistudio.google.com/app/apikey)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/sachinxrg/Sia.git
cd Sia

# Install dependencies
flutter pub get

# Generate freezed data models and riverpod providers
dart run build_runner build --delete-conflicting-outputs
```

### 3. Running the App

#### Running on Web (Chrome)
```bash
flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE
```

#### Running on Android / Mobile
```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE
```

#### Building Release APK
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE
```
*Output location:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔒 Security & Confidentiality

- **Zero Data Harvesting:** All intercepted notifications, tasks, goals, and credentials are stored strictly on the user's physical device in sandboxed SQLite database files.
- **No API Keys in Source Code:** `GEMINI_API_KEY` is injected strictly at build time via `--dart-define`.
- **Read-Only Scopes:** Google Classroom and Gmail integrations utilize strict `.readonly` OAuth2 scopes.

---

## 🤝 Contributing & Developer Resources

For detailed developer onboarding, database ERDs, and code contribution guidelines, refer to [DEVELOPER_ONBOARDING.md](docs/DEVELOPER_ONBOARDING.md).

---

## 📜 License

This project is open-source under the [MIT License](LICENSE).
