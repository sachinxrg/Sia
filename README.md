# SIA — Smart Intelligent Assistant 🚀

SIA (Smart Intelligent Assistant) is a **100% free-to-operate**, AI-powered daily planning app for college students. It intercepts local WhatsApp notifications, fetches Google Classroom/Gmail data, runs them through Google Gemini 1.5 Flash API, and schedules dynamic local push notifications.

---

## 🌟 Key Features

- **WhatsApp Interceptor:** Intercepts local WhatsApp notification alerts and extracts tasks using Gemini AI.
- **Google Integrations:** Fetches active assignments & due dates from Google Classroom and Gmail using read-only OAuth2 scopes.
- **Personal Goals Engine:** Create daily habit, weekly target, or deadline-based personal goals with AI-aware daily scheduling.
- **Consistency Tracking & Streaks:** Track daily goal and task streaks with flame badges and a GitHub-style 90-day activity heatmap.
- **Smart Notifications:** Time-aware local push notifications (24h, 6h, 1h, 15m) with automatic escalation for overdue deadlines.
- **Zero-Cost Architecture:** Operates entirely on local SQLite and free Gemini 1.5 Flash API tier. No Firebase or paid backend required.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter (Dart 3+ Null Safety)
- **State Management:** `flutter_riverpod` + `flutter_hooks`
- **AI Engine:** `google_generative_ai` (Gemini 1.5 Flash - Text & JSON processing)
- **Local Persistence:** `sqflite` (11 relational tables) + `shared_preferences`
- **Notification Interceptor:** `flutter_notification_listener_plus`
- **Local Push Notifications:** `flutter_local_notifications` (4 Android channels)
- **Navigation:** `go_router` (4-tab bottom navigation shell)

---

## 🚀 Getting Started

### Prerequisites

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.0 or higher).
2. Android Device or Emulator (Android 8.0+ / API 26+).
3. Google Gemini API Key (obtain from [Google AI Studio](https://aistudio.google.com/)).

### Installation & Running

```bash
# Clone the repository
git clone https://github.com/your-username/Sia.git
cd Sia

# Install dependencies
flutter pub get

# Generate freezed models & riverpod code
dart run build_runner build --delete-conflicting-outputs

# Run on Android with Gemini API Key injected
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE
```

---

## 📱 App Navigation Structure

- **/login:** Google Sign-In with animated SIA logo
- **/onboarding:** Initial college profile setup & timetable wizard
- **/dashboard:** SIA Score radial gauge, current streak, hour-by-hour timeline, upcoming tasks
- **/schedule:** Tabbed schedule view (Pending | Overdue | Timetable)
- **/goals:** Personal goals grid, goal creation sheet, quick progress logger
- **/goals/consistency:** Overall streak hero & 90-day GitHub-style heatmap grid
- **/integrations:** WhatsApp, Google Classroom, and Gmail sync settings

---

## 🔒 Security & Privacy

- **Data Privacy:** All notifications, tasks, and goals are saved strictly in local SQLite sandboxed storage.
- **Secret Isolation:** API keys are injected at build time via `--dart-define` and never committed to source control.
- **OAuth2 Permissions:** Google Classroom and Gmail scopes are strictly read-only (`.readonly`).

---

## 📄 License

MIT License — free for open-source modification and distribution.
