import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../goals/providers/goals_providers.dart';
import '../../../schedule/providers/schedule_providers.dart';

/// Card widget managing zero-knowledge JSON data exports and transactional restores.
class DataBackupCard extends ConsumerStatefulWidget {
  const DataBackupCard({super.key});

  @override
  ConsumerState<DataBackupCard> createState() => _DataBackupCardState();
}

class _DataBackupCardState extends ConsumerState<DataBackupCard> {
  bool _isExporting = false;
  bool _isRestoring = false;

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      final backupService = ref.read(backupServiceProvider);
      final jsonPayload = await backupService.exportBackup();

      if (!mounted) return;

      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success),
              SizedBox(width: spacingS),
              Text('Backup Ready'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your SIA database has been exported with SHA-256 integrity verification.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: spacingM),
              Container(
                padding: const EdgeInsets.all(spacingM),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(radiusMd),
                ),
                child: Text(
                  '${jsonPayload.substring(0, jsonPayload.length > 200 ? 200 : jsonPayload.length)}...',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: jsonPayload));
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backup JSON copied to clipboard!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy JSON'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showRestoreDialog() {
    final textController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Restore Database Backup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paste your raw SIA JSON backup string below. Existing records will be replaced transactionally.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: spacingM),
              TextField(
                controller: textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Paste backup JSON here...',
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.critical,
                foregroundColor: Colors.white,
              ),
              onPressed: _isRestoring
                  ? null
                  : () async {
                      final input = textController.text.trim();
                      if (input.isEmpty) return;

                      setDialogState(() => _isRestoring = true);
                      try {
                        final backupService = ref.read(backupServiceProvider);
                        final restoredCount =
                            await backupService.importBackup(input);

                        // Invalidate all app caches
                        ref.invalidate(todayTasksProvider);
                        ref.invalidate(pendingTasksProvider);
                        ref.invalidate(overdueTasksProvider);
                        ref.invalidate(dailyTimelineProvider);
                        ref.invalidate(timetableProvider);
                        ref.invalidate(activeGoalsProvider);
                        ref.invalidate(allStreaksProvider);
                        ref.invalidate(overallStreakProvider);
                        ref.invalidate(heatmapDataProvider);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Restored $restoredCount records successfully!',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Restore failed: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } finally {
                        setDialogState(() => _isRestoring = false);
                      }
                    },
              child: const Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.backup_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
                const SizedBox(width: spacingS),
                Text(
                  'Data Backup & Portability',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: spacingXs),
            Text(
              'Export your complete local database with SHA-256 checksum integrity, or restore from a saved backup.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: spacingM),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isExporting ? null : _handleExport,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_download_outlined, size: 18),
                    label: const Text('Export JSON'),
                  ),
                ),
                const SizedBox(width: spacingS),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isRestoring ? null : _showRestoreDialog,
                    icon: const Icon(Icons.file_upload_outlined, size: 18),
                    label: const Text('Restore Data'),
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
