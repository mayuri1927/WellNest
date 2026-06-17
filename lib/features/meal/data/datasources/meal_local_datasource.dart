import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class MealLocalDatasource {
  Future<List<Map<String, dynamic>>> getMeals();
  Future<void> saveMeal(Map<String, dynamic> meal);
  Future<void> deleteMeal(String id);
}

class MealLocalDatasourceImpl implements MealLocalDatasource {
  late Box _box;

  MealLocalDatasourceImpl() {
    _box = Hive.box('meals');
  }

  @override
  Future<List<Map<String, dynamic>>> getMeals() async {
    final data = _box.get('meals', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveMeal(Map<String, dynamic> meal) async {
    final meals = await getMeals();
    meals.add(meal);
    await _box.put('meals', meals);
  }

  @override
  Future<void> deleteMeal(String id) async {
    final meals = await getMeals();
    meals.removeWhere((m) => m['id'] == id);
    await _box.put('meals', meals);
  }
}

final mealLocalDatasourceProvider = Provider<MealLocalDatasource>((ref) {
  return MealLocalDatasourceImpl();
});
