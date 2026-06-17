import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        state = AsyncValue.error('Please fill in all fields', StackTrace.current);
        return;
      }

      // Store user data
      await _authBox.put('userId', 'user_${DateTime.now().millisecondsSinceEpoch}');
      await _authBox.put('userName', email.split('@').first);
      await _authBox.put('userEmail', email);

      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        hasSeenOnboarding: true,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        userName: email.split('@').first,
        userEmail: email,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        state = AsyncValue.error('Please fill in all fields', StackTrace.current);
        return;
      }

      await _authBox.put('userId', 'user_${DateTime.now().millisecondsSinceEpoch}');
      await _authBox.put('userName', name);
      await _authBox.put('userEmail', email);

      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        hasSeenOnboarding: true,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        userName: name,
        userEmail: email,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isEmpty) {
        state = AsyncValue.error('Please enter your email', StackTrace.current);
        return;
      }

      state = const AsyncValue.data(AuthState(hasSeenOnboarding: true));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> logout() async {
    await _authBox.clear();
    state = const AsyncValue.data(AuthState(hasSeenOnboarding: true));
  }

  void setOnboardingComplete() {
    _authBox.put('hasSeenOnboarding', true);
    state = AsyncValue.data(state.value!.copyWith(hasSeenOnboarding: true));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
