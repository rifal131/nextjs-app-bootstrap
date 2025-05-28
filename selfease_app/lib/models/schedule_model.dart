import 'exercise_model.dart';

class ScheduleModel {
  final String id;
  final String userId;
  final ExerciseType exerciseType;
  final DateTime scheduledTime;
  final bool isRecurring;
  final List<int>? recurringDays; // 1-7 representing Monday-Sunday
  final int duration; // in seconds
  final String? notes;
  final DateTime timestamp;
  final bool isCompleted;

  ScheduleModel({
    required this.id,
    required this.userId,
    required this.exerciseType,
    required this.scheduledTime,
    required this.isRecurring,
    this.recurringDays,
    required this.duration,
    this.notes,
    required this.timestamp,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'exerciseType': exerciseType.toString(),
      'scheduledTime': scheduledTime.toIso8601String(),
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'duration': duration,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      userId: json['userId'],
      exerciseType: ExerciseType.values.firstWhere(
        (e) => e.toString() == json['exerciseType'],
      ),
      scheduledTime: DateTime.parse(json['scheduledTime']),
      isRecurring: json['isRecurring'],
      recurringDays: json['recurringDays'] != null 
        ? List<int>.from(json['recurringDays'])
        : null,
      duration: json['duration'],
      notes: json['notes'],
      timestamp: DateTime.parse(json['timestamp']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  ScheduleModel copyWith({
    String? id,
    String? userId,
    ExerciseType? exerciseType,
    DateTime? scheduledTime,
    bool? isRecurring,
    List<int>? recurringDays,
    int? duration,
    String? notes,
    DateTime? timestamp,
    bool? isCompleted,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseType: exerciseType ?? this.exerciseType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Helper method to check if schedule is for today
  bool get isForToday {
    final now = DateTime.now();
    if (!isRecurring) {
      return scheduledTime.year == now.year &&
             scheduledTime.month == now.month &&
             scheduledTime.day == now.day;
    }
    return recurringDays?.contains(now.weekday) ?? false;
  }

  // Helper method to get next occurrence
  DateTime? getNextOccurrence() {
    final now = DateTime.now();
    if (!isRecurring) {
      return scheduledTime.isAfter(now) ? scheduledTime : null;
    }

    if (recurringDays == null || recurringDays!.isEmpty) return null;

    // Sort recurring days
    final sortedDays = List<int>.from(recurringDays!)..sort();
    
    // Find next day
    for (final day in sortedDays) {
      if (day > now.weekday) {
        return DateTime(
          now.year,
          now.month,
          now.day + (day - now.weekday),
          scheduledTime.hour,
          scheduledTime.minute,
        );
      }
    }

    // If no day found, get first day of next week
    return DateTime(
      now.year,
      now.month,
      now.day + (7 - now.weekday) + sortedDays.first,
      scheduledTime.hour,
      scheduledTime.minute,
    );
  }
}
