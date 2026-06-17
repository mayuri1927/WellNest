import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool hasSeenOnboarding;
  final String? error;
  final String? userId;
  final String? userName;
  final String? userEmail;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.hasSeenOnboarding = false,
    this.error,
    this.userId,
    this.userName,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? hasSeenOnboarding,
    String? error,
    String? userId,
    String? userName,
    String? userEmail,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      error: error,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  late Box _authBox;

  @override
  Future<AuthState> build() async {
    _authBox = Hive.box('auth');
    final hasSeenOnboarding = _authBox.get('hasSeenOnboarding', defaultValue: false);
    final userId = _authBox.get('userId');
    final userName = _authBox.get('userName');
    final userEmail = _authBox.get('userEmail');
    
    return AuthState(
      hasSeenOnboarding: hasSeenOnboarding ?? false,
      isAuthenticated: userId != null,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.login(email, password);
      
      final user = await repository.getCurrentUser();
      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        hasSeenOnboarding: true,
        userId: user?['userId'],
        userName: user?['userName'],
        userEmail: user?['userEmail'],
      ));
    } catch (e) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), StackTrace.current);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(name, email, password);
      
      final user = await repository.getCurrentUser();
      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        hasSeenOnboarding: true,
        userId: user?['userId'],
        userName: user?['userName'],
        userEmail: user?['userEmail'],
      ));
    } catch (e) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), StackTrace.current);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.resetPassword(email);
      state = const AsyncValue.data(AuthState(hasSeenOnboarding: true));
    } catch (e) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AsyncValue.data(AuthState(hasSeenOnboarding: true));
    } catch (e) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), StackTrace.current);
    }
  }

  void setOnboardingComplete() {
    _authBox.put('hasSeenOnboarding', true);
    state = AsyncValue.data(state.value!.copyWith(hasSeenOnboarding: true));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
