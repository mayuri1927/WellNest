import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final int duration;
  final int caloriesBurned;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.userId,
    required this.type,
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

  Future<void> addWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      final currentWorkouts = state.value?.workouts ?? [];
      final newWorkouts = [...currentWorkouts, workout];
      
      await _workoutBox.put('workouts', newWorkouts.map((w) => {
        'id': w.id,
        'userId': w.userId,
        'type': w.type,
        'duration': w.duration,
        'caloriesBurned': w.caloriesBurned,
        'notes': w.notes,
        'date': w.date.toIso8601String(),
        'createdAt': w.createdAt.toIso8601String(),
      }).toList());

      state = AsyncValue.data(WorkoutState(workouts: newWorkouts));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> deleteWorkout(String id) async {
    final currentWorkouts = state.value?.workouts ?? [];
    final newWorkouts = currentWorkouts.where((w) => w.id != id).toList();
    
    await _workoutBox.put('workouts', newWorkouts.map((w) => {
      'id': w.id,
      'userId': w.userId,
      'type': w.type,
      'duration': w.duration,
      'caloriesBurned': w.caloriesBurned,
      'notes': w.notes,
      'date': w.date.toIso8601String(),
      'createdAt': w.createdAt.toIso8601String(),
    }).toList());

    state = AsyncValue.data(WorkoutState(workouts: newWorkouts));
  }
}

final workoutProvider = AsyncNotifierProvider<WorkoutNotifier, WorkoutState>(() {
  return WorkoutNotifier();
});
