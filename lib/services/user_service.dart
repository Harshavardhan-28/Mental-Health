import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Check if the current user has completed their profile setup
  /// This is a simple implementation - in a real app, you'd store this in Firestore
  Future<bool> hasCompletedProfile() async {
    final user = currentUser;
    if (user == null) return false;

    // For now, we'll use a simple heuristic:
    // If the user was created very recently (within the last few minutes), 
    // they probably haven't completed their profile
    final metadata = user.metadata;
    if (metadata.creationTime == null) return true;

    final now = DateTime.now();
    final creationTime = metadata.creationTime!;
    final timeSinceCreation = now.difference(creationTime);

    // If account was created in the last 5 minutes, consider profile incomplete
    if (timeSinceCreation.inMinutes < 5) {
      return false;
    }

    return true;
  }

  /// Mark that the user has completed their profile setup
  /// In a real app, you'd update this in Firestore
  Future<void> markProfileCompleted() async {
    // This is a placeholder - in a real app you'd update Firestore
    // For now, we'll just update the display name to indicate completion
    final user = currentUser;
    if (user != null && (user.displayName == null || user.displayName!.isEmpty)) {
      await user.updateDisplayName(user.email?.split('@')[0] ?? 'User');
    }
  }

  /// Check if this is a completely new user (first time ever signing in)
  bool isNewUser() {
    final user = currentUser;
    if (user == null) return false;

    final metadata = user.metadata;
    if (metadata.creationTime == null || metadata.lastSignInTime == null) {
      return false;
    }

    // If creation time and last sign-in time are very close, it's a new user
    final timeDifference = metadata.lastSignInTime!.difference(metadata.creationTime!).abs();
    return timeDifference.inMinutes < 2;
  }
}
