import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/exercise_model.dart';
import '../models/journal_model.dart';
import '../models/statistics_model.dart';
import '../models/notification_model.dart';
import '../models/schedule_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users Collection
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromJson(doc.data()!) : null;
  }

  // Exercises Collection
  Future<void> saveExercise(ExerciseModel exercise) async {
    await _db.collection('exercises').doc(exercise.id).set(exercise.toJson());
  }

  Future<List<ExerciseModel>> getUserExercises(String userId) async {
    final snapshot = await _db
        .collection('exercises')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => ExerciseModel.fromJson(doc.data()))
        .toList();
  }

  // Journal Entries Collection
  Future<void> saveJournalEntry(JournalEntry entry) async {
    await _db.collection('journal_entries').doc(entry.id).set(entry.toJson());
  }

  Future<List<JournalEntry>> getUserJournalEntries(String userId) async {
    final snapshot = await _db
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => JournalEntry.fromJson(doc.data()))
        .toList();
  }

  // Statistics Collection
  Future<void> saveStatistics(StatisticsModel stats) async {
    await _db.collection('statistics').doc(stats.id).set(stats.toJson());
  }

  Future<List<StatisticsModel>> getUserStatistics(String userId) async {
    final snapshot = await _db
        .collection('statistics')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => StatisticsModel.fromJson(doc.data()))
        .toList();
  }

  // Notification Settings Collection
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await _db.collection('notification_settings').doc(settings.id).set(settings.toJson());
  }

  Future<List<NotificationSettings>> getUserNotificationSettings(String userId) async {
    final snapshot = await _db
        .collection('notification_settings')
        .where('userId', isEqualTo: userId)
        .get();
    
    return snapshot.docs
        .map((doc) => NotificationSettings.fromJson(doc.data()))
        .toList();
  }

  // Schedules Collection
  Future<void> saveSchedule(ScheduleModel schedule) async {
    await _db.collection('schedules').doc(schedule.id).set(schedule.toJson());
  }

  Future<List<ScheduleModel>> getUserSchedules(String userId) async {
    final snapshot = await _db
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => ScheduleModel.fromJson(doc.data()))
        .toList();
  }

  // Delete Methods
  Future<void> deleteJournalEntry(String entryId) async {
    await _db.collection('journal_entries').doc(entryId).delete();
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await _db.collection('schedules').doc(scheduleId).delete();
  }

  Future<void> deleteNotificationSetting(String settingId) async {
    await _db.collection('notification_settings').doc(settingId).delete();
  }

  // Stream Methods for Real-time Updates
  Stream<List<ExerciseModel>> streamUserExercises(String userId) {
    return _db
        .collection('exercises')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<JournalEntry>> streamUserJournalEntries(String userId) {
    return _db
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromJson(doc.data()))
            .toList());
  }

  Stream<List<ScheduleModel>> streamUserSchedules(String userId) {
    return _db
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScheduleModel.fromJson(doc.data()))
            .toList());
  }
}
