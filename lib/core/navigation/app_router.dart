import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:well_nest/presentation/screens/auth/login_screen.dart';
import 'package:well_nest/presentation/screens/auth/signup_screen.dart';
import 'package:well_nest/presentation/screens/auth/forgot_password_screen.dart';
import 'package:well_nest/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:well_nest/presentation/screens/workout/workout_list_screen.dart';
import 'package:well_nest/presentation/screens/workout/add_workout_screen.dart';
import 'package:well_nest/presentation/screens/meal/meal_list_screen.dart';
import 'package:well_nest/presentation/screens/meal/add_meal_screen.dart';
import 'package:well_nest/presentation/screens/medicine/medicine_list_screen.dart';
import 'package:well_nest/presentation/screens/medicine/add_medicine_screen.dart';
import 'package:well_nest/presentation/screens/appointment/appointment_list_screen.dart';
import 'package:well_nest/presentation/screens/appointment/add_appointment_screen.dart';
import 'package:well_nest/presentation/screens/document/document_list_screen.dart';
import 'package:well_nest/presentation/screens/document/add_document_screen.dart';
import 'package:well_nest/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/workouts',
            builder: (context, state) => const WorkoutListScreen(),
          ),
          GoRoute(
            path: '/workouts/add',
            builder: (context, state) => const AddWorkoutScreen(),
          ),
          GoRoute(
            path: '/meals',
            builder: (context, state) => const MealListScreen(),
          ),
          GoRoute(
            path: '/meals/add',
            builder: (context, state) => const AddMealScreen(),
          ),
          GoRoute(
            path: '/medicines',
            builder: (context, state) => const MedicineListScreen(),
          ),
          GoRoute(
            path: '/medicines/add',
            builder: (context, state) => const AddMedicineScreen(),
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentListScreen(),
          ),
          GoRoute(
            path: '/appointments/add',
            builder: (context, state) => const AddAppointmentScreen(),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentListScreen(),
          ),
          GoRoute(
            path: '/documents/add',
            builder: (context, state) => const AddDocumentScreen(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _shouldShowBottomNav(context)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center),
                  label: 'Workout',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant),
                  label: 'Meal',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medication),
                  label: 'Medicine',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Appt',
                ),
              ],
            )
          : null,
    );
  }

  bool _shouldShowBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return location != '/login' &&
        location != '/signup' &&
        location != '/forgot-password' &&
        !location.contains('/add');
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/workout')) return 1;
    if (location.startsWith('/meal')) return 2;
    if (location.startsWith('/medicine')) return 3;
    if (location.startsWith('/appointment')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/workouts');
        break;
      case 2:
        context.go('/meals');
        break;
      case 3:
        context.go('/medicines');
        break;
      case 4:
        context.go('/appointments');
        break;
    }
  }
}
