enum ExerciseType {
  breathing,
  meditation,
  mindfulness
}

class ExerciseModel {
  final String id;
  final String userId;
  final ExerciseType type;
  final int duration; // in seconds
  final DateTime timestamp;
  final String? notes;

  ExerciseModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.duration,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      userId: json['userId'],
      type: ExerciseType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      duration: json['duration'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }
}
