# SIA — Smart Intelligent Assistant 🚀

<p align="center">
  <a href="https://github.com/sachinxrg/Sia/actions/workflows/ci.yml"><img src="https://github.com/sachinxrg/Sia/actions/workflows/ci.yml/badge.svg" alt="CI Pipeline" /></a>
  <img src="https://img.shields.io/badge/Flutter-3.44+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.12+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/AI-Gemini%201.5%20Flash-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Gemini AI" />
  <img src="https://img.shields.io/badge/Database-SQLite%20sqflite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen?style=for-the-badge" alt="PRs Welcome" />
  <img src="https://img.shields.io/badge/License-MIT-purple?style=for-the-badge" alt="License" />
</p>

---

> **SIA (Smart Intelligent Assistant)** is a 100% free-to-operate, AI-powered daily planning & productivity engine for college students.  
> It intercepts local WhatsApp notifications, syncs Google Classroom & Gmail, processes unstructured data through Google Gemini 1.5 Flash API, and schedules intelligent local push notifications with zero cloud backend costs.

---

## 📸 System Architecture & Pipeline

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

## 🎨 UI Layout & Screen Mockups

### 1. Dashboard Screen ("Calm Intelligence" Theme)
```text
┌───────────────────────────────────────────────────────────┐
│ Good morning, Sachidanand! 👋                              │
│ Stanford University                                       │
├───────────────────────────────────────────────────────────┤
│ 🔥 7 Day Streak  [Secured Today ✓]                       │
│ Best: 14 days • Tap for heatmap                           │
├──────────────────────────────────────────┬────────────────┤
│           ( 85% )                        │  Completed: 6  │
│          SIA Score                       │  Pending: 2    │
├──────────────────────────────────────────┴────────────────┤
│ Today's Timeline                                          │
│ ┌────────────────┐ ┌────────────────┐ ┌────────────────┐ │
│ │ [CLASS] DBMS   │ │ [TASK] OS Ch 4 │ │ [GOAL] DSA Lab │ │
│ │ 09:00 - 10:30  │ │ 11:00 - 12:30  │ │ 14:00 - 16:00  │ │
│ └────────────────┘ └────────────────┘ └────────────────┘ │
├───────────────────────────────────────────────────────────┤
│ Upcoming Tasks                                 [View All] │
│ ☐ Read OS Chapter 4 (Classroom) • Due tomorrow    [CRITICAL]│
│ ☐ Submit DBMS Assignment (WhatsApp) • Due in 2d    [HIGH]   │
└───────────────────────────────────────────────────────────┘
```

### 2. Consistency & 90-Day Heatmap View
```text
┌───────────────────────────────────────────────────────────┐
│ 🔥 7 Days Current Streak                                  │
│ All-Time Longest Streak: 14 days                          │
├───────────────────────────────────────────────────────────┤
│ 90-Day Activity Heatmap (SIA Productivity Intensity)     │
│ Mon  ■ ■ ■ □ ■ ■ ■ ■ ■ □ ■ ■                             │
│ Tue  ■ ■ □ ■ ■ ■ ■ □ ■ ■ ■ ■                             │
│ Wed  ■ ■ ■ ■ ■ □ ■ ■ ■ ■ ■ ■                             │
│ Thu  ■ ■ ■ ■ ■ ■ ■ ■ □ ■ ■ ■                             │
│ Fri  ■ □ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■                             │
│ Sat  ■ ■ ■ □ ■ ■ □ ■ ■ ■ ■ ■                             │
│ Sun  □ ■ ■ ■ ■ ■ ■ ■ ■ □ ■ ■                             │
│                                      Less ■ ■ ■ ■ ■ More  │
└───────────────────────────────────────────────────────────┘
```

---

## 🌟 Core Features & Modules

### 📩 1. WhatsApp Notification Interceptor
- **Package:** `flutter_notification_listener_plus`
- Intercepts incoming WhatsApp class group messages and submission alerts locally.
- **SHA-256 Content Deduplication:** Generates a SHA-256 hash using `packageName + title + body + 2min_timestamp_window` to prevent duplicate task entries.

### 📚 2. Google Classroom & Gmail Delta Sync
- **Package:** `googleapis` + `googleapis_auth`
- Connects directly to Google Classroom API to extract coursework, due dates, and links.
- Scans recent unread Gmail threads for exam alerts and professor notices (filtered to last 7 days).
- Uses strictly **read-only OAuth2 scopes** (`.readonly`).

### 🧠 3. Gemini 1.5 Flash AI Engine
- **Package:** `google_generative_ai`
- **Task Extraction:** Converts unstructured notifications into structured JSON tasks with assigned priority (`CRITICAL`, `HIGH`, `MEDIUM`, `LOW`).
- **Goal-Aware Dynamic Scheduling:** Generates daily timeline blocks (`CLASS`, `TASK`, `BREAK`, `GOAL`) factoring in fixed class timetable entries and personal goals.
- **Smart Notification Copy & Nudges:** Generates tone-matched push notification text based on urgency.

