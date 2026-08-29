import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ai/ai_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/energy_level.dart';
import '../../../../models/energy_slot.dart';
import '../../providers/schedule_providers.dart';

/// Modal bottom sheet allowing students to trigger on-demand adaptive re-planning
/// with custom delay offsets and current cognitive energy alignment.
class AdaptiveReplanSheet extends ConsumerStatefulWidget {
  const AdaptiveReplanSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (context) => const AdaptiveReplanSheet(),
    );
  }

  @override
  ConsumerState<AdaptiveReplanSheet> createState() =>
      _AdaptiveReplanSheetState();
}

class _AdaptiveReplanSheetState extends ConsumerState<AdaptiveReplanSheet> {
  int _delayMinutes = 30;
  EnergyLevel _selectedEnergy = EnergyLevel.highFocus;
  bool _isLoading = false;

  final List<int> _delayOptions = [15, 30, 45, 60];

  Future<void> _executeReplan() async {
    setState(() => _isLoading = true);

    try {
      final scheduleService = ref.read(scheduleServiceProvider);
      final geminiService = ref.read(geminiServiceProvider);
      final personality = ref.read(aiPersonalityProvider);

      final now = DateTime.now();

      // Custom energy slot customized with current user energy preference
      final customSlots = [
        EnergySlot(
          startTime:
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          endTime:
              '${((now.hour + 2) % 24).toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          energyLevel: _selectedEnergy,
          label: 'Current Energy State',
        ),
        ...EnergySlot.defaultCircadianSlots(),
      ];

      final blocks = await scheduleService.adaptiveReschedule(
        geminiService: geminiService,
        currentTime: now,
        delayedTaskTitle: 'Current Activity',
        delayedMinutes: _delayMinutes,
        energySlots: customSlots,
        personality: personality,
      );

      ref.invalidate(dailyTimelineProvider);
      ref.invalidate(todayTasksProvider);
      ref.invalidate(pendingTasksProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              blocks.isEmpty
                  ? 'No pending tasks to reschedule.'
                  : 'Re-scheduled ${blocks.length} blocks to fit your day!',
            ),
            backgroundColor:
                blocks.isEmpty ? AppColors.warning : AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to re-plan schedule: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: spacingM,
        right: spacingM,
        top: spacingM,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: spacingM),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(spacingS),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_fix_high_rounded,
                  color: AppColors.primaryLight,
                  size: 22,
                ),
              ),
              const SizedBox(width: spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adaptive Re-planner',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Re-calculate your remaining day based on real-time delays.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: spacingL),
          Text(
            'Estimated Schedule Delay',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: spacingS),
          Row(
            children: _delayOptions.map((mins) {
              final isSelected = _delayMinutes == mins;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('+$mins min'),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withValues(alpha: 0.25),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _delayMinutes = mins);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: spacingL),
          Text(
            'Current Energy & Focus Level',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: spacingS),
          Wrap(
            spacing: spacingS,
            runSpacing: spacingS,
            children: EnergyLevel.values.map((energy) {
              final isSelected = _selectedEnergy == energy;
              final color = energy.color;

              return InkWell(
                borderRadius: BorderRadius.circular(radiusMd),
                onTap: () => setState(() => _selectedEnergy = energy),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingM,
                    vertical: spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : AppColors.surfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(radiusMd),
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(energy.icon, size: 16, color: color),
                      const SizedBox(width: spacingXs),
                      Text(
                        energy.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? color : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: spacingXl),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusMd),
                ),
              ),
              onPressed: _isLoading ? null : _executeReplan,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.bolt_rounded),
              label: Text(
                _isLoading
                    ? 'Re-planning with Gemini...'
                    : 'Re-plan Remaining Day',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
