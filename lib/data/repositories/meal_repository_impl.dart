import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/meal_model.dart';
import '../../core/utils/date_time_utils.dart';

class MealRepositoryImpl implements MealRepository {
  final MealDataSource _mealDataSource;

  MealRepositoryImpl({required MealDataSource mealDataSource})
      : _mealDataSource = mealDataSource;

  @override
  Future<void> addMeal(MealEntity meal) async {
    final model = MealModel.fromEntity(meal);
    await _mealDataSource.addMeal(model);
  }

  @override
  Future<void> updateMeal(MealEntity meal) async {
    final model = MealModel.fromEntity(meal);
    await _mealDataSource.updateMeal(meal.id, model);
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _mealDataSource.deleteMeal(id);
  }

  @override
  Future<List<MealEntity>> getMeals(String userId) async {
    final models = await _mealDataSource.getMeals(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<MealEntity>> streamMeals(String userId) {
    return _mealDataSource.streamMeals(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<MealEntity>> getMealsByDate(String userId, DateTime date) async {
    final allMeals = await getMeals(userId);
    return allMeals
        .where((m) => DateTimeUtils.isSameDay(m.dateTime, date))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getMealStats(
      String userId, DateTime startDate, DateTime endDate) async {
    final allMeals = await getMeals(userId);
    final filteredMeals = allMeals.where((m) =>
        m.dateTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
        m.dateTime.isBefore(endDate.add(const Duration(days: 1))));

    final totalCalories =
        filteredMeals.fold<int>(0, (sum, m) => sum + m.calories);
    final totalProtein =
        filteredMeals.fold<double>(0, (sum, m) => sum + m.protein);
    final totalCarbs =
        filteredMeals.fold<double>(0, (sum, m) => sum + m.carbs);
    final totalFat =
        filteredMeals.fold<double>(0, (sum, m) => sum + m.fat);

    final mealTypes = <String, int>{};
    for (final meal in filteredMeals) {
      mealTypes[meal.type] = (mealTypes[meal.type] ?? 0) + 1;
    }

    return {
      'totalMeals': filteredMeals.length,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'mealTypes': mealTypes,
    };
  }
}
