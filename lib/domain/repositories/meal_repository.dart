import '../../domain/entities/meal_entity.dart';

abstract class MealRepository {
  Future<void> addMeal(MealEntity meal);
  Future<void> updateMeal(MealEntity meal);
  Future<void> deleteMeal(String id);
  Future<List<MealEntity>> getMeals(String userId);
  Stream<List<MealEntity>> streamMeals(String userId);
  Future<List<MealEntity>> getMealsByDate(String userId, DateTime date);
  Future<Map<String, dynamic>> getMealStats(String userId, DateTime startDate, DateTime endDate);
}
