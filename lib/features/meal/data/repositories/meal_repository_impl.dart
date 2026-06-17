import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_datasource.dart';

class MealRepositoryImpl implements MealRepository {
  final MealLocalDatasource _datasource;

  MealRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getMeals() async {
    return await _datasource.getMeals();
  }

  @override
  Future<void> addMeal(Map<String, dynamic> meal) async {
    await _datasource.saveMeal(meal);
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _datasource.deleteMeal(id);
  }
}
