import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../models/exercise_model.dart';
import '../services/database_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _durationController = TextEditingController();
  ExerciseType _selectedExerciseType = ExerciseType.breathing;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRecurring = false;
  List<int> _selectedDays = [];
  bool _isLoading = false;

  final Map<int, String> _weekDays = {
    1: 'Sen',
    2: 'Sel',
    3: 'Rab',
    4: 'Kam',
    5: 'Jum',
    6: 'Sab',
    7: 'Min',
  };

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveSchedule() async {
    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi durasi latihan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final schedule = ScheduleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id', // TODO: Get from auth service
        exerciseType: _selectedExerciseType,
        scheduledTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        isRecurring: _isRecurring,
        recurringDays: _isRecurring ? _selectedDays : null,
        duration: int.parse(_durationController.text) * 60, // Convert to seconds
        timestamp: DateTime.now(),
      );

      await _databaseService.saveSchedule(schedule);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil disimpan')),
        );
        Navigator.pop(context);
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

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Type Selection
            const Text(
              'Jenis Latihan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExerciseType>(
              value: _selectedExerciseType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ExerciseType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedExerciseType = value);
                }
              },
            ),
            const SizedBox(height: 24),

            // Time Selection
            const Text(
              'Waktu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime.format(context),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Duration Input
            const Text(
              'Durasi (menit)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'menit',
              ),
            ),
            const SizedBox(height: 24),

            // Recurring Toggle
            SwitchListTile(
              title: const Text('Ulangi setiap minggu'),
              value: _isRecurring,
              onChanged: (value) {
                setState(() => _isRecurring = value);
              },
            ),
            const SizedBox(height: 16),

            // Day Selection (if recurring)
            if (_isRecurring) ...[
              const Text(
                'Pilih Hari',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _weekDays.entries.map((entry) {
                  return FilterChip(
                    label: Text(entry.value),
                    selected: _selectedDays.contains(entry.key),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(entry.key);
                        } else {
                          _selectedDays.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Scheduled Exercises List
            const Text(
              'Jadwal Tersimpan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildScheduleList(),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveSchedule,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan Jadwal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    return Column(
      children: [
        _buildScheduleItem(
          '4-7-8 Breathing',
          'Rutin, 10:30',
          Icons.air,
        ),
        const SizedBox(height: 8),
        _buildScheduleItem(
          'Box Breathing',
          'Rutin, 15:30',
          Icons.air,
        ),
        const SizedBox(height: 8),
        _buildScheduleItem(
          'Deep Breathing',
          'Jadwal: 20:00',
          Icons.air,
        ),
      ],
    );
  }

  Widget _buildScheduleItem(String title, String schedule, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  schedule,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // TODO: Implement edit functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // TODO: Implement delete functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
