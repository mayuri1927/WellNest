import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../meal/presentation/providers/meal_provider.dart';
import '../../../medicine/presentation/providers/medicine_provider.dart';
import '../../../appointment/presentation/providers/appointment_provider.dart';
import '../../../health_profile/presentation/providers/health_profile_provider.dart';
import '../../../../shared/enums/app_enums.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final workoutState = ref.watch(workoutProvider);
    final mealState = ref.watch(mealProvider);
    final medicineState = ref.watch(medicineProvider);
    final appointmentState = ref.watch(appointmentProvider);
    final healthState = ref.watch(healthProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${authState.value?.userName ?? 'User'} 👋',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              AppStrings.appTagline,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.progressTracking),
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Progress Tracking',
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workoutProvider);
          ref.invalidate(mealProvider);
          ref.invalidate(medicineProvider);
          ref.invalidate(appointmentProvider);
          ref.invalidate(healthProfileProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.md),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HealthSummarySection(healthState: healthState),
              const SizedBox(height: Spacing.lg),
              const SectionHeader(title: 'Quick Actions', icon: Icons.bolt),
              _QuickActionsGrid(),
              const SizedBox(height: Spacing.lg),
              SectionHeader(
                title: AppStrings.upcomingAppointments,
                icon: Icons.calendar_today,
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.appointments),
              ),
              _AppointmentsPreview(
                appointments: appointmentState.value?.appointments ?? [],
              ),
              const SizedBox(height: Spacing.lg),
              SectionHeader(
                title: AppStrings.todaysMedicines,
                icon: Icons.medication,
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.medicines),
              ),
              _MedicinesPreview(
                medicines: medicineState.value?.medicines ?? [],
              ),
              const SizedBox(height: Spacing.lg),
              SectionHeader(
                title: AppStrings.workout,
                icon: Icons.fitness_center,
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.workout),
              ),
              _WorkoutsPreview(workouts: workoutState.value?.workouts ?? []),
              const SizedBox(height: Spacing.lg),
              SectionHeader(
                title: AppStrings.meals,
                icon: Icons.restaurant,
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.meals),
              ),
              _MealsPreview(meals: mealState.value?.meals ?? []),
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthSummarySection extends StatelessWidget {
  final AsyncValue healthState;

  const _HealthSummarySection({required this.healthState});

  @override
  Widget build(BuildContext context) {
    final profile = healthState.valueOrNull?.profile;
    final recommendedCalories =
        healthState.valueOrNull?.recommendedCalories ?? 2000;
    final bmi = healthState.valueOrNull?.calculatedBmi;
    final goal = profile?.healthGoal;

    String goalLabel = 'Not set';
    Color goalColor = Colors.white70;
    if (goal != null) {
      goalLabel = goal.label;
      goalColor = goal == HealthGoal.loseWeight
          ? Colors.orange
          : goal == HealthGoal.gainWeight
          ? Colors.blue
          : Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Goal',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    goalLabel,
                    style: TextStyle(
                      color: goalColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$recommendedCalories kcal',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (profile != null) ...[
            Row(
              children: [
                Expanded(
                  child: _HealthMetric(
                    label: 'Height',
                    value: '${profile.height.toStringAsFixed(0)} cm',
                    icon: Icons.height,
                  ),
                ),
                Expanded(
                  child: _HealthMetric(
                    label: 'Weight',
                    value: '${profile.weight.toStringAsFixed(1)} kg',
                    icon: Icons.monitor_weight_outlined,
                  ),
                ),
                Expanded(
                  child: _HealthMetric(
                    label: 'BMI',
                    value: bmi?.toStringAsFixed(1) ?? '-',
                    icon: Icons.analytics_outlined,
                  ),
                ),
              ],
            ),
            if (profile.targetWeight != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Target: ${profile.targetWeight?.toStringAsFixed(1)} kg',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            const Text(
              'Set up your health profile to get personalized goals',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push(AppRoutes.healthProfileSetup),
              child: const Text(
                'Set Up Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Spacing.md,
      crossAxisSpacing: Spacing.md,
      children: [
        _QuickActionItem(
          icon: Icons.add,
          label: 'Workout',
          color: AppColors.primary,
          onTap: () => context.push(AppRoutes.workoutAdd),
        ),
        _QuickActionItem(
          icon: Icons.add,
          label: 'Meal',
          color: AppColors.secondary,
          onTap: () => context.push(AppRoutes.mealsAdd),
        ),
        _QuickActionItem(
          icon: Icons.add,
          label: 'Medicine',
          color: AppColors.warning,
          onTap: () => context.push(AppRoutes.medicinesAdd),
        ),
        _QuickActionItem(
          icon: Icons.add,
          label: 'Appt',
          color: AppColors.info,
          onTap: () => context.push(AppRoutes.appointmentsAdd),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsPreview extends StatelessWidget {
  final List<dynamic> appointments;

  const _AppointmentsPreview({required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const CustomCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.lg),
            child: Text('No upcoming appointments'),
          ),
        ),
      );
    }

    return Column(
      children: appointments.take(2).map((apt) {
        return CustomCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: const Icon(Icons.calendar_today, color: AppColors.info),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apt.doctorName ?? 'Doctor Appointment',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      apt.specialty ?? 'General',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    apt.dateTime != null
                        ? '${apt.dateTime!.day}/${apt.dateTime!.month}'
                        : '--',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    apt.dateTime != null
                        ? '${apt.dateTime!.hour}:${apt.dateTime!.minute.toString().padLeft(2, '0')}'
                        : '--',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MedicinesPreview extends StatelessWidget {
  final List<dynamic> medicines;

  const _MedicinesPreview({required this.medicines});

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const CustomCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.lg),
            child: Text('No medicines added'),
          ),
        ),
      );
    }

    return Column(
      children: medicines.take(2).map((med) {
        return CustomCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: const Icon(Icons.medication, color: AppColors.warning),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name ?? 'Medicine',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${med.dosage ?? 0} ${med.unit ?? 'mg'}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: med.isActive == true
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  med.isActive == true ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: med.isActive == true
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _WorkoutsPreview extends StatelessWidget {
  final List<dynamic> workouts;

  const _WorkoutsPreview({required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const CustomCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.lg),
            child: Text('No workouts logged'),
          ),
        ),
      );
    }

    return Column(
      children: workouts.take(2).map((workout) {
        return CustomCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.type ?? 'Workout',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${workout.duration ?? 0} min • ${workout.caloriesBurned ?? 0} cal',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MealsPreview extends StatelessWidget {
  final List<dynamic> meals;

  const _MealsPreview({required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const CustomCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.lg),
            child: Text('No meals logged'),
          ),
        ),
      );
    }

    return Column(
      children: meals.take(2).map((meal) {
        return CustomCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.secondary),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name ?? 'Meal',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${meal.mealType ?? 'Snack'} • ${meal.calories ?? 0} cal',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
