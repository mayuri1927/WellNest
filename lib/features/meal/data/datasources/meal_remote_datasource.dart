import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class MealRemoteDatasource {
  Future<List<Map<String, dynamic>>> getMeals();
  Future<Map<String, dynamic>> createMeal(Map<String, dynamic> meal);
  Future<void> deleteMeal(String id);
}

class MealRemoteDatasourceImpl implements MealRemoteDatasource {
  final ApiClient _apiClient;

  MealRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getMeals() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.meals);
      final List<dynamic> data = response.data;
      return data.map((m) => _mapBackendToFlutter(m)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createMeal(Map<String, dynamic> meal) async {
    try {
      final backendData = _mapFlutterToBackend(meal);
      final response = await _apiClient.post(ApiEndpoints.meals, data: backendData);
      return _mapBackendToFlutter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.meals}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _mapFlutterToBackend(Map<String, dynamic> meal) {
    return {
      'foodName': meal['name'] ?? meal['foodName'] ?? 'Meal',
      'mealType': (meal['type'] ?? meal['mealType'] ?? 'snack').toString().toLowerCase(),
      'calories': meal['calories'],
      'protein': meal['protein'],
      'carbs': meal['carbs'],
      'fat': meal['fat'],
      'fiber': meal['fiber'],
      'mealDate': meal['date'] ?? meal['mealDate'],
      'notes': meal['notes'],
    };
  }

  Map<String, dynamic> _mapBackendToFlutter(Map<String, dynamic> meal) {
    return {
      'id': meal['id'],
      'userId': meal['userId'],
      'name': meal['foodName'],
      'foodName': meal['foodName'],
      'type': meal['mealType'],
      'mealType': meal['mealType'],
      'calories': meal['calories'],
      'protein': meal['protein'],
      'carbs': meal['carbs'],
      'fat': meal['fat'],
      'fiber': meal['fiber'],
      'date': meal['mealDate'],
      'mealDate': meal['mealDate'],
      'notes': meal['notes'],
      'createdAt': meal['createdAt'],
      'updatedAt': meal['updatedAt'],
    };
  }

  Exception _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      final message = e.response?.data['message'];
      if (message is List) {
        return Exception(message.join(', '));
      }
      return Exception(message);
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return Exception('Unable to connect to server.');
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}

final mealRemoteDatasourceProvider = Provider<MealRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MealRemoteDatasourceImpl(apiClient);
});
