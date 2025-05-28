class StatisticsModel {
  final String id;
  final String userId;
  final String exerciseId;
  final ExerciseType type;
  final int duration;
  final DateTime date;
  final DateTime timestamp;
  final int? breathingCount;
  final int? meditationScore;

  StatisticsModel({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.type,
    required this.duration,
    required this.date,
    required this.timestamp,
    this.breathingCount,
    this.meditationScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'type': type.toString(),
      'duration': duration,
      'date': date.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
      'breathingCount': breathingCount,
      'meditationScore': meditationScore,
    };
  }

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      id: json['id'],
      userId: json['userId'],
      exerciseId: json['exerciseId'],
      type: ExerciseType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      duration: json['duration'],
      date: DateTime.parse(json['date']),
      timestamp: DateTime.parse(json['timestamp']),
      breathingCount: json['breathingCount'],
      meditationScore: json['meditationScore'],
    );
  }

  // Helper method to get weekly statistics
  static List<StatisticsModel> getWeeklyStats(List<StatisticsModel> allStats) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return allStats.where((stat) => 
      stat.date.isAfter(weekStart) && 
      stat.date.isBefore(weekStart.add(Duration(days: 7)))
    ).toList();
  }

  // Helper method to get monthly statistics
  static List<StatisticsModel> getMonthlyStats(List<StatisticsModel> allStats) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    return allStats.where((stat) => 
      stat.date.isAfter(monthStart) && 
      stat.date.isBefore(DateTime(now.year, now.month + 1, 0))
    ).toList();
  }
}

enum ExerciseType {
  breathing,
  meditation,
  mindfulness
}
