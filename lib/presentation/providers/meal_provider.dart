import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/meal_entity.dart';
import 'providers.dart';
import 'auth_provider.dart';

class MealState {
  final List<MealEntity> meals;
  final bool isLoading;
  final String? errorMessage;
  final DateTime selectedDate;

  MealState({
    this.meals = const [],
    this.isLoading = false,
    this.errorMessage,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  MealState copyWith({
    List<MealEntity>? meals,
    bool? isLoading,
    String? errorMessage,
    DateTime? selectedDate,
  }) {
    return MealState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  List<MealEntity> get mealsForSelectedDate {
    return meals.where((m) {
      return m.dateTime.year == selectedDate.year &&
          m.dateTime.month == selectedDate.month &&
          m.dateTime.day == selectedDate.day;
    }).toList();
  }

  int get totalCaloriesForSelectedDate {
    return mealsForSelectedDate.fold(0, (sum, m) => sum + m.calories);
  }
}

class MealNotifier extends StateNotifier<MealState> {
  final Ref _ref;

  MealNotifier(this._ref) : super(MealState()) {
    loadMeals();
  }

  Future<void> loadMeals() async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final meals = await _ref.read(mealRepositoryProvider).getMeals(user.id);
        state = state.copyWith(meals: meals, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addMeal({
    required String title,
    required String type,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required DateTime dateTime,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final meal = MealEntity(
          id: const Uuid().v4(),
          userId: user.id,
          title: title,
          type: type,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          dateTime: dateTime,
          notes: notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _ref.read(mealRepositoryProvider).addMeal(meal);
        await loadMeals();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateMeal(MealEntity meal) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(mealRepositoryProvider).updateMeal(meal);
      await loadMeals();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteMeal(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(mealRepositoryProvider).deleteMeal(id);
      await loadMeals();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final mealProvider = StateNotifierProvider<MealNotifier, MealState>((ref) {
  return MealNotifier(ref);
});

final todayMealsProvider = Provider<List<MealEntity>>((ref) {
  final mealState = ref.watch(mealProvider);
  return mealState.mealsForSelectedDate;
});

final todayCaloriesProvider = Provider<int>((ref) {
  final mealState = ref.watch(mealProvider);
  return mealState.totalCaloriesForSelectedDate;
});
