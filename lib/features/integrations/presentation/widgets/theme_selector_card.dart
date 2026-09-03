import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';

/// Card widget allowing users to toggle between Light, Dark, and System theme modes.
class ThemeSelectorCard extends ConsumerWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.palette_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance & Theme',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        'Choose between light, dark, or system appearance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingM),
            Row(
              children: [
                Expanded(
                  child: _ThemeOptionTile(
                    mode: ThemeMode.system,
                    label: 'System',
                    icon: Icons.brightness_auto_rounded,
                    isSelected: currentMode == ThemeMode.system,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.system);
                    },
                  ),
                ),
                const SizedBox(width: spacingS),
                Expanded(
                  child: _ThemeOptionTile(
                    mode: ThemeMode.light,
                    label: 'Light',
                    icon: Icons.light_mode_rounded,
                    isSelected: currentMode == ThemeMode.light,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.light);
                    },
                  ),
                ),
                const SizedBox(width: spacingS),
                Expanded(
                  child: _ThemeOptionTile(
                    mode: ThemeMode.dark,
                    label: 'Dark',
                    icon: Icons.dark_mode_rounded,
                    isSelected: currentMode == ThemeMode.dark,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.dark);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final baseBorderColor =
        theme.dividerColor.withValues(alpha: isDarkTheme ? 0.3 : 0.5);
    const activeBorderColor = AppColors.primary;

    final baseBgColor = isDarkTheme
        ? AppColors.surfaceVariant.withValues(alpha: 0.3)
        : AppColors.lightSurfaceVariant.withValues(alpha: 0.5);
    final activeBgColor = AppColors.primary.withValues(alpha: 0.15);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: spacingM,
          horizontal: spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : baseBgColor,
          borderRadius: BorderRadius.circular(radiusMd),
          border: Border.all(
            color: isSelected ? activeBorderColor : baseBorderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: spacingS),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
