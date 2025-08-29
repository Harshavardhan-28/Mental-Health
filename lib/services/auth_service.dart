import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  fb.User? get currentUser => _auth.currentUser;

  Future<fb.User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in aborted');

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google sign-in failed');
    } catch (e) {
      rethrow;
    }
  }

  Future<fb.User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Email sign-in failed');
    }
  }

  Future<fb.User?> signUpWithEmail(String email, String password, {String? displayName}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null && displayName != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }
      return _auth.currentUser;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Email sign-up failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
  }
}