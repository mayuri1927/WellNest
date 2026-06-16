import '../../domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);
  Future<void> updateProfile({String? displayName, String? photoUrl});
  Stream<UserEntity?> authStateChanges();
  bool get isAuthenticated;
}
