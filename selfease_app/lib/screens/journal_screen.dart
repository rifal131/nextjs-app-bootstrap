import 'package:flutter/material.dart';
import '../models/journal_model.dart';
import '../services/database_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _journalController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  MoodType _selectedMood = MoodType.neutral;
  bool _isLoading = false;

  final Map<MoodType, IconData> _moodIcons = {
    MoodType.veryBad: Icons.sentiment_very_dissatisfied,
    MoodType.bad: Icons.sentiment_dissatisfied,
    MoodType.neutral: Icons.sentiment_neutral,
    MoodType.good: Icons.sentiment_satisfied,
    MoodType.veryGood: Icons.sentiment_very_satisfied,
  };

  final Map<MoodType, String> _moodLabels = {
    MoodType.veryBad: 'Sangat Buruk',
    MoodType.bad: 'Buruk',
    MoodType.neutral: 'Biasa',
    MoodType.good: 'Baik',
    MoodType.veryGood: 'Sangat Baik',
  };

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _saveJournal() async {
    if (_journalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi refleksi Anda')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final entry = JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id', // TODO: Get from auth service
        content: _journalController.text,
        mood: _selectedMood,
        date: _selectedDate,
        timestamp: DateTime.now(),
      );

      await _databaseService.saveJournalEntry(entry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refleksi berhasil disimpan')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                });
              },
            ),
            Text(
              '${_selectedDate.day} Mei 2025',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bagaimana perasaan dan pengalaman hari ini...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Mood Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: MoodType.values.map((mood) {
                return _buildMoodButton(mood);
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Journal Entry
            TextField(
              controller: _journalController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Tulis refleksi Anda di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Weekly Mood Chart
            const Text(
              'Gejala Mood Mingguan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildMoodChart(),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveJournal,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan Refleksi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(MoodType mood) {
    final isSelected = _selectedMood == mood;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            _moodIcons[mood],
            size: 32,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: () {
            setState(() => _selectedMood = mood);
          },
        ),
        Text(
          _moodLabels[mood]!,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodChart() {
    // Placeholder for mood chart
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Grafik mood akan ditampilkan di sini'),
      ),
    );
  }
}
