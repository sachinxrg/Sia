import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Provider exposing the active ThemeMode (light, dark, or system).
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// StateNotifier that controls ThemeMode and persists user preferences.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(kPrefThemeMode);
      if (saved != null) {
        switch (saved) {
          case 'light':
            state = ThemeMode.light;
            break;
          case 'dark':
            state = ThemeMode.dark;
            break;
          case 'system':
            state = ThemeMode.system;
            break;
        }
      }
    } catch (_) {
      // Fallback to initial state (ThemeMode.dark)
    }
  }

  /// Sets the theme mode and persists it to SharedPreferences.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await prefs.setString(kPrefThemeMode, modeString);
    } catch (_) {}
  }

  /// Quick toggle between light and dark modes.
  Future<void> toggleTheme([BuildContext? context]) async {
    if (state == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // If current mode is system, flip based on current system brightness
      if (context != null) {
        final isDark =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
      } else {
        await setThemeMode(ThemeMode.light);
      }
    }
  }
}
