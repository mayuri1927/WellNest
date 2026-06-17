import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'YOUR_API_KEY',
          appId: 'YOUR_APP_ID',
          messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        ),
      );
      _initialized = true;
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  static bool get isInitialized => _initialized;
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});
