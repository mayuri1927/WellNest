import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_profile_model.dart';

abstract class HealthProfileLocalDatasource {
  Future<void> saveHealthProfile(HealthProfile profile);
  Future<HealthProfile?> getHealthProfile();
  Future<void> clearHealthProfile();
  Future<bool> hasCompletedHealthProfile();
  Future<void> setHealthProfileComplete();
}

class HealthProfileLocalDatasourceImpl implements HealthProfileLocalDatasource {
  late Box _box;

  HealthProfileLocalDatasourceImpl() {
    _box = Hive.box('health_profile');
  }

  @override
  Future<void> saveHealthProfile(HealthProfile profile) async {
    await _box.put('height', profile.height);
    await _box.put('age', profile.age);
    await _box.put('weight', profile.weight);
    if (profile.targetWeight != null) {
      await _box.put('targetWeight', profile.targetWeight);
    }
    await _box.put('gender', profile.gender.value);
    await _box.put('healthGoal', profile.healthGoal.value);
    await _box.put('dailyCalorieTarget', profile.dailyCalorieTarget);
    if (profile.bmi != null) {
      await _box.put('bmi', profile.bmi);
    }
    if (profile.bmr != null) {
      await _box.put('bmr', profile.bmr);
    }
    await _box.put('userId', profile.userId);
    await _box.put('createdAt', DateTime.now().toIso8601String());
  }

  @override
  Future<HealthProfile?> getHealthProfile() async {
    final userId = _box.get('userId');
    if (userId == null) return null;

    return HealthProfile(
      userId: userId,
      height: _box.get('height'),
      age: _box.get('age'),
      weight: _box.get('weight'),
      targetWeight: _box.get('targetWeight'),
      gender: _box.get('gender'),
      healthGoal: _box.get('healthGoal'),
      dailyCalorieTarget: _box.get('dailyCalorieTarget'),
      bmi: _box.get('bmi'),
      bmr: _box.get('bmr'),
      createdAt: _box.get('createdAt') != null
          ? DateTime.parse(_box.get('createdAt'))
          : null,
    );
  }

  @override
  Future<void> clearHealthProfile() async {
    await _box.clear();
  }

  @override
  Future<bool> hasCompletedHealthProfile() async {
    return _box.get('hasCompletedHealthProfile', defaultValue: false) ?? false;
  }

  @override
  Future<void> setHealthProfileComplete() async {
    await _box.put('hasCompletedHealthProfile', true);
  }
}

final healthProfileLocalDatasourceProvider =
    Provider<HealthProfileLocalDatasource>((ref) {
      return HealthProfileLocalDatasourceImpl();
    });
