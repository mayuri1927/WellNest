import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._localDatasource);

  @override
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    await _localDatasource.saveUser(userId, email.split('@').first, email);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    await _localDatasource.saveUser(userId, name, email);
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    await _localDatasource.clearUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await _localDatasource.getUser();
    return user != null;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _localDatasource.getUser();
  }
}
