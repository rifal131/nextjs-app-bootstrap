import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../models/statistics_model.dart';
import '../services/database_service.dart';

class ExerciseStatisticsScreen extends StatefulWidget {
  const ExerciseStatisticsScreen({super.key});

  @override
  State<ExerciseStatisticsScreen> createState() => _ExerciseStatisticsScreenState();
}

class _ExerciseStatisticsScreenState extends State<ExerciseStatisticsScreen> {
  final List<String> _exerciseTypes = [
    '4-7-8 Breathing',
    'Box Breathing',
    'Deep Breathing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Latihan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Statistics
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeStatistic('45', 'Total', Icons.timer),
                  _buildTimeStatistic('28', 'Minggu Ini', Icons.calendar_today),
                  _buildTimeStatistic('7', 'Hari Ini', Icons.today),
                ],
              ),
            ),

            // Progress Bar Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Mingguan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProgressBar('Senin', 0.8),
                  const SizedBox(height: 8),
                  _buildProgressBar('Selasa', 0.6),
                  const SizedBox(height: 8),
                  _buildProgressBar('Rabu', 0.9),
                ],
              ),
            ),

            // Exercise Types Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jenis Latihan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exerciseTypes.length,
                    itemBuilder: (context, index) {
                      return _buildExerciseTypeItem(
                        _exerciseTypes[index],
                        '${(index + 1) * 5} min',
                        index == 0 ? Icons.favorite : Icons.air,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Achievement Badges
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pencapaian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAchievementBadge('Pemula', Icons.star),
                      _buildAchievementBadge('7 Hari', Icons.calendar_today),
                      _buildAchievementBadge('20 Sesi', Icons.fitness_center),
                      _buildAchievementBadge('Master', Icons.emoji_events),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeStatistic(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
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

  Widget _buildProgressBar(String day, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildExerciseTypeItem(String title, String duration, IconData icon) {
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
      trailing: Text(
        duration,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildAchievementBadge(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
