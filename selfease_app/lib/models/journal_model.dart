enum MoodType {
  veryBad,
  bad,
  neutral,
  good,
  veryGood
}

class JournalEntry {
  final String id;
  final String userId;
  final String content;
  final MoodType mood;
  final DateTime date;
  final DateTime timestamp;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    required this.mood,
    required this.date,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'mood': mood.toString(),
      'date': date.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      mood: MoodType.values.firstWhere(
        (e) => e.toString() == json['mood'],
      ),
      date: DateTime.parse(json['date']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
