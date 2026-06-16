import '../../domain/entities/workout_entity.dart';

abstract class WorkoutRepository {
  Future<void> addWorkout(WorkoutEntity workout);
  Future<void> updateWorkout(WorkoutEntity workout);
  Future<void> deleteWorkout(String id);
  Future<List<WorkoutEntity>> getWorkouts(String userId);
  Stream<List<WorkoutEntity>> streamWorkouts(String userId);
  Future<List<WorkoutEntity>> getWorkoutsByDate(String userId, DateTime date);
  Future<Map<String, dynamic>> getWorkoutStats(String userId, DateTime startDate, DateTime endDate);
}
