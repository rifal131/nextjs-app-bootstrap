import 'package:flutter/material.dart';
import 'dart:async';
import '../models/exercise_model.dart';
import '../services/database_service.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final String exerciseId;
  final String title;
  
  const BreathingExerciseScreen({
    super.key,
    required this.exerciseId,
    required this.title,
  });

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 300; // 5 minutes default
  Timer? _timer;
  String _currentPhase = '4-7-8';
  int _currentStep = 1;

  final List<String> _instructions = [
    'Tarik napas selama 4 detik',
    'Tahan napas selama 7 detik',
    'Hembuskan napas selama 8 detik',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds < _totalSeconds) {
          _currentSeconds++;
          // Update current step based on the breathing pattern (4-7-8)
          int cyclePosition = _currentSeconds % 19; // 4 + 7 + 8 = 19 seconds per cycle
          if (cyclePosition <= 4) {
            _currentStep = 1; // Inhale
          } else if (cyclePosition <= 11) {
            _currentStep = 2; // Hold
          } else {
            _currentStep = 3; // Exhale
          }
        } else {
          _timer?.cancel();
          _isPlaying = false;
          // Save exercise data
          _saveExerciseData();
        }
      });
    });
  }

  Future<void> _saveExerciseData() async {
    final exercise = ExerciseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: Get from auth service
      type: ExerciseType.breathing,
      duration: _currentSeconds,
      timestamp: DateTime.now(),
      notes: 'Completed ${widget.title} exercise',
    );

    try {
      await DatabaseService().saveExercise(exercise);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving exercise: $e')),
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
    double progress = _currentSeconds / _totalSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show exercise information
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exercise Type Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildExerciseTab('4-7-8', true),
                  const SizedBox(width: 16),
                  _buildExerciseTab('Deep Breathing', false),
                ],
              ),
              const SizedBox(height: 48),

              // Timer Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_currentSeconds),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _instructions[_currentStep - 1],
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 64,
                    ),
                    onPressed: _toggleTimer,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.replay_circle_filled,
                      size: 64,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentSeconds = 0;
                        _isPlaying = false;
                        _timer?.cancel();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Statistics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatistic('Total Sesi', '12'),
                  _buildStatistic('Menit', '45'),
                  _buildStatistic('Hari Beruntun', '7'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _currentPhase = title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
