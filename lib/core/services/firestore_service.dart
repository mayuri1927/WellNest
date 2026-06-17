import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseOptions {
  static FirebaseOptions? _current;
  
  static FirebaseOptions get currentPlatform {
    _current ??= FirebaseOptions(
      apiKey: kIsWeb ? 'AIzaSyDXI5nKyB4Vhf5k7mcdLb6GQrtucPIJ9CA' : '',
      appId: kIsWeb ? '1:591596935139:web:placeholder' : '1:591596935139:ios:bce09b5854d0e78b8732d6',
      messagingSenderId: '591596935139',
      projectId: 'wellnes-6e09f',
      storageBucket: 'wellnes-6e09f.firebasestorage.app',
    );
    return _current!;
  }

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String storageBucket;

  FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storageBucket,
  });
}

class FirestoreService {
  static bool _initialized = false;
  static FirebaseFirestore? _firestore;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyDXI5nKyB4Vhf5k7mcdLb6GQrtucPIJ9CA',
          appId: kIsWeb ? '1:591596935139:web:placeholder' : '1:591596935139:ios:bce09b5854d0e78b8732d6',
          messagingSenderId: '591596935139',
          projectId: 'wellnes-6e09f',
          storageBucket: 'wellnes-6e09f.firebasestorage.app',
        ),
      );
      _firestore = FirebaseFirestore.instance;
      _initialized = true;
    } catch (e) {
      debugPrint('Firestore initialization error: $e');
    }
  }

  static FirebaseFirestore? get instance => _firestore;

  static Future<void> initializeCollections() async {
    if (!_initialized) await initialize();
    
    final collections = [
      'users',
      'workouts',
      'meals',
      'medicines',
      'appointments',
      'documents',
      'family_members',
    ];

    for (final collection in collections) {
      try {
        await _firestore!.collection(collection).doc('_init').set({'initialized': true});
        await _firestore!.collection(collection).doc('_init').delete();
      } catch (e) {
        debugPrint('Collection $collection already exists or error: $e');
      }
    }
  }
}
