import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/enums/app_enums.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../providers/health_profile_provider.dart';
import '../../../meal/presentation/providers/meal_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';

class ProgressTrackingScreen extends ConsumerStatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  ConsumerState<ProgressTrackingScreen> createState() =>
      _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState
    extends ConsumerState<ProgressTrackingScreen> {
  bool _workoutCompleted = false;
  bool _dietFollowed = false;
  int _waterGlasses = 0;
  double? _currentWeight;
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthState = ref.watch(healthProfileProvider);
    final mealState = ref.watch(mealProvider);
    final workoutState = ref.watch(workoutProvider);

    final profile = healthState.valueOrNull?.profile;
    final recommendedCalories =
        healthState.valueOrNull?.recommendedCalories ?? 2000;

    final todaysMeals = mealState.valueOrNull?.meals ?? [];
    final todaysWorkouts = workoutState.valueOrNull?.workouts ?? [];

    double caloriesConsumed = 0;
    for (var meal in todaysMeals) {
      caloriesConsumed += (meal.calories ?? 0);
    }

    double caloriesBurned = 0;
    for (var workout in todaysWorkouts) {
      caloriesBurned += (workout.caloriesBurned ?? 0);
    }

    final calorieDifference =
        caloriesConsumed - caloriesBurned - recommendedCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile != null) ...[
              _HealthProfileCard(profile: profile),
              const SizedBox(height: Spacing.lg),
            ],
            _GoalProgressSection(
              profile: profile,
              calorieDifference: calorieDifference,
              caloriesConsumed: caloriesConsumed,
              caloriesBurned: caloriesBurned,
              recommendedCalories: recommendedCalories,
            ),
            const SizedBox(height: Spacing.lg),
            _DailyChecklistSection(
              workoutCompleted: _workoutCompleted,
              dietFollowed: _dietFollowed,
              waterGlasses: _waterGlasses,
              onWorkoutChanged: (value) =>
                  setState(() => _workoutCompleted = value ?? false),
              onDietChanged: (value) =>
                  setState(() => _dietFollowed = value ?? false),
              onWaterChanged: (value) =>
                  setState(() => _waterGlasses = value ?? 0),
            ),
            const SizedBox(height: Spacing.lg),
            _WeightTrackingSection(
              profile: profile,
              currentWeight: _currentWeight,
              weightController: _weightController,
              onWeightSaved: () {
                setState(() {
                  _currentWeight = double.tryParse(_weightController.text);
                });
              },
            ),
            const SizedBox(height: Spacing.lg),
            if (profile != null) ...[
              _DietSuggestionsSection(profile: profile),
              const SizedBox(height: Spacing.lg),
              _WorkoutSuggestionsSection(profile: profile),
            ],
            const SizedBox(height: Spacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _HealthProfileCard extends StatelessWidget {
  final dynamic profile;

  const _HealthProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Health Profile',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profile.healthGoal.label,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          const Divider(),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _ProfileMetric(
                  label: 'Height',
                  value: '${profile.height.toStringAsFixed(0)} cm',
                  icon: Icons.height,
                ),
              ),
              Expanded(
                child: _ProfileMetric(
                  label: 'Weight',
                  value: '${profile.weight.toStringAsFixed(1)} kg',
                  icon: Icons.monitor_weight_outlined,
                ),
              ),
              Expanded(
                child: _ProfileMetric(
                  label: 'Age',
                  value: '${profile.age}',
                  icon: Icons.cake_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _ProfileMetric(
                  label: 'BMI',
                  value: profile.bmi?.toStringAsFixed(1) ?? '-',
                  icon: Icons.analytics_outlined,
                ),
              ),
              Expanded(
                child: _ProfileMetric(
                  label: 'BMR',
                  value: profile.bmr?.toStringAsFixed(0) ?? '-',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
              Expanded(
                child: _ProfileMetric(
                  label: 'Target',
                  value: profile.targetWeight != null
                      ? '${profile.targetWeight?.toStringAsFixed(1)} kg'
                      : '-',
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _GoalProgressSection extends StatelessWidget {
  final dynamic profile;
  final double calorieDifference;
  final double caloriesConsumed;
  final double caloriesBurned;
  final int recommendedCalories;

  const _GoalProgressSection({
    required this.profile,
    required this.calorieDifference,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.recommendedCalories,
  });

  @override
  Widget build(BuildContext context) {
    double? weightToLose;
    double? weightToGain;

    if (profile?.healthGoal == HealthGoal.loseWeight &&
        profile?.targetWeight != null) {
      weightToLose =
          (profile.weight as double) - (profile.targetWeight as double);
    } else if (profile?.healthGoal == HealthGoal.gainWeight &&
        profile?.targetWeight != null) {
      weightToGain =
          (profile.targetWeight as double) - (profile.weight as double);
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Progress',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _ProgressMetric(
                  label: 'Calories In',
                  value: caloriesConsumed.toStringAsFixed(0),
                  target: recommendedCalories.toString(),
                  unit: 'kcal',
                  color: AppColors.secondary,
                  isPositive: false,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _ProgressMetric(
                  label: 'Calories Out',
                  value: caloriesBurned.toStringAsFixed(0),
                  target: '500',
                  unit: 'kcal',
                  color: AppColors.primary,
                  isPositive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: calorieDifference > 0
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  calorieDifference > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: calorieDifference > 0
                      ? AppColors.error
                      : AppColors.success,
                ),
                const SizedBox(width: 8),
                Text(
                  calorieDifference > 0
                      ? '${calorieDifference.toStringAsFixed(0)} kcal surplus'
                      : '${(-calorieDifference).toStringAsFixed(0)} kcal deficit',
                  style: TextStyle(
                    color: calorieDifference > 0
                        ? AppColors.error
                        : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (weightToLose != null || weightToGain != null) ...[
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Row(
                children: [
                  Icon(
                    weightToLose != null
                        ? Icons.trending_down
                        : Icons.trending_up,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      weightToLose != null
                          ? '${weightToLose.toStringAsFixed(1)} kg to lose'
                          : '${weightToGain?.toStringAsFixed(1)} kg to gain',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final String value;
  final String target;
  final String unit;
  final Color color;
  final bool isPositive;

  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.target,
    required this.unit,
    required this.color,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Target: $target $unit',
            style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _DailyChecklistSection extends StatelessWidget {
  final bool workoutCompleted;
  final bool dietFollowed;
  final int waterGlasses;
  final ValueChanged<bool?> onWorkoutChanged;
  final ValueChanged<bool?> onDietChanged;
  final ValueChanged<int?> onWaterChanged;

  const _DailyChecklistSection({
    required this.workoutCompleted,
    required this.dietFollowed,
    required this.waterGlasses,
    required this.onWorkoutChanged,
    required this.onDietChanged,
    required this.onWaterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Checklist',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          CheckboxListTile(
            value: workoutCompleted,
            onChanged: onWorkoutChanged,
            title: const Text('Workout Completed'),
            subtitle: const Text('Followed your exercise plan'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: const Icon(Icons.fitness_center, color: AppColors.primary),
            ),
            activeColor: AppColors.primary,
            checkColor: Colors.white,
          ),
          const Divider(),
          CheckboxListTile(
            value: dietFollowed,
            onChanged: onDietChanged,
            title: const Text('Diet Plan Followed'),
            subtitle: const Text('Stayed within calorie target'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: const Icon(Icons.restaurant, color: AppColors.secondary),
            ),
            activeColor: AppColors.secondary,
            checkColor: Colors.white,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                  child: const Icon(Icons.water_drop, color: AppColors.info),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Water Intake'),
                      const Text(
                        'Glasses of water today',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onWaterChanged(
                        waterGlasses > 0 ? waterGlasses - 1 : 0,
                      ),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.info,
                    ),
                    Text(
                      '$waterGlasses',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onWaterChanged(waterGlasses + 1),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.info,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightTrackingSection extends StatelessWidget {
  final dynamic profile;
  final double? currentWeight;
  final TextEditingController weightController;
  final VoidCallback onWeightSaved;

  const _WeightTrackingSection({
    required this.profile,
    required this.currentWeight,
    required this.weightController,
    required this.onWeightSaved,
  });

  @override
  Widget build(BuildContext context) {
    double? diff;
    if (currentWeight != null && profile?.weight != null) {
      diff = currentWeight! - (profile?.weight as double);
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Update',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: weightController,
                  hint: 'Enter current weight',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  suffixIcon: const Text('kg'),
                ),
              ),
              const SizedBox(width: Spacing.md),
              PrimaryButton(text: 'Update', onPressed: onWeightSaved),
            ],
          ),
          if (diff != null) ...[
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: diff > 0
                    ? AppColors.warning.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    diff > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: diff > 0 ? AppColors.warning : AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg from starting weight',
                    style: TextStyle(
                      color: diff > 0 ? AppColors.warning : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DietSuggestionsSection extends StatelessWidget {
  final dynamic profile;

  const _DietSuggestionsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final goal = profile?.healthGoal;
    final calories = profile?.dailyCalorieTarget ?? 2000;

    List<Map<String, String>> suggestions = [];

    if (goal == HealthGoal.loseWeight) {
      suggestions = [
        {'meal': 'Breakfast', 'suggestion': 'Oatmeal with berries (350 kcal)'},
        {'meal': 'Lunch', 'suggestion': 'Grilled chicken salad (450 kcal)'},
        {'meal': 'Snack', 'suggestion': 'Greek yogurt with almonds (200 kcal)'},
        {
          'meal': 'Dinner',
          'suggestion': 'Baked salmon with veggies (400 kcal)',
        },
        {'meal': 'Total', 'suggestion': '$calories kcal target per day'},
      ];
    } else if (goal == HealthGoal.gainWeight) {
      suggestions = [
        {
          'meal': 'Breakfast',
          'suggestion': 'Protein smoothie with banana (500 kcal)',
        },
        {
          'meal': 'Lunch',
          'suggestion': 'Rice bowl with beef and vegetables (650 kcal)',
        },
        {'meal': 'Snack', 'suggestion': 'Peanut butter sandwich (350 kcal)'},
        {'meal': 'Dinner', 'suggestion': 'Pasta with chicken (600 kcal)'},
        {'meal': 'Total', 'suggestion': '$calories kcal target per day'},
      ];
    } else {
      suggestions = [
        {'meal': 'Breakfast', 'suggestion': 'Eggs with toast (400 kcal)'},
        {'meal': 'Lunch', 'suggestion': 'Balanced meal with grains (500 kcal)'},
        {'meal': 'Snack', 'suggestion': 'Fruits and nuts (200 kcal)'},
        {
          'meal': 'Dinner',
          'suggestion': 'Light dinner with proteins (450 kcal)',
        },
        {'meal': 'Total', 'suggestion': '$calories kcal target per day'},
      ];
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.secondary),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                'Diet Plan Suggestions',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...suggestions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      item['meal']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['suggestion']!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSuggestionsSection extends StatelessWidget {
  final dynamic profile;

  const _WorkoutSuggestionsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final goal = profile?.healthGoal;

    List<Map<String, String>> workouts = [];

    if (goal == HealthGoal.loseWeight) {
      workouts = [
        {'type': 'Cardio', 'duration': '30 min', 'calories': '300 kcal'},
        {'type': 'HIIT', 'duration': '20 min', 'calories': '250 kcal'},
        {'type': 'Light Jogging', 'duration': '25 min', 'calories': '200 kcal'},
        {'type': 'Daily Goal', 'duration': '75 min', 'calories': '750 kcal'},
      ];
    } else if (goal == HealthGoal.gainWeight) {
      workouts = [
        {
          'type': 'Weight Training',
          'duration': '45 min',
          'calories': '300 kcal',
        },
        {
          'type': 'Squats & Lunges',
          'duration': '30 min',
          'calories': '200 kcal',
        },
        {'type': 'Upper Body', 'duration': '35 min', 'calories': '250 kcal'},
        {'type': 'Daily Goal', 'duration': '110 min', 'calories': '750 kcal'},
      ];
    } else {
      workouts = [
        {'type': 'Brisk Walk', 'duration': '30 min', 'calories': '150 kcal'},
        {'type': 'Light Yoga', 'duration': '20 min', 'calories': '100 kcal'},
        {'type': 'Stretching', 'duration': '15 min', 'calories': '50 kcal'},
        {'type': 'Daily Goal', 'duration': '65 min', 'calories': '300 kcal'},
      ];
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                'Workout Suggestions',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...workouts.map(
            (workout) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: workout['type'] == 'Daily Goal'
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      workout['type']!,
                      style: TextStyle(
                        fontWeight: workout['type'] == 'Daily Goal'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    workout['duration']!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: Spacing.md),
                  Text(
                    workout['calories']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
