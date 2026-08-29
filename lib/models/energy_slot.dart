import 'energy_level.dart';

/// Represents a scheduled energy and focus window throughout a student's day.
class EnergySlot {
  const EnergySlot({
    required this.startTime,
    required this.endTime,
    required this.energyLevel,
    this.label,
  });

  /// Start time in "HH:mm" 24-hour format.
  final String startTime;

  /// End time in "HH:mm" 24-hour format.
  final String endTime;

  /// The cognitive energy level expected during this window.
  final EnergyLevel energyLevel;

  /// Optional contextual label (e.g., 'Morning Peak Focus').
  final String? label;

  /// Default baseline circadian rhythm energy slots for student daily planning.
  static List<EnergySlot> defaultCircadianSlots() => const [
        EnergySlot(
          startTime: '08:00',
          endTime: '12:00',
          energyLevel: EnergyLevel.highFocus,
          label: 'Morning Peak Focus',
        ),
        EnergySlot(
          startTime: '12:00',
          endTime: '13:30',
          energyLevel: EnergyLevel.restBreak,
          label: 'Midday Recharge & Lunch',
        ),
        EnergySlot(
          startTime: '13:30',
          endTime: '17:30',
          energyLevel: EnergyLevel.mediumEnergy,
          label: 'Afternoon Structured Study',
        ),
        EnergySlot(
          startTime: '17:30',
          endTime: '19:00',
          energyLevel: EnergyLevel.restBreak,
          label: 'Evening Exercise & Dinner',
        ),
        EnergySlot(
          startTime: '19:00',
          endTime: '22:00',
          energyLevel: EnergyLevel.lowEnergy,
          label: 'Night Review & Light Admin',
        ),
      ];

  /// Serializes to JSON map for Gemini prompt injection.
  Map<String, dynamic> toJson() => {
        'start_time': startTime,
        'end_time': endTime,
        'energy_level': energyLevel.toStorageKey(),
        if (label != null) 'label': label,
      };

  /// Constructs from JSON map.
  factory EnergySlot.fromJson(Map<String, dynamic> json) => EnergySlot(
        startTime: json['start_time'] as String? ?? '00:00',
        endTime: json['end_time'] as String? ?? '00:00',
        energyLevel: EnergyLevel.fromString(json['energy_level'] as String?),
        label: json['label'] as String?,
      );
}
