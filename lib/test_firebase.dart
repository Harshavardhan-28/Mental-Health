import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Simple test to verify Firebase connection
Future<void> testFirebaseConnection() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth instance created');
    print('Current user: ${auth.currentUser?.email ?? 'Not signed in'}');
    
    // Test creating a user account
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'testpassword123',
      );
      print('✅ Test user created: ${userCredential.user?.email}');
      
      // Clean up - delete the test user
      await userCredential.user?.delete();
      print('✅ Test user deleted');
    } catch (e) {
      print('❌ Auth test failed: $e');
    }
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }
}
