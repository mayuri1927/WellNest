import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLocalDatasource {
  Future<void> saveUser(String userId, String name, String email);
  Future<Map<String, dynamic>?> getUser();
  Future<void> clearUser();
  Future<bool> hasSeenOnboarding();
  Future<void> setOnboardingComplete();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  late Box _box;

  AuthLocalDatasourceImpl() {
    _box = Hive.box('auth');
  }

  @override
  Future<void> saveUser(String userId, String name, String email) async {
    await _box.put('userId', userId);
    await _box.put('userName', name);
    await _box.put('userEmail', email);
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final userId = _box.get('userId');
    if (userId == null) return null;
    
    return {
      'userId': userId,
      'userName': _box.get('userName'),
      'userEmail': _box.get('userEmail'),
    };
  }

  @override
  Future<void> clearUser() async {
    await _box.clear();
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return _box.get('hasSeenOnboarding', defaultValue: false) ?? false;
  }

  @override
  Future<void> setOnboardingComplete() async {
    await _box.put('hasSeenOnboarding', true);
  }
}

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasourceImpl();
});
