# Changelog

All notable changes to the **Sia** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- GitHub Actions automated CI workflow for linting, formatting, and unit testing.
- Automated release workflow for building and uploading Android release APKs.
- GitHub Community health standards (`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `ROADMAP.md`).
- GitHub Issue forms for bug reporting, feature proposals, and AI prompt enhancements.
- PR templates with comprehensive submission and review checklists.

---

## [1.0.0] - 2026-08-14

### Added
- **AI Daily Planner & Assistant**:
  - Google Gemini 1.5 Flash integration for contextual daily schedule optimization.
  - Multi-source schedule aggregator combining college timetables, Google Calendar events, and dynamic tasks.
  - Contextual AI morning briefings and dynamic task duration estimation.
- **Academic Timetable Management**:
  - Interactive Day-of-Week timetable editor with color-coded subject cards.
  - Automated weekly schedule block instantiation into daily timeline.
- **Integrations Hub**:
  - Google Calendar two-way event synchronization.
  - Google Classroom automated assignment and due date ingestion.
  - Gmail critical deadline thread parser.
  - WhatsApp notification listener for college announcements and keyword triggers.
- **Goal Tracking & Consistency Heatmap**:
  - Multi-category goal management (Academic, Fitness, Coding, Habits) with milestone tracking.
  - GitHub-style consistency streak heatmap visualization with color-graded activity levels.
  - Daily productivity metric calculation and consistency multiplier engine.
- **Smart Notification Service**:
  - Local push notifications for upcoming schedule blocks and task reminders.
  - Proactive AI check-ins and scheduled morning briefings.
  - Background notification interception for supported messaging apps.
- **Offline-First Architecture**:
  - Embedded SQLite database engine with foreign key cascades and indexed queries.
  - Freezed immutable data models with JSON serialization.
  - Riverpod reactive state management throughout all presentation layers.

[Unreleased]: https://github.com/sachinxrg/Sia/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/sachinxrg/Sia/releases/tag/v1.0.0
