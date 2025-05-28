import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/database_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  // Notification settings
  bool _allNotifications = true;
  bool _exerciseReminders = true;
  bool _journalReminders = true;
  bool _breathingReminders = true;

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final settings = [
        NotificationSettings(
          id: 'exercise_notifications',
          userId: 'current_user_id', // TODO: Get from auth service
          type: NotificationType.exercise,
          title: 'Latihan Pernapasan',
          message: 'Waktunya latihan pernapasan 4-7-8! Durasi 10 menit',
          isEnabled: _exerciseReminders,
          timestamp: DateTime.now(),
        ),
        NotificationSettings(
          id: 'journal_notifications',
          userId: 'current_user_id',
          type: NotificationType.journal,
          title: 'Jurnal Harian',
          message: 'Bagaimana perasaan Anda hari ini?',
          isEnabled: _journalReminders,
          timestamp: DateTime.now(),
        ),
        NotificationSettings(
          id: 'breathing_notifications',
          userId: 'current_user_id',
          type: NotificationType.breathing,
          title: 'Input Gejala',
          message: 'Jangan lupa catat gejala hari ini',
          isEnabled: _breathingReminders,
          timestamp: DateTime.now(),
        ),
      ];

      for (var setting in settings) {
        await _databaseService.saveNotificationSettings(setting);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan notifikasi berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi & Pengingat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to system notification settings
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // General Notification Settings
          _buildSectionHeader('Pengaturan Notifikasi'),
          _buildNotificationSwitch(
            'Semua Notifikasi',
            'Aktifkan atau nonaktifkan semua notifikasi',
            _allNotifications,
            (value) {
              setState(() {
                _allNotifications = value;
                _exerciseReminders = value;
                _journalReminders = value;
                _breathingReminders = value;
              });
            },
          ),

          const Divider(),

          // Exercise Reminders
          _buildNotificationSwitch(
            'Latihan Pernapasan',
            'Pengingat latihan pernapasan 4-7-8. Durasi 10 menit',
            _exerciseReminders,
            (value) {
              setState(() => _exerciseReminders = value);
            },
            icon: Icons.fitness_center,
          ),

          // Journal Reminders
          _buildNotificationSwitch(
            'Jurnal Harian',
            'Pengingat untuk mengisi jurnal harian',
            _journalReminders,
            (value) {
              setState(() => _journalReminders = value);
            },
            icon: Icons.book,
          ),

          // Symptom Input Reminders
          _buildNotificationSwitch(
            'Input Gejala',
            'Pengingat untuk mencatat gejala hari ini',
            _breathingReminders,
            (value) {
              setState(() => _breathingReminders = value);
            },
            icon: Icons.healing,
          ),

          const SizedBox(height: 24),

          // Clear All Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Semua Notifikasi'),
                          content: const Text(
                            'Apakah Anda yakin ingin menghapus semua notifikasi?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        setState(() {
                          _allNotifications = false;
                          _exerciseReminders = false;
                          _journalReminders = false;
                          _breathingReminders = false;
                        });
                        await _saveSettings();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Hapus Semua Notifikasi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    IconData? icon,
  }) {
    return ListTile(
      leading: icon != null
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: _allNotifications || icon == null ? onChanged : null,
      ),
    );
  }
}
