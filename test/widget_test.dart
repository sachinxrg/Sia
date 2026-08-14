import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sia/app.dart';
import 'package:sia/features/auth/providers/auth_providers.dart';

void main() {
  testWidgets('SiaApp builds and navigates to LoginScreen when unauthenticated',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWith((ref) async => false),
          isOnboardedProvider.overrideWith((ref) async => false),
        ],
        child: const SiaApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify LoginScreen elements
    expect(find.text('Smart Intelligent Assistant'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });

  testWidgets(
      'SiaApp navigates to DashboardScreen when authenticated and onboarded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWith((ref) async => true),
          isOnboardedProvider.overrideWith((ref) async => true),
        ],
        child: const SiaApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify BottomNavigationBar items
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
  });
}