### 🎯 4. Personal Goals & Consistency Engine
- Create custom **Daily Habit**, **Weekly Target**, or **Deadline-based** goals (e.g., *"Study 2 hours of DSA daily"*).
- Quick progress logging sheet with real-time target completion percentages.
- **90-Day Activity Heatmap:** GitHub-style contribution grid displaying productivity density based on composite SIA Scores (0-100).
- **Streak Tracker:** Dynamic fire flame badges celebrating consecutive days of task completion and goal progress.

### 🔔 5. Multi-Channel Local Push Notifications
- **Package:** `flutter_local_notifications`
- 4 dedicated Android Notification Channels:
  - `sia_deadlines`: Standard task reminders (24h, 6h, 1h, 15m offsets)
  - `sia_escalations`: Max-priority alerts for overdue critical items
  - `sia_goals`: Daily habit progress nudges (6 PM trigger)
  - `sia_streaks`: Motivational streak retention warnings

---

## 🛠️ Zero-Cost Architecture Stack

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| **Framework** | Flutter | ^3.44.0 | Cross-platform UI (Dart 3+ Null Safety) |
| **State Management** | `flutter_riverpod` | ^2.6.1 | Reactive, testable state management |
| **AI Engine** | `google_generative_ai` | ^0.4.7 | Free-tier Gemini 1.5 Flash API client |
| **Local Database** | `sqflite` + `sqflite_common_ffi` | ^2.4.3 | 11 relational tables + 15 indexes |
| **Notification Listener** | `flutter_notification_listener_plus` | ^1.3.7 | Native Android notification interception |
| **Push Notifications** | `flutter_local_notifications` | ^18.0.1 | Timezone-aware local push notifications |
| **Navigation** | `go_router` | ^14.8.1 | ShellRoute bottom navigation & auth guards |

---

## 🗄️ Database Schemas (SQLite)

The local SQLite database (`sia_database.db`) consists of **11 tables** and **15 performance indexes**:

| Table | Purpose | Primary Key |
|---|---|---|
| `user_profile` | User account, college name & onboarding state | `google_id` |
| `timetable_entry` | Recurring weekly class schedules | `id` (AUTOINCREMENT) |
| `raw_notification` | Intercepted WhatsApp notifications | `id` (AUTOINCREMENT) |
| `classroom_assignment` | Google Classroom coursework items | `id` (AUTOINCREMENT) |
| `gmail_item` | Scanned college emails | `id` (AUTOINCREMENT) |
| `task` | Extracted actionable tasks & priorities | `id` (AUTOINCREMENT) |
| `notification_log` | Scheduled and sent push notifications | `id` (AUTOINCREMENT) |
| `daily_metric` | Per-day task & notification metrics | `id` (AUTOINCREMENT) |
| `goal` | Active personal habit & deadline goals | `id` (AUTOINCREMENT) |
| `goal_progress` | Logged goal progress entries | `id` (AUTOINCREMENT) |
| `consistency_streak` | Overall and per-goal streak metrics | `id` (AUTOINCREMENT) |

---

## 🚀 Quick Start & Installation

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10.0 or higher)
- [Android Studio](https://developer.android.com/studio) with Android SDK & Command-line Tools
- Free Gemini API Key from [Google AI Studio](https://aistudio.google.com/app/apikey)

### 2. Setup Commands
```bash
# Clone the repository
git clone https://github.com/sachinxrg/Sia.git
cd Sia

# Install dependencies
flutter pub get

# Generate freezed data models and riverpod providers
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run Application
```bash
# Run on Chrome (Web)
flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE

# Run on Android Mobile / Emulator
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE

# Build Release APK for Mobile
flutter build apk --release --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY_HERE
```
*Output location:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔒 Security & Privacy Compliance

- **Zero Data Harvesting:** All intercepted notifications, tasks, goals, and credentials are saved strictly on the user's physical device in sandboxed SQLite database files.
- **No Hardcoded Secrets:** `GEMINI_API_KEY` is injected at build time via `--dart-define`.
- **Read-Only Scopes:** Google Classroom and Gmail integrations utilize strict `.readonly` OAuth2 scopes.

---

## 🤝 Contributing & Community

Contributions are what make the open-source community an inspiring place to learn, create, and build. Any contributions you make are **greatly appreciated**!

- 📖 **Contribution Guide**: Check out [CONTRIBUTING.md](CONTRIBUTING.md) for local setup, architecture guide, and PR instructions.
- 📜 **Code of Conduct**: Review our community pledge in [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
- 🔒 **Security Policy**: Read our vulnerability disclosure process in [SECURITY.md](SECURITY.md).
- 💬 **Support & Help**: Visit [SUPPORT.md](SUPPORT.md) and [GitHub Discussions](https://github.com/sachinxrg/Sia/discussions).
- 🗺️ **Product Roadmap**: View future milestones in [ROADMAP.md](ROADMAP.md).
- 📝 **Changelog**: See release history in [CHANGELOG.md](CHANGELOG.md).

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) — see the [LICENSE](LICENSE) file for details.
