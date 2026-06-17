import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_datasource.dart';
import '../datasources/workout_remote_datasource.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDatasource _remoteDatasource;
  final WorkoutLocalDatasource _localDatasource;

  WorkoutRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final workouts = await _remoteDatasource.getWorkouts();
      return workouts;
    } catch (e) {
      return await _localDatasource.getWorkouts();
    }
  }

  @override
  Future<void> addWorkout(Map<String, dynamic> workout) async {
    try {
      await _remoteDatasource.createWorkout(workout);
    } catch (e) {
      await _localDatasource.saveWorkout(workout);
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await _remoteDatasource.deleteWorkout(id);
    } catch (e) {
      await _localDatasource.deleteWorkout(id);
      rethrow;
    }
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final remoteDatasource = ref.watch(workoutRemoteDatasourceProvider);
  final localDatasource = ref.watch(workoutLocalDatasourceProvider);
  return WorkoutRepositoryImpl(remoteDatasource, localDatasource);
});
