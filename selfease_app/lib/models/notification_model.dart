enum NotificationType {
  exercise,
  meditation,
  journal,
  breathing,
  general
}

class NotificationSettings {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool isEnabled;
  final DateTime? scheduleTime;
  final List<int>? recurringDays; // 1-7 representing Monday-Sunday
  final DateTime timestamp;

  NotificationSettings({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isEnabled,
    this.scheduleTime,
    this.recurringDays,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'title': title,
      'message': message,
      'isEnabled': isEnabled,
      'scheduleTime': scheduleTime?.toIso8601String(),
      'recurringDays': recurringDays,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      id: json['id'],
      userId: json['userId'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      title: json['title'],
      message: json['message'],
      isEnabled: json['isEnabled'],
      scheduleTime: json['scheduleTime'] != null 
        ? DateTime.parse(json['scheduleTime'])
        : null,
      recurringDays: json['recurringDays'] != null 
        ? List<int>.from(json['recurringDays'])
        : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  NotificationSettings copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    bool? isEnabled,
    DateTime? scheduleTime,
    List<int>? recurringDays,
    DateTime? timestamp,
  }) {
    return NotificationSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isEnabled: isEnabled ?? this.isEnabled,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      recurringDays: recurringDays ?? this.recurringDays,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
