import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/providers/auth_providers.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/goals/presentation/consistency_screen.dart';
import 'features/goals/presentation/goal_detail_screen.dart';
import 'features/goals/presentation/goals_screen.dart';
import 'features/integrations/presentation/integration_settings_screen.dart';
import 'features/schedule/presentation/schedule_screen.dart';
import 'features/schedule/presentation/task_detail_screen.dart';
import 'features/schedule/presentation/timetable_editor_screen.dart';

/// Root application widget with GoRouter navigation.
class SiaApp extends ConsumerWidget {
  const SiaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);
    return MaterialApp.router(
      title: 'SIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }

  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/dashboard',
      redirect: (context, state) async {
        final isAuth = await ref.read(isAuthenticatedProvider.future);
        final isOnboarded = await ref.read(isOnboardedProvider.future);

        final isOnLogin = state.matchedLocation == '/login';
        final isOnOnboarding = state.matchedLocation == '/onboarding';

        if (!isAuth) return isOnLogin ? null : '/login';
        if (!isOnboarded) return isOnOnboarding ? null : '/onboarding';
        if (isOnLogin || isOnOnboarding) return '/dashboard';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
              routes: [
                GoRoute(
                  path: 'task/:id',
                  builder: (context, state) {
                    final taskId = int.parse(state.pathParameters['id']!);
                    return TaskDetailScreen(taskId: taskId);
                  },
                ),
                GoRoute(
                  path: 'timetable',
                  builder: (context, state) => const TimetableEditorScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/goals',
              builder: (context, state) => const GoalsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final goalId = int.parse(state.pathParameters['id']!);
                    return GoalDetailScreen(goalId: goalId);
                  },
                ),
                GoRoute(
                  path: 'consistency',
                  builder: (context, state) => const ConsistencyScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/integrations',
              builder: (context, state) => const IntegrationSettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Main shell with bottom navigation bar.
class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/schedule')) return 1;
    if (location.startsWith('/goals')) return 2;
    if (location.startsWith('/integrations')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex(context),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/schedule');
                break;
              case 2:
                context.go('/goals');
                break;
              case 3:
                context.go('/integrations');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag_rounded),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
