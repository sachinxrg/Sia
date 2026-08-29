import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Represents a student's cognitive energy and focus level for intelligent task matching.
enum EnergyLevel {
  highFocus,
  mediumEnergy,
  lowEnergy,
  restBreak;

  /// User-facing display title.
  String get displayName {
    switch (this) {
      case EnergyLevel.highFocus:
        return 'High Focus (Deep Work)';
      case EnergyLevel.mediumEnergy:
        return 'Moderate Energy';
      case EnergyLevel.lowEnergy:
        return 'Low Energy (Admin / Light)';
      case EnergyLevel.restBreak:
        return 'Rest & Recovery';
    }
  }

  /// Brief description of appropriate tasks for this energy state.
  String get description {
    switch (this) {
      case EnergyLevel.highFocus:
        return 'Ideal for complex problem solving, coding, math, and writing.';
      case EnergyLevel.mediumEnergy:
        return 'Ideal for reading, structured study, and standard coursework.';
      case EnergyLevel.lowEnergy:
        return 'Ideal for email replies, organizing notes, and low-cognitive tasks.';
      case EnergyLevel.restBreak:
        return 'Walk, hydrate, recharge, or meditate.';
    }
  }

  /// The default time window recommendation for this energy level.
  String get recommendedTimeWindow {
    switch (this) {
      case EnergyLevel.highFocus:
        return '08:00 - 12:00';
      case EnergyLevel.mediumEnergy:
        return '14:00 - 17:00';
      case EnergyLevel.lowEnergy:
        return '19:00 - 22:00';
      case EnergyLevel.restBreak:
        return '15-minute intermissions';
    }
  }

  /// Associated UI accent color.
  Color get color {
    switch (this) {
      case EnergyLevel.highFocus:
        return AppColors.primaryLight;
      case EnergyLevel.mediumEnergy:
        return AppColors.warning;
      case EnergyLevel.lowEnergy:
        return AppColors.success;
      case EnergyLevel.restBreak:
        return AppColors.onSurfaceVariant;
    }
  }

  /// Associated UI icon.
  IconData get icon {
    switch (this) {
      case EnergyLevel.highFocus:
        return Icons.bolt_rounded;
      case EnergyLevel.mediumEnergy:
        return Icons.energy_savings_leaf_rounded;
      case EnergyLevel.lowEnergy:
        return Icons.bedtime_rounded;
      case EnergyLevel.restBreak:
        return Icons.coffee_rounded;
    }
  }

  /// Parses an [EnergyLevel] from a string key with fallback to [mediumEnergy].
  static EnergyLevel fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'high_focus':
      case 'highfocus':
      case 'high':
        return EnergyLevel.highFocus;
      case 'low_energy':
      case 'lowenergy':
      case 'low':
        return EnergyLevel.lowEnergy;
      case 'rest_break':
      case 'restbreak':
      case 'rest':
        return EnergyLevel.restBreak;
      case 'medium_energy':
      case 'mediumenergy':
      case 'medium':
      default:
        return EnergyLevel.mediumEnergy;
    }
  }

  /// Returns storage/JSON key.
  String toStorageKey() {
    switch (this) {
      case EnergyLevel.highFocus:
        return 'high_focus';
      case EnergyLevel.mediumEnergy:
        return 'medium_energy';
      case EnergyLevel.lowEnergy:
        return 'low_energy';
      case EnergyLevel.restBreak:
        return 'rest_break';
    }
  }
}
