# Contributing to Sia (Smart Intelligent Assistant)

First off, thank you for considering contributing to **Sia**! 🎉👏

Sia is an AI-powered daily assistant and academic planner designed to empower students and professionals with intelligent time blocking, consistency tracking, Google integrations, and proactive AI notifications.

Whether you are fixing a bug, proposing a new AI feature, refining UI/UX animations, or improving documentation, your contributions are warmly welcomed.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Improving Documentation](#improving-documentation)
  - [Submitting Pull Requests](#submitting-pull-requests)
- [Development Setup](#development-setup)
  - [Prerequisites](#prerequisites)
  - [Local Setup Steps](#local-setup-steps)
- [Project Architecture & Directory Layout](#project-architecture--directory-layout)
- [Coding Standards & Style Guide](#coding-standards--style-guide)
  - [Formatting & Linting](#formatting--linting)
  - [State Management (Riverpod)](#state-management-riverpod)
  - [Error Handling](#error-handling)
- [Git Workflow & Commit Conventions](#git-workflow--commit-conventions)
  - [Branch Naming](#branch-naming)
  - [Conventional Commits](#conventional-commits)
- [Testing Guidelines](#testing-guidelines)
- [Community & Support](#community--support)

---

## Code of Conduct

This project and everyone participating in it is governed by the [Sia Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

---

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to ensure the problem has not already been reported.

When filing a bug report via our [Bug Report Form](.github/ISSUE_TEMPLATE/bug_report.yml), please include:
- A clear, descriptive title.
- Steps to reproduce the behavior.
- Expected versus actual behavior.
- Device / Emulator details (OS version, screen size).
- Output of `flutter doctor -v`.
- Relevant terminal logs or exception stack traces.
- Screenshots or screen recordings if applicable.

### Suggesting Enhancements

We love ideas that make Sia smarter and more helpful!
- Use our [Feature Request Form](.github/ISSUE_TEMPLATE/feature_request.yml).
- Clearly explain the use case and why this enhancement benefits students/users.
- Provide mockups, user flows, or algorithmic descriptions where helpful.

### Improving Documentation

Documentation improvements (fixing typos, adding architecture diagrams, expanding docstrings, clarifying setup steps) are great starting points! Feel free to submit a PR directly for documentation updates.

---

## Development Setup

### Prerequisites

Ensure your development machine has the following installed:

1. **Flutter SDK** (`>= 3.10.0`, recommended `3.22.x` or latest stable):
   ```bash
   flutter --version
   ```
2. **Dart SDK** (`>= 3.0.0 < 4.0.0` included with Flutter).
3. **Android Studio / Android SDK** with Build Tools and Android Emulator or physical device.
4. **Git** for version control.
5. **Google Gemini API Key** (optional for local testing of AI features):
   - Obtain from [Google AI Studio](https://aistudio.google.com/).

### Local Setup Steps

1. **Fork the Repository:**
   Click the "Fork" button on GitHub to create your own copy of the repository.

2. **Clone your fork locally:**
   ```bash
   git clone https://github.com/<your-username>/Sia.git
   cd Sia
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Generate Code (Freezed & Riverpod):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the App:**
   ```bash
   # On connected Android device / emulator
   flutter run

   # Or on Windows desktop (if desktop support enabled)
   flutter run -d windows
   ```

---

## Project Architecture & Directory Layout

Sia adheres to **Clean Architecture** principles with a feature-first modular structure:

```
lib/
├── core/                         # Core infrastructure & global singletons
│   ├── ai/                       # Google Gemini AI services & prompt pipelines
│   ├── database/                 # SQLite database service & SQL migrations
│   ├── notifications/            # Local notifications & Android system listener
│   ├── theme/                    # Design tokens, color palettes, typography
│   └── utils/                    # Common formatters, constants, helpers
├── features/                     # Feature modules (Domain, Data, Presentation)
│   ├── auth/                     # Onboarding, user profile & auth providers
│   ├── dashboard/                # Main HUD, consistency streak & timeline
│   ├── goals/                    # Goal tracking, metrics & consistency heatmap
│   ├── integrations/             # Google Calendar, Gmail, Classroom & WhatsApp
│   └── schedule/                 # Timetable, schedule blocks & dynamic tasks
├── models/                       # Freezed domain models & JSON serializable data
└── main.dart                     # Application entry point & provider scope
```

---

## Coding Standards & Style Guide

### Formatting & Linting

We enforce strict formatting and Dart lint rules defined in `analysis_options.yaml`.

- Format all Dart files before committing:
  ```bash
  dart format .
  ```
- Run static analysis and verify zero errors/warnings:
  ```bash
  flutter analyze
  ```

### State Management (Riverpod)

- Use **Riverpod 2.x** (`NotifierProvider`, `AsyncNotifierProvider`, `StateProvider`).
- Keep presentation widgets stateless/reactive (`ConsumerWidget` or `HookConsumerWidget`).
- Avoid putting database or network calls directly inside widget build methods; encapsulate them in repository/service classes.

### Error Handling

- Always handle exceptions gracefully using `try-catch` blocks and user-friendly error banners or state fallbacks.
- Provide offline fallbacks when network calls (e.g. Gemini AI or Google APIs) are unreachable.

---

## Git Workflow & Commit Conventions

### Branch Naming

Create feature branches branching off `main`:

```bash
git checkout -b feature/gemini-voice-briefing
git checkout -b fix/sqlite-migration-v2
git checkout -b docs/update-contributing-guide
```

Standard branch prefixes:
- `feature/` : New features or substantial enhancements
- `fix/`     : Bug fixes
- `docs/`    : Documentation updates
- `refactor/`: Code refactoring without changing functionality
- `test/`    : Adding or fixing tests
- `chore/`   : Build tools, dependency updates, CI/CD changes

### Conventional Commits

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for clear, automated changelogs:

```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

#### Types:
- `feat`: A new user-facing feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, whitespace (no code behavior change)
- `refactor`: Code changes that neither fix a bug nor add a feature
- `perf`: Performance improvements
- `test`: Adding or correcting tests
- `chore`: Maintenance tasks, dependencies, CI configuration

#### Examples:
```bash
git commit -m "feat(ai): integrate Gemini 1.5 flash for schedule generation"
git commit -m "fix(database): resolve null check on completed_at timestamp"
git commit -m "docs(readme): add GitHub Actions build status badge"
```

---

## Testing Guidelines

Ensure all tests pass before submitting your pull request:

```bash
# Run unit & widget tests
flutter test

# Run specific test file
flutter test test/consistency_logic_test.dart
```

When contributing a new feature or fixing a bug:
- Add unit tests in `test/` verifying the edge cases.
- Mock external dependencies (Gemini API, Google Sign-In, SQLite).

---

## Submitting Pull Requests

1. **Push your branch** to your GitHub fork:
   ```bash
   git push origin feature/your-feature-name
   ```
2. **Open a Pull Request** against the `main` branch of `sachinxrg/Sia`.
3. Fill out the PR template completely:
   - Provide a clear summary and motivation.
   - Attach screenshots/screen recordings for UI changes.
   - Check all items in the submission checklist.
4. Maintainers will review your PR, suggest improvements if needed, and merge once approved! 🚀

---

## Community & Support

- **Discussions**: Share ideas and ask questions in [GitHub Discussions](https://github.com/sachinxrg/Sia/discussions).
- **Issues**: Report bugs or request features in [GitHub Issues](https://github.com/sachinxrg/Sia/issues).
- **Security**: Disclose vulnerabilities privately following [SECURITY.md](SECURITY.md).

Thank you for helping make Sia amazing! ✨
