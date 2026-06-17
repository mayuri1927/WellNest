import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class WorkoutRemoteDatasource {
  Future<List<Map<String, dynamic>>> getWorkouts();
  Future<Map<String, dynamic>> createWorkout(Map<String, dynamic> workout);
  Future<void> deleteWorkout(String id);
  Future<Map<String, dynamic>> getAnalytics();
}

class WorkoutRemoteDatasourceImpl implements WorkoutRemoteDatasource {
  final ApiClient _apiClient;

  WorkoutRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.workouts);
      final List<dynamic> data = response.data;
      return data.map((w) => _mapBackendToFlutter(w)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createWorkout(Map<String, dynamic> workout) async {
    try {
      final backendData = _mapFlutterToBackend(workout);
      final response = await _apiClient.post(ApiEndpoints.workouts, data: backendData);
      return _mapBackendToFlutter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.workouts}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.workoutAnalytics);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _mapFlutterToBackend(Map<String, dynamic> workout) {
    return {
      'title': workout['type'] ?? workout['title'] ?? 'Workout',
      'workoutType': (workout['type'] ?? 'cardio').toString().toUpperCase(),
      'duration': workout['duration'],
      'caloriesBurned': workout['caloriesBurned'],
      'notes': workout['notes'],
    };
  }

  Map<String, dynamic> _mapBackendToFlutter(Map<String, dynamic> workout) {
    return {
      'id': workout['id'],
      'userId': workout['userId'],
      'type': workout['workoutType']?.toString().toLowerCase() ?? workout['type'],
      'title': workout['title'],
      'duration': workout['duration'],
      'caloriesBurned': workout['caloriesBurned'],
      'notes': workout['notes'],
      'exercises': workout['exercises'] ?? [],
      'date': workout['createdAt'],
      'createdAt': workout['createdAt'],
      'updatedAt': workout['updatedAt'],
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

final workoutRemoteDatasourceProvider = Provider<WorkoutRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutRemoteDatasourceImpl(apiClient);
});
