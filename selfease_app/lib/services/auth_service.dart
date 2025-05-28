import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Create auth user
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Create user model
        final UserModel userModel = UserModel(
          id: user.uid,
          fullName: fullName,
          email: email,
          createdAt: DateTime.now(),
        );

        // Save user to database
        await _db.createUser(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Get user model from database
        return await _db.getUser(user.uid);
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? email,
  }) async {
    try {
      if (email != null) {
        await currentUser?.updateEmail(email);
      }

      final userModel = await _db.getUser(userId);
      if (userModel != null) {
        final updatedUser = UserModel(
          id: userId,
          fullName: fullName ?? userModel.fullName,
          email: email ?? userModel.email,
          createdAt: userModel.createdAt,
        );
        await _db.createUser(updatedUser);
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount(String userId) async {
    try {
      await currentUser?.delete();
      // Add any cleanup of user data in database here
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }
}
