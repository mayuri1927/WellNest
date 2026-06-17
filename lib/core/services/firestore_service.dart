import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static bool _initialized = false;
  static FirebaseFirestore? _firestore;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp();
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
