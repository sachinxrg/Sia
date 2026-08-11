# SIA Developer Onboarding Guide

Welcome to the **SIA (Smart Intelligent Assistant)** developer team! This document provides all technical context required to build, test, and contribute to SIA.

---

## 🏗️ Architecture Overview

SIA follows a **Feature-First Architecture** inside `lib/features/`:

```text
lib/
├── core/
│   ├── ai/                # Gemini prompt templates & GeminiService
│   ├── database/          # SQLite migrations & DatabaseService singleton
│   ├── notifications/     # LocalNotificationService & Android channels
│   ├── theme/             # AppColors, AppTypography, AppTheme
│   └── utils/             # Constants, date extensions, hash utilities
├── features/
│   ├── auth/              # Google Sign-In & Onboarding wizard
│   ├── dashboard/         # Dashboard screen, MetricsCard, StreakBadge, Timeline
│   ├── goals/             # Personal goals CRUD, GoalProgress, Consistency & Heatmap
│   ├── integrations/      # WhatsApp interceptor, Google Classroom & Gmail sync
│   └── schedule/          # Task CRUD, Timetable management, Timeline generator
├── models/                # Freezed data models (11 classes)
├── app.dart               # GoRouter configuration & MainShell bottom nav
└── main.dart              # Entry point with ProviderScope
```

---

## 🗄️ Database Schemas (SQLite)

The local SQLite database (`sia_database.db`) consists of **11 tables**:

1. `user_profile`
2. `timetable_entry`
3. `raw_notification`
4. `classroom_assignment`
5. `gmail_item`
6. `task`
7. `notification_log`
8. `daily_metric`
9. `goal`
10. `goal_progress`
11. `consistency_streak`

Migrations are declared in `lib/core/database/migrations.dart`. When modifying schemas:
1. Increment `kDatabaseVersion` in `constants.dart`.
2. Add migration statements under key `2` (or next version number) in `migrations.dart`.

---

## 🤖 Gemini AI Prompting Engine

Prompts are stored in `lib/core/ai/prompts.dart`.
- `Prompts.taskExtraction`: Parses WhatsApp, Classroom, and Gmail data into JSON tasks.
- `Prompts.notificationText`: Generates short, motivating push notification text.
- `Prompts.dailySchedule`: Generates goal-aware daily schedule blocks (`CLASS`, `TASK`, `BREAK`, `GOAL`).
- `Prompts.streakNudge`: Generates a motivational 2-sentence streak extension message.

---

## 🧪 Testing Guidelines

Run all unit tests:
```bash
flutter test
```

Generate coverage report:
```bash
flutter test --coverage
```
