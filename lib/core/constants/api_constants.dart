import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    if (kDebugMode) {
      return 'http://localhost:3000/api/v1';
    }
    return 'https://wellnest-api.up.railway.app/api/v1';
  }
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/auth/profile';
  static const String changePassword = '/auth/change-password';

  // Users
  static const String usersMe = '/users/me';

  // Workouts
  static const String workouts = '/workouts';
  static const String workoutAnalytics = '/workouts/analytics';

  // Meals
  static const String meals = '/meals';
  static const String nutritionSummary = '/meals/nutrition-summary';

  // Family
  static const String family = '/family';

  // Medicines
  static const String medicines = '/medicines';
  static const String medicineAdherenceStats = '/medicines/adherence-stats';

  // Appointments
  static const String appointments = '/appointments';
  static const String upcomingAppointments = '/appointments/upcoming';

  // Documents
  static const String documents = '/documents';
  static const String documentStats = '/documents/stats';
}
