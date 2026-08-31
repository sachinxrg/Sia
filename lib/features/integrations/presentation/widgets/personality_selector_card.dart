import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ai/ai_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/ai_personality.dart';

/// Card widget allowing users to select and configure their AI assistant's personality tone.
class PersonalitySelectorCard extends ConsumerWidget {
  const PersonalitySelectorCard({super.key});

  IconData _getPersonalityIcon(AiPersonality personality) {
    switch (personality) {
      case AiPersonality.encouragingMentor:
        return Icons.sentiment_satisfied_alt_rounded;
      case AiPersonality.strictCoach:
        return Icons.fitness_center_rounded;
      case AiPersonality.minimalist:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _getPersonalityColor(AiPersonality personality) {
    switch (personality) {
      case AiPersonality.encouragingMentor:
        return AppColors.success;
      case AiPersonality.strictCoach:
        return AppColors.critical;
      case AiPersonality.minimalist:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPersonality = ref.watch(aiPersonalityProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.psychology_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
                const SizedBox(width: spacingS),
                Text(
                  'AI Personality & Tone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: spacingXs),
            Text(
              'Customize how SIA writes your schedule, notifications, and streak nudges.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: spacingM),
            ...AiPersonality.values.map((personality) {
              final isSelected = personality == selectedPersonality;
              final color = _getPersonalityColor(personality);

              return Padding(
                padding: const EdgeInsets.only(bottom: spacingS),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radiusMd),
                  onTap: () {
                    ref
                        .read(aiPersonalityProvider.notifier)
                        .setPersonality(personality);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(spacingM),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.12)
                          : AppColors.surfaceVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(radiusMd),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(spacingS),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getPersonalityIcon(personality),
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                personality.displayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? color
                                          : AppColors.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                personality.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color:
                              isSelected ? color : AppColors.onSurfaceVariant,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
