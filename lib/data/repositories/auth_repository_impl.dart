import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  UserEntity? _currentUser;

  AuthRepositoryImpl({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Future<UserEntity?> getCurrentUser() async {
    _currentUser = await _authDataSource.getCurrentUser();
    return _currentUser;
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    _currentUser = await _authDataSource.signInWithEmail(email, password);
    return _currentUser!;
  }

  @override
  Future<UserEntity> signUpWithEmail(
      String email, String password, String displayName) async {
    _currentUser =
        await _authDataSource.signUpWithEmail(email, password, displayName);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await _authDataSource.sendPasswordReset(email);
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    await _authDataSource.updateProfile(
        displayName: displayName, photoUrl: photoUrl);
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
      );
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _authDataSource.authStateChanges().map((user) {
      if (user == null) {
        _currentUser = null;
        return null;
      }
      _currentUser = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: user.metadata.lastSignInTime,
        isEmailVerified: user.emailVerified,
      );
      return _currentUser;
    });
  }
}
