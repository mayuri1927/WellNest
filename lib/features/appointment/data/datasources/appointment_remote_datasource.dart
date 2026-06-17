import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class AppointmentRemoteDatasource {
  Future<List<Map<String, dynamic>>> getAppointments();
  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> appointment);
  Future<void> deleteAppointment(String id);
}

class AppointmentRemoteDatasourceImpl implements AppointmentRemoteDatasource {
  final ApiClient _apiClient;

  AppointmentRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.appointments);
      return List<dynamic>.from(response.data).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> appointment) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.appointments, data: appointment);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.appointments}/$id');
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

final appointmentRemoteDatasourceProvider = Provider<AppointmentRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AppointmentRemoteDatasourceImpl(apiClient);
});
