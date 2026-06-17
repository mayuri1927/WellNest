import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class FamilyRemoteDatasource {
  Future<List<Map<String, dynamic>>> getFamilyMembers();
  Future<Map<String, dynamic>> createFamilyMember(Map<String, dynamic> member);
  Future<void> deleteFamilyMember(String id);
}

class FamilyRemoteDatasourceImpl implements FamilyRemoteDatasource {
  final ApiClient _apiClient;

  FamilyRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getFamilyMembers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.family);
      return List<dynamic>.from(response.data).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createFamilyMember(Map<String, dynamic> member) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.family, data: member);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteFamilyMember(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.family}/$id');
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

final familyRemoteDatasourceProvider = Provider<FamilyRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FamilyRemoteDatasourceImpl(apiClient);
});
