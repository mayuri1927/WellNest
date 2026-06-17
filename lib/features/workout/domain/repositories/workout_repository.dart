abstract class WorkoutRepository {
  Future<List<Map<String, dynamic>>> getWorkouts();
  Future<void> addWorkout(Map<String, dynamic> workout);
  Future<void> deleteWorkout(String id);
}
