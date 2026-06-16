import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/workout_entity.dart';
import 'providers.dart';
import 'auth_provider.dart';

class WorkoutState {
  final List<WorkoutEntity> workouts;
  final bool isLoading;
  final String? errorMessage;
  final DateTime selectedDate;

  WorkoutState({
    this.workouts = const [],
    this.isLoading = false,
    this.errorMessage,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  WorkoutState copyWith({
    List<WorkoutEntity>? workouts,
    bool? isLoading,
    String? errorMessage,
    DateTime? selectedDate,
  }) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  List<WorkoutEntity> get workoutsForSelectedDate {
    return workouts.where((w) {
      return w.date.year == selectedDate.year &&
          w.date.month == selectedDate.month &&
          w.date.day == selectedDate.day;
    }).toList();
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  final Ref _ref;

  WorkoutNotifier(this._ref) : super(WorkoutState()) {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final workouts = await _ref.read(workoutRepositoryProvider).getWorkouts(user.id);
        state = state.copyWith(workouts: workouts, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addWorkout({
    required String title,
    required String type,
    required int durationMinutes,
    required int caloriesBurned,
    required DateTime date,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final workout = WorkoutEntity(
          id: const Uuid().v4(),
          userId: user.id,
          title: title,
          type: type,
          durationMinutes: durationMinutes,
          caloriesBurned: caloriesBurned,
          date: date,
          notes: notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _ref.read(workoutRepositoryProvider).addWorkout(workout);
        await loadWorkouts();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateWorkout(WorkoutEntity workout) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(workoutRepositoryProvider).updateWorkout(workout);
      await loadWorkouts();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteWorkout(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(workoutRepositoryProvider).deleteWorkout(id);
      await loadWorkouts();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier(ref);
});

final todayWorkoutsProvider = Provider<List<WorkoutEntity>>((ref) {
  final workoutState = ref.watch(workoutProvider);
  return workoutState.workoutsForSelectedDate;
});

final workoutStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) return {};
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return await ref.read(workoutRepositoryProvider).getWorkoutStats(
        user.id,
        startOfWeek,
        now,
      );
});
