import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MealState {
  final List<Meal> meals;
  final bool isLoading;
  final String? error;

  const MealState({this.meals = const [], this.isLoading = false, this.error});

  MealState copyWith({List<Meal>? meals, bool? isLoading, String? error}) {
    return MealState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class Meal {
  final String id;
  final String userId;
  final String name;
  final String mealType;
  final int calories;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.mealType,
    required this.calories,
    this.notes,
    required this.date,
    required this.createdAt,
  });
}

class MealNotifier extends AsyncNotifier<MealState> {
  late Box _mealBox;

  @override
  Future<MealState> build() async {
    _mealBox = Hive.box('meals');
    return _loadMeals();
  }

  MealState _loadMeals() {
    final mealData = _mealBox.get('meals', defaultValue: []);
    if (mealData is List) {
      final meals = mealData.map((m) {
        if (m is Map) {
          return Meal(
            id: m['id'] ?? '',
            userId: m['userId'] ?? '',
            name: m['name'] ?? '',
            mealType: m['mealType'] ?? 'Snack',
            calories: m['calories'] ?? 0,
            notes: m['notes'],
            date: m['date'] != null ? DateTime.parse(m['date']) : DateTime.now(),
            createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<Meal>().toList();
      return MealState(meals: meals);
    }
    return const MealState();
  }

  Future<void> addMeal(Meal meal) async {
    state = const AsyncValue.loading();
    try {
      final currentMeals = state.value?.meals ?? [];
      final newMeals = [...currentMeals, meal];
      
      await _mealBox.put('meals', newMeals.map((m) => {
        'id': m.id,
        'userId': m.userId,
        'name': m.name,
        'mealType': m.mealType,
        'calories': m.calories,
        'notes': m.notes,
        'date': m.date.toIso8601String(),
        'createdAt': m.createdAt.toIso8601String(),
      }).toList());

      state = AsyncValue.data(MealState(meals: newMeals));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> deleteMeal(String id) async {
    final currentMeals = state.value?.meals ?? [];
    final newMeals = currentMeals.where((m) => m.id != id).toList();
    
    await _mealBox.put('meals', newMeals.map((m) => {
      'id': m.id,
      'userId': m.userId,
      'name': m.name,
      'mealType': m.mealType,
      'calories': m.calories,
      'notes': m.notes,
      'date': m.date.toIso8601String(),
      'createdAt': m.createdAt.toIso8601String(),
    }).toList());

    state = AsyncValue.data(MealState(meals: newMeals));
  }
}

final mealProvider = AsyncNotifierProvider<MealNotifier, MealState>(() {
  return MealNotifier();
});
