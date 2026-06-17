import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/main_shell.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/workout/presentation/screens/workout_list_screen.dart';
import '../../features/workout/presentation/screens/add_workout_screen.dart';
import '../../features/meal/presentation/screens/meal_list_screen.dart';
import '../../features/meal/presentation/screens/add_meal_screen.dart';
import '../../features/family/presentation/screens/family_list_screen.dart';
import '../../features/family/presentation/screens/add_family_member_screen.dart';
import '../../features/medicine/presentation/screens/medicine_list_screen.dart';
import '../../features/medicine/presentation/screens/add_medicine_screen.dart';
import '../../features/appointment/presentation/screens/appointment_list_screen.dart';
import '../../features/appointment/presentation/screens/add_appointment_screen.dart';
import '../../features/documents/presentation/screens/document_list_screen.dart';
import '../../features/documents/presentation/screens/upload_document_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String dashboard = '/main/dashboard';
  static const String workout = '/main/workout';
  static const String workoutAdd = '/main/workout/add';
  static const String meals = '/main/meals';
  static const String mealsAdd = '/main/meals/add';
  static const String family = '/main/family';
  static const String familyAdd = '/main/family/add';
  static const String medicines = '/main/medicines';
  static const String medicinesAdd = '/main/medicines/add';
  static const String appointments = '/main/appointments';
  static const String appointmentsAdd = '/main/appointments/add';
  static const String documents = '/main/documents';
  static const String documentsUpload = '/main/documents/upload';
  static const String profile = '/main/profile';
  static const String settings = '/main/settings';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.workout,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WorkoutListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.workoutAdd,
          builder: (context, state) => const AddWorkoutScreen(),
        ),
        GoRoute(
          path: AppRoutes.meals,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MealListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.mealsAdd,
          builder: (context, state) => const AddMealScreen(),
        ),
        GoRoute(
          path: AppRoutes.family,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FamilyListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.familyAdd,
          builder: (context, state) => const AddFamilyMemberScreen(),
        ),
        GoRoute(
          path: AppRoutes.medicines,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MedicineListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.medicinesAdd,
          builder: (context, state) => const AddMedicineScreen(),
        ),
        GoRoute(
          path: AppRoutes.appointments,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AppointmentListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.appointmentsAdd,
          builder: (context, state) => const AddAppointmentScreen(),
        ),
        GoRoute(
          path: AppRoutes.documents,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DocumentListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.documentsUpload,
          builder: (context, state) => const UploadDocumentScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);
