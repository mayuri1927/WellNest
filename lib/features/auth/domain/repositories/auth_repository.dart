abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<Map<String, dynamic>?> getCurrentUser();
}
