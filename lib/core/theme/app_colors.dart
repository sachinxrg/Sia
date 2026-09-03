import 'package:flutter/material.dart';

/// SIA's "Calm Intelligence" color palette.
/// Dark glassmorphic theme with vibrant accent colors.
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);

  // Dark Surfaces
  static const Color surface = Color(0xFF1A1A2E);
  static const Color background = Color(0xFF0F0F1A);
  static const Color surfaceVariant = Color(0xFF16213E);

  // Dark Text
  static const Color onSurface = Color(0xFFE8E8F0);
  static const Color onSurfaceVariant = Color(0xFF8B8BA3);

  // Light Surfaces & Text
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightSurfaceVariant = Color(0xFFEEF0F8);
  static const Color lightOnSurface = Color(0xFF1A1D2E);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Semantic
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF6B6B);
  static const Color critical = Color(0xFFE17055);

  // Source Indicators
  static const Color whatsapp = Color(0xFF25D366);
  static const Color classroom = Color(0xFF4285F4);
  static const Color gmail = Color(0xFFEA4335);
  static const Color manual = Color(0xFFA29BFE);

  // Glassmorphism
  static const double glassOpacity = 0.08;
  static const double glassBlur = 20.0;

  // Heatmap Intensity Levels (0-4) - Dark
  static const List<Color> heatmapColors = [
    Color(0xFF16213E), // 0: empty
    Color(0xFF2D4A3E), // 1: light (1-25)
    Color(0xFF3D7A5E), // 2: medium (26-50)
    Color(0xFF00B894), // 3: strong (51-75)
    Color(0xFF00E6A0), // 4: intense (76-100)
  ];

  // Heatmap Intensity Levels (0-4) - Light
  static const List<Color> lightHeatmapColors = [
    Color(0xFFE2E8F0), // 0: empty
    Color(0xFFA7F3D0), // 1: light (1-25)
    Color(0xFF6EE7B7), // 2: medium (26-50)
    Color(0xFF10B981), // 3: strong (51-75)
    Color(0xFF059669), // 4: intense (76-100)
  ];

  /// Returns the appropriate color for a task source.
  static Color sourceColor(String source) {
    switch (source.toUpperCase()) {
      case 'WHATSAPP':
        return whatsapp;
      case 'CLASSROOM':
        return classroom;
      case 'GMAIL':
        return gmail;
      case 'MANUAL':
        return manual;
      default:
        return primaryLight;
    }
  }

  /// Returns the appropriate color for a task priority.
  static Color priorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
        return critical;
      case 'HIGH':
        return error;
      case 'MEDIUM':
        return warning;
      case 'LOW':
        return primaryLight;
      default:
        return onSurfaceVariant;
    }
  }
}
