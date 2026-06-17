import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class WorkoutLocalDatasource {
  Future<List<Map<String, dynamic>>> getWorkouts();
  Future<void> saveWorkout(Map<String, dynamic> workout);
  Future<void> deleteWorkout(String id);
}

class WorkoutLocalDatasourceImpl implements WorkoutLocalDatasource {
  late Box _box;

  WorkoutLocalDatasourceImpl() {
    _box = Hive.box('workouts');
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final data = _box.get('workouts', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveWorkout(Map<String, dynamic> workout) async {
    final workouts = await getWorkouts();
    workouts.add(workout);
    await _box.put('workouts', workouts);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    final workouts = await getWorkouts();
    workouts.removeWhere((w) => w['id'] == id);
    await _box.put('workouts', workouts);
  }
}

final workoutLocalDatasourceProvider = Provider<WorkoutLocalDatasource>((ref) {
  return WorkoutLocalDatasourceImpl();
});
