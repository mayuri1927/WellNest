import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_datasource.dart';
import '../datasources/meal_remote_datasource.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDatasource _remoteDatasource;
  final MealLocalDatasource _localDatasource;

  MealRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getMeals() async {
    try {
      return await _remoteDatasource.getMeals();
    } catch (e) {
      return await _localDatasource.getMeals();
    }
  }

  @override
  Future<void> addMeal(Map<String, dynamic> meal) async {
    try {
      await _remoteDatasource.createMeal(meal);
    } catch (e) {
      await _localDatasource.saveMeal(meal);
      rethrow;
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      await _remoteDatasource.deleteMeal(id);
    } catch (e) {
      await _localDatasource.deleteMeal(id);
      rethrow;
    }
  }
}

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final remoteDatasource = ref.watch(mealRemoteDatasourceProvider);
  final localDatasource = ref.watch(mealLocalDatasourceProvider);
  return MealRepositoryImpl(remoteDatasource, localDatasource);
});
