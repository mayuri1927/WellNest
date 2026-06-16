import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/workout_model.dart';
import '../../core/utils/date_time_utils.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDataSource _workoutDataSource;

  WorkoutRepositoryImpl({required WorkoutDataSource workoutDataSource})
      : _workoutDataSource = workoutDataSource;

  @override
  Future<void> addWorkout(WorkoutEntity workout) async {
    final model = WorkoutModel.fromEntity(workout);
    await _workoutDataSource.addWorkout(model);
  }

  @override
  Future<void> updateWorkout(WorkoutEntity workout) async {
    final model = WorkoutModel.fromEntity(workout);
    await _workoutDataSource.updateWorkout(workout.id, model);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _workoutDataSource.deleteWorkout(id);
  }

  @override
  Future<List<WorkoutEntity>> getWorkouts(String userId) async {
    final models = await _workoutDataSource.getWorkouts(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<WorkoutEntity>> streamWorkouts(String userId) {
    return _workoutDataSource.streamWorkouts(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<WorkoutEntity>> getWorkoutsByDate(String userId, DateTime date) async {
    final allWorkouts = await getWorkouts(userId);
    return allWorkouts
        .where((w) => DateTimeUtils.isSameDay(w.date, date))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getWorkoutStats(
      String userId, DateTime startDate, DateTime endDate) async {
    final allWorkouts = await getWorkouts(userId);
    final filteredWorkouts = allWorkouts.where((w) =>
        w.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        w.date.isBefore(endDate.add(const Duration(days: 1))));

    final totalWorkouts = filteredWorkouts.length;
    final totalMinutes = filteredWorkouts.fold<int>(
        0, (sum, w) => sum + w.durationMinutes);
    final totalCalories = filteredWorkouts.fold<int>(
        0, (sum, w) => sum + w.caloriesBurned);

    final workoutTypes = <String, int>{};
    for (final workout in filteredWorkouts) {
      workoutTypes[workout.type] = (workoutTypes[workout.type] ?? 0) + 1;
    }

    return {
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
      'totalCalories': totalCalories,
      'workoutTypes': workoutTypes,
    };
  }
}
