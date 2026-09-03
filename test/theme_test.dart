import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sia/core/theme/app_colors.dart';
import 'package:sia/core/theme/app_theme.dart';
import 'package:sia/core/theme/theme_provider.dart';
import 'package:sia/core/utils/constants.dart';
import 'package:sia/features/integrations/presentation/widgets/theme_selector_card.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppTheme Configuration Tests', () {
    test('Dark theme has dark brightness and correct primary/surface tokens', () {
      final darkTheme = AppTheme.darkTheme;
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.colorScheme.primary, AppColors.primary);
      expect(darkTheme.colorScheme.surface, AppColors.surface);
      expect(darkTheme.scaffoldBackgroundColor, AppColors.background);
    });

    test('Light theme has light brightness and correct primary/surface tokens', () {
      final lightTheme = AppTheme.lightTheme;
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.colorScheme.primary, AppColors.primary);
      expect(lightTheme.colorScheme.surface, AppColors.lightSurface);
      expect(lightTheme.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(lightTheme.cardTheme.color, AppColors.lightSurface);
    });
  });

  group('ThemeModeNotifier Tests', () {
    test('Initial theme mode is dark by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mode = container.read(themeModeProvider);
      expect(mode, ThemeMode.dark);
    });

    test('toggleTheme alternates between dark and light', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);
      expect(container.read(themeModeProvider), ThemeMode.dark);

      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.light);

      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('setThemeMode persists to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kPrefThemeMode), 'light');

      await notifier.setThemeMode(ThemeMode.system);
      expect(prefs.getString(kPrefThemeMode), 'system');
    });
  });

  group('ThemeSelectorCard Widget Tests', () {
    testWidgets('Renders all 3 theme options and responds to tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeSelectorCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Appearance & Theme'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Tap on 'Light'
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kPrefThemeMode), 'light');
    });
  });
}
