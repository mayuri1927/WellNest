import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class MedicineRemoteDatasource {
  Future<List<Map<String, dynamic>>> getMedicines();
  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> medicine);
  Future<void> deleteMedicine(String id);
  Future<void> markMedicineTaken(String id, Map<String, dynamic> data);
}

class MedicineRemoteDatasourceImpl implements MedicineRemoteDatasource {
  final ApiClient _apiClient;

  MedicineRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getMedicines() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.medicines);
      return List<dynamic>.from(response.data).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> medicine) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.medicines, data: medicine);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteMedicine(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.medicines}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> markMedicineTaken(String id, Map<String, dynamic> data) async {
    try {
      await _apiClient.post('${ApiEndpoints.medicines}/$id/mark-taken', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
        return Exception('Connection timeout.');
      case DioExceptionType.connectionError:
        return Exception('Unable to connect to server.');
      default:
        return Exception('Something went wrong.');
    }
  }
}

final medicineRemoteDatasourceProvider = Provider<MedicineRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MedicineRemoteDatasourceImpl(apiClient);
});
