import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: 'AIzaSyDXI5nKyB4Vhf5k7mcdLb6GQrtucPIJ9CA',
            appId: '1:591596935139:web:placeholder',
            messagingSenderId: '591596935139',
            projectId: 'wellnes-6e09f',
            storageBucket: 'wellnes-6e09f.firebasestorage.app',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
      _initialized = true;
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  static bool get isInitialized => _initialized;
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});
