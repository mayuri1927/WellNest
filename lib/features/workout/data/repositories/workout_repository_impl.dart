import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_datasource.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDatasource _datasource;

  WorkoutRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    return await _datasource.getWorkouts();
  }

  @override
  Future<void> addWorkout(Map<String, dynamic> workout) async {
    await _datasource.saveWorkout(workout);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _datasource.deleteWorkout(id);
  }
}
