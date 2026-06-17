import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/repositories/workout_repository_impl.dart';

class WorkoutState {
  final List<Workout> workouts;
  final bool isLoading;
  final String? error;

  const WorkoutState({
    this.workouts = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class Workout {
  final String id;
  final String userId;
  final String type;
  final String? title;
  final int duration;
  final int caloriesBurned;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.userId,
    required this.type,
    this.title,
    required this.duration,
    required this.caloriesBurned,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  Workout copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    int? duration,
    int? caloriesBurned,
    String? notes,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WorkoutNotifier extends AsyncNotifier<WorkoutState> {
  late Box _workoutBox;

  @override
  Future<WorkoutState> build() async {
    _workoutBox = Hive.box('workouts');
    return _loadWorkouts();
  }

  WorkoutState _loadWorkouts() {
    final workoutData = _workoutBox.get('workouts', defaultValue: []);
    if (workoutData is List) {
      final workouts = workoutData.map((w) {
        if (w is Map) {
          return Workout(
            id: w['id'] ?? '',
            userId: w['userId'] ?? '',
            type: w['type'] ?? 'Cardio',
            title: w['title'],
            duration: w['duration'] ?? 0,
            caloriesBurned: w['caloriesBurned'] ?? 0,
            notes: w['notes'],
            date: w['date'] != null ? DateTime.parse(w['date']) : DateTime.now(),
            createdAt: w['createdAt'] != null ? DateTime.parse(w['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<Workout>().toList();
      return WorkoutState(workouts: workouts);
    }
    return const WorkoutState();
  }

  Future<void> fetchWorkouts() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(workoutRepositoryProvider);
      final data = await repository.getWorkouts();
      final workouts = data.map((w) => Workout(
        id: w['id'] ?? '',
        userId: w['userId'] ?? '',
        type: w['type'] ?? 'Cardio',
        title: w['title'],
        duration: w['duration'] ?? 0,
        caloriesBurned: w['caloriesBurned'] ?? 0,
        notes: w['notes'],
        date: w['date'] != null ? DateTime.parse(w['date']) : DateTime.now(),
        createdAt: w['createdAt'] != null ? DateTime.parse(w['createdAt']) : DateTime.now(),
      )).toList();
      state = AsyncValue.data(WorkoutState(workouts: workouts));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> addWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(workoutRepositoryProvider);
      await repository.addWorkout({
        'id': workout.id,
        'userId': workout.userId,
        'type': workout.type,
        'title': workout.title,
        'duration': workout.duration,
        'caloriesBurned': workout.caloriesBurned,
        'notes': workout.notes,
        'date': workout.date.toIso8601String(),
        'createdAt': workout.createdAt.toIso8601String(),
      });
      await fetchWorkouts();
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      final repository = ref.read(workoutRepositoryProvider);
      await repository.deleteWorkout(id);
      final currentWorkouts = state.value?.workouts ?? [];
      final newWorkouts = currentWorkouts.where((w) => w.id != id).toList();
      state = AsyncValue.data(WorkoutState(workouts: newWorkouts));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }
}

final workoutProvider = AsyncNotifierProvider<WorkoutNotifier, WorkoutState>(() {
  return WorkoutNotifier();
});
