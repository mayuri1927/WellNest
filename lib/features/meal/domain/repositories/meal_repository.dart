abstract class MealRepository {
  Future<List<Map<String, dynamic>>> getMeals();
  Future<void> addMeal(Map<String, dynamic> meal);
  Future<void> deleteMeal(String id);
}
