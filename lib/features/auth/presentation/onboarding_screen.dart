import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/timetable_entry.dart';
import '../../schedule/providers/schedule_providers.dart';
import '../providers/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _collegeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();

  String _selectedDay = 'MONDAY';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  final List<TimetableEntry> _tempEntries = [];
  bool _isLoading = false;

  final List<String> _days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];

  @override
  void dispose() {
    _collegeController.dispose();
    _subjectController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _addTimetableEntry() {
    if (_subjectController.text.trim().isEmpty) return;

    final entry = TimetableEntry(
      subject: _subjectController.text.trim(),
      dayOfWeek: _selectedDay,
      startTime:
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
      endTime:
          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
      room: _roomController.text.trim().isEmpty
          ? null
          : _roomController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _tempEntries.add(entry);
      _subjectController.clear();
      _roomController.clear();
    });
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);
    try {
      final scheduleService = ref.read(scheduleServiceProvider);
      for (final entry in _tempEntries) {
        await scheduleService.createTimetableEntry(entry);
      }

      final authService = ref.read(authServiceProvider);
      await authService.completeOnboarding(
        collegeName: _collegeController.text.trim().isEmpty
            ? null
            : _collegeController.text.trim(),
      );

      ref.invalidate(currentUserProvider);
      ref.invalidate(isOnboardedProvider);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup failed: ${e.toString()}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to SIA! 🚀',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: spacingS),
              Text(
                'Let\'s configure your college profile and initial timetable schedule.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: spacingL),

              // College input
              TextField(
                controller: _collegeController,
                decoration: const InputDecoration(
                  labelText: 'College / University Name',
                  hintText: 'e.g., Stanford University',
                  prefixIcon: Icon(Icons.school_rounded),
                ),
              ),
              const SizedBox(height: spacingXl),

              Text(
                'Add Fixed Classes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: spacingS),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(spacingM),
                  child: Column(
                    children: [
                      TextField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Subject Name',
                          hintText: 'e.g., Data Structures',
                        ),
                      ),
                      const SizedBox(height: spacingM),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedDay,
                              decoration:
                                  const InputDecoration(labelText: 'Day'),
                              items: _days
                                  .map((d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(d.substring(0, 3)),
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedDay = val!),
                            ),
                          ),
                          const SizedBox(width: spacingS),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _startTime,
                                );
                                if (time != null) {
                                  setState(() => _startTime = time);
                                }
                              },
                              child: Text('Start: ${_startTime.format(context)}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacingM),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _roomController,
                              decoration: const InputDecoration(
                                labelText: 'Room (Optional)',
                                hintText: 'Lab 302',
                              ),
                            ),
                          ),
                          const SizedBox(width: spacingS),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _endTime,
                                );
                                if (time != null) {
                                  setState(() => _endTime = time);
                                }
                              },
                              child: Text('End: ${_endTime.format(context)}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacingM),
                      ElevatedButton.icon(
                        onPressed: _addTimetableEntry,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Class'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: spacingM),

              if (_tempEntries.isNotEmpty) ...[
                Text(
                  'Added Classes (${_tempEntries.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: spacingS),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tempEntries.length,
                  itemBuilder: (context, index) {
                    final item = _tempEntries[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.subject),
                        subtitle: Text(
                            '${item.dayOfWeek} • ${item.startTime} - ${item.endTime} ${item.room != null ? "(${item.room})" : ""}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          onPressed: () {
                            setState(() => _tempEntries.removeAt(index));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: spacingXl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _finishOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: spacingM),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Complete Setup & Enter SIA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
