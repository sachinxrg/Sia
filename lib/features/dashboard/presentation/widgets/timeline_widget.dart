import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../schedule/providers/schedule_providers.dart';

class TimelineWidget extends ConsumerWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(dailyTimelineProvider);

    return timelineAsync.when(
      data: (blocks) {
        if (blocks.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(spacingL),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.event_available_rounded,
                        size: 40, color: AppColors.onSurfaceVariant),
                    const SizedBox(height: spacingS),
                    Text(
                      'No classes or scheduled tasks today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];
              final isCurrent = block.isCurrent;

              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: spacingM),
                padding: const EdgeInsets.all(spacingM),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(radiusMd),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(block.type).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(radiusSm),
                          ),
                          child: Text(
                            block.type,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _getTypeColor(block.type),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (block.isFixed)
                          const Icon(Icons.lock_outline_rounded,
                              size: 14, color: AppColors.onSurfaceVariant),
                      ],
                    ),
                    Text(
                      block.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${block.startTime} - ${block.endTime}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Text('Error loading timeline: $err'),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'CLASS':
        return AppColors.classroom;
      case 'DONE':
        return AppColors.success;
      case 'GOAL':
        return AppColors.primaryLight;
      default:
        return AppColors.primary;
    }
  }
}
