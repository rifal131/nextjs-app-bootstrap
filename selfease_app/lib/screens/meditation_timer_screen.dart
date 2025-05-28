import 'package:flutter/material.dart';
import 'dart:async';
import '../models/exercise_model.dart';
import '../services/database_service.dart';

class MeditationTimerScreen extends StatefulWidget {
  const MeditationTimerScreen({super.key});

  @override
  State<MeditationTimerScreen> createState() => _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends State<MeditationTimerScreen> {
  final DatabaseService _databaseService = DatabaseService();
  Timer? _timer;
  bool _isPlaying = false;
  int _selectedDuration = 10; // Default 10 minutes
  int _remainingSeconds = 600; // 10 minutes in seconds
  String _selectedType = 'Meditasi Mindfulness';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isPlaying = false;
          _saveMeditationSession();
        }
      });
    });
  }

  Future<void> _saveMeditationSession() async {
    final exercise = ExerciseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: Get from auth service
      type: ExerciseType.meditation,
      duration: (_selectedDuration * 60) - _remainingSeconds,
      timestamp: DateTime.now(),
      notes: 'Completed $_selectedType session',
    );

    try {
      await _databaseService.saveExercise(exercise);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi meditasi berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedType,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Timer Display
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            // Duration Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationChip('5 menit', 5),
                const SizedBox(width: 8),
                _buildDurationChip('10 menit', 10),
                const SizedBox(width: 8),
                _buildDurationChip('15 menit', 15),
              ],
            ),

            const Spacer(),

            // Meditation Types
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sesi Selanjutnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMeditationType(
                    'Meditasi Relaksasi',
                    '5 menit',
                    Icons.spa,
                  ),
                  const SizedBox(height: 8),
                  _buildMeditationType(
                    'Meditasi Fokus',
                    '2 menit',
                    Icons.psychology,
                  ),
                  const SizedBox(height: 8),
                  _buildMeditationType(
                    'Meditasi Tidur',
                    '2 menit',
                    Icons.nightlight_round,
                  ),
                ],
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        if (_isPlaying) {
                          _startTimer();
                        } else {
                          _timer?.cancel();
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(
                      Icons.replay_circle_filled,
                      size: 64,
                    ),
                    onPressed: () {
                      setState(() {
                        _timer?.cancel();
                        _isPlaying = false;
                        _remainingSeconds = _selectedDuration * 60;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(String label, int minutes) {
    final isSelected = _selectedDuration == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: _isPlaying
          ? null
          : (selected) {
              if (selected) {
                setState(() {
                  _selectedDuration = minutes;
                  _remainingSeconds = minutes * 60;
                });
              }
            },
    );
  }

  Widget _buildMeditationType(String title, String duration, IconData icon) {
    return ListTile(
      leading: Container(
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
      title: Text(title),
      subtitle: Text(duration),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        setState(() {
          _selectedType = title;
        });
      },
    );
  }
}
