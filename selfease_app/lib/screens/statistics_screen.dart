import 'package:flutter/material.dart';
import '../models/statistics_model.dart';
import '../services/database_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'Harian';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Gejala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Period Selection
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodButton('Harian'),
                _buildPeriodButton('Mingguan'),
                _buildPeriodButton('Bulanan'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Date Navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(
                        Duration(
                          days: _selectedPeriod == 'Harian'
                              ? 1
                              : _selectedPeriod == 'Mingguan'
                                  ? 7
                                  : 30,
                        ),
                      );
                    });
                  },
                ),
                Text(
                  '10-16 Mei 2025',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        Duration(
                          days: _selectedPeriod == 'Harian'
                              ? 1
                              : _selectedPeriod == 'Mingguan'
                                  ? 7
                                  : 30,
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Chart
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Intensitas Gejala',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Chart will be implemented here'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics Summary
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Gejala Fisik',
                          '12',
                          '2 hari yang lalu',
                          Icons.healing,
                          'Tinggi',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Gejala Mental',
                          '8',
                          '3 hari yang lalu',
                          Icons.psychology,
                          'Sedang',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;
    return TextButton(
      onPressed: () {
        setState(() => _selectedPeriod = period);
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onBackground,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(period),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String lastUpdate,
    IconData icon,
    String severity,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lastUpdate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severity == 'Tinggi'
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity,
                    style: TextStyle(
                      color: severity == 'Tinggi'
                          ? Colors.red
                          : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
