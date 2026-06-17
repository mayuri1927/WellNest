import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final Box _authBox = Hive.box('auth');

  AuthRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<void> login(String email, String password) async {
    final response = await _remoteDatasource.login(email, password);
    final user = response['user'];
    final accessToken = response['accessToken'];
    final refreshToken = response['refreshToken'];

    await _authBox.put('userId', user['id']);
    await _authBox.put('userName', user['name']);
    await _authBox.put('userEmail', user['email']);
    await _authBox.put('accessToken', accessToken);
    await _authBox.put('refreshToken', refreshToken);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    final response = await _remoteDatasource.register(name, email, password);
    final user = response['user'];
    final accessToken = response['accessToken'];
    final refreshToken = response['refreshToken'];

    await _authBox.put('userId', user['id']);
    await _authBox.put('userName', user['name']);
    await _authBox.put('userEmail', user['email']);
    await _authBox.put('accessToken', accessToken);
    await _authBox.put('refreshToken', refreshToken);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _remoteDatasource.forgotPassword(email);
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDatasource.logout();
    } catch (_) {}
    await _authBox.clear();
  }

  @override
  Future<bool> isLoggedIn() async {
    final userId = _authBox.get('userId');
    final accessToken = _authBox.get('accessToken');
    return userId != null && accessToken != null;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userId = _authBox.get('userId');
    if (userId == null) return null;

    return {
      'userId': userId,
      'userName': _authBox.get('userName'),
      'userEmail': _authBox.get('userEmail'),
    };
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(remoteDatasource, localDatasource);
});
