import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDXI5nKyB4Vhf5k7mcdLb6GQrtucPIJ9CA',
          appId: '1:591596935139:ios:bce09b5854d0e78b8732d6',
          messagingSenderId: '591596935139',
          projectId: 'wellnes-6e09f',
          storageBucket: 'wellnes-6e09f.firebasestorage.app',
          iosBundleId: 'com.wellnes.ios',
        ),
      );
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
