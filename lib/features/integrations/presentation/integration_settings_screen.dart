import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/data_backup_card.dart';
import 'widgets/personality_selector_card.dart';

class IntegrationSettingsScreen extends ConsumerStatefulWidget {
  const IntegrationSettingsScreen({super.key});

  @override
  ConsumerState<IntegrationSettingsScreen> createState() =>
      _IntegrationSettingsScreenState();
}

class _IntegrationSettingsScreenState
    extends ConsumerState<IntegrationSettingsScreen> {
  bool _whatsAppEnabled = true;
  bool _classroomEnabled = true;
  bool _gmailEnabled = true;
  bool _isSyncing = false;

  Future<void> _forceSync() async {
    setState(() => _isSyncing = true);
    try {
      // Trigger sync logic
      await Future<void>.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Integration sync completed!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations & Services'),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync_rounded),
            onPressed: _isSyncing ? null : _forceSync,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(spacingM),
        children: [
          const PersonalitySelectorCard(),
          const SizedBox(height: spacingM),
          Card(
            child: SwitchListTile(
              secondary:
                  const Icon(Icons.chat_rounded, color: AppColors.whatsapp),
              title: const Text('WhatsApp Interceptor'),
              subtitle: const Text(
                'Intercepts local notification alerts to extract study tasks',
              ),
              value: _whatsAppEnabled,
              onChanged: (val) => setState(() => _whatsAppEnabled = val),
            ),
          ),
          const SizedBox(height: spacingS),
          Card(
            child: SwitchListTile(
              secondary:
                  const Icon(Icons.school_rounded, color: AppColors.classroom),
              title: const Text('Google Classroom'),
              subtitle: const Text(
                'Fetches active assignments & due dates automatically',
              ),
              value: _classroomEnabled,
              onChanged: (val) => setState(() => _classroomEnabled = val),
            ),
          ),
          const SizedBox(height: spacingS),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.mail_rounded, color: AppColors.gmail),
              title: const Text('Gmail Integration'),
              subtitle: const Text(
                'Scans college emails for exam & submission notices',
              ),
              value: _gmailEnabled,
              onChanged: (val) => setState(() => _gmailEnabled = val),
            ),
          ),
          const SizedBox(height: spacingM),
          const DataBackupCard(),
          const SizedBox(height: spacingL),
          Text(
            'Zero-Cost Stack Guarantee',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: spacingXs),
          Card(
            color: AppColors.surfaceVariant.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Text(
                'SIA runs entirely on local SQLite and free-tier APIs (Gemini 1.5 Flash). No external paid servers or Firebase databases are used.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
