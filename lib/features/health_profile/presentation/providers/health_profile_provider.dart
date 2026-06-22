import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/app_enums.dart';
import '../../data/datasources/health_profile_local_datasource.dart';
import '../../data/models/health_profile_model.dart';

class HealthProfileState {
  final bool isLoading;
  final bool hasCompletedProfile;
  final HealthProfile? profile;
  final String? error;
  final double? calculatedBmi;
  final double? calculatedBmr;
  final int? recommendedCalories;
  final double? weightToLose;
  final double? weightToGain;

  const HealthProfileState({
    this.isLoading = false,
    this.hasCompletedProfile = false,
    this.profile,
    this.error,
    this.calculatedBmi,
    this.calculatedBmr,
    this.recommendedCalories,
    this.weightToLose,
    this.weightToGain,
  });

  HealthProfileState copyWith({
    bool? isLoading,
    bool? hasCompletedProfile,
    HealthProfile? profile,
    String? error,
    double? calculatedBmi,
    double? calculatedBmr,
    int? recommendedCalories,
    double? weightToLose,
    double? weightToGain,
  }) {
    return HealthProfileState(
      isLoading: isLoading ?? this.isLoading,
      hasCompletedProfile: hasCompletedProfile ?? this.hasCompletedProfile,
      profile: profile ?? this.profile,
      error: error,
      calculatedBmi: calculatedBmi ?? this.calculatedBmi,
      calculatedBmr: calculatedBmr ?? this.calculatedBmr,
      recommendedCalories: recommendedCalories ?? this.recommendedCalories,
      weightToLose: weightToLose ?? this.weightToLose,
      weightToGain: weightToGain ?? this.weightToGain,
    );
  }
}

class HealthProfileNotifier extends AsyncNotifier<HealthProfileState> {
  @override
  Future<HealthProfileState> build() async {
    final datasource = ref.read(healthProfileLocalDatasourceProvider);
    final hasCompleted = await datasource.hasCompletedHealthProfile();
    final profile = await datasource.getHealthProfile();

    if (profile != null) {
      final calculations = _calculateHealthMetrics(profile);
      return HealthProfileState(
        hasCompletedProfile: hasCompleted,
        profile: profile,
        calculatedBmi: calculations['bmi'],
        calculatedBmr: calculations['bmr'],
        recommendedCalories: calculations['calories'],
        weightToLose: calculations['weightToLose'],
        weightToGain: calculations['weightToGain'],
      );
    }

    return HealthProfileState(hasCompletedProfile: hasCompleted);
  }

  Map<String, dynamic> _calculateHealthMetrics(HealthProfile profile) {
    final bmi = _calculateBMI(profile.height, profile.weight);
    final bmr = _calculateBMR(
      profile.weight,
      profile.height,
      profile.age,
      profile.gender,
    );
    final calories = _calculateDailyCalories(bmr, profile.healthGoal);

    double? weightToLose;
    double? weightToGain;

    if (profile.healthGoal == HealthGoal.loseWeight &&
        profile.targetWeight != null) {
      weightToLose = profile.weight - profile.targetWeight!;
    } else if (profile.healthGoal == HealthGoal.gainWeight &&
        profile.targetWeight != null) {
      weightToGain = profile.targetWeight! - profile.weight;
    }

    return {
      'bmi': bmi,
      'bmr': bmr,
      'calories': calories,
      'weightToLose': weightToLose,
      'weightToGain': weightToGain,
    };
  }

  double _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  double _calculateBMR(
    double weightKg,
    double heightCm,
    int age,
    Gender gender,
  ) {
    if (gender == Gender.male) {
      return 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
    }
  }

  int _calculateDailyCalories(double bmr, HealthGoal goal) {
    const double activityFactor = 1.55;
    double tdee = bmr * activityFactor;

    switch (goal) {
      case HealthGoal.loseWeight:
        return (tdee - 500).round();
      case HealthGoal.gainWeight:
        return (tdee + 500).round();
      case HealthGoal.maintainWeight:
        return tdee.round();
    }
  }

  double calculateTargetWeight(
    double heightCm,
    String goal, {
    int? targetWeight,
  }) {
    double healthyWeightMin = 18.5 * (heightCm / 100) * (heightCm / 100);
    double healthyWeightMax = 24.9 * (heightCm / 100) * (heightCm / 100);

    if (goal == HealthGoal.loseWeight.value) {
      return healthyWeightMin;
    } else if (goal == HealthGoal.gainWeight.value) {
      return healthyWeightMax;
    }
    double midWeight = (healthyWeightMin + healthyWeightMax) / 2;
    return midWeight;
  }

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Future<void> saveHealthProfile({
    required String userId,
    required double height,
    required int age,
    required double weight,
    double? targetWeight,
    required Gender gender,
    required HealthGoal healthGoal,
  }) async {
    state = const AsyncValue.loading();

    try {
      final bmi = _calculateBMI(height, weight);
      final bmr = _calculateBMR(weight, height, age, gender);
      final dailyCalories = _calculateDailyCalories(bmr, healthGoal);

      final profile = HealthProfile(
        userId: userId,
        height: height,
        age: age,
        weight: weight,
        targetWeight: targetWeight,
        gender: gender,
        healthGoal: healthGoal,
        dailyCalorieTarget: dailyCalories,
        bmi: bmi,
        bmr: bmr,
        createdAt: DateTime.now(),
      );

      final datasource = ref.read(healthProfileLocalDatasourceProvider);
      await datasource.saveHealthProfile(profile);
      await datasource.setHealthProfileComplete();

      state = AsyncValue.data(
        HealthProfileState(
          hasCompletedProfile: true,
          profile: profile,
          calculatedBmi: bmi,
          calculatedBmr: bmr,
          recommendedCalories: dailyCalories,
          weightToLose:
              healthGoal == HealthGoal.loseWeight && targetWeight != null
              ? weight - targetWeight
              : null,
          weightToGain:
              healthGoal == HealthGoal.gainWeight && targetWeight != null
              ? targetWeight - weight
              : null,
        ),
      );
    } catch (e) {
      state = AsyncValue.error(
        e.toString().replaceAll('Exception: ', ''),
        StackTrace.current,
      );
    }
  }

  void updateCalculations({
    required double height,
    required int age,
    required double weight,
    required Gender gender,
    required HealthGoal healthGoal,
    double? targetWeight,
  }) {
    if (state.hasValue) {
      final currentState = state.value!;
      final bmi = _calculateBMI(height, weight);
      final bmr = _calculateBMR(weight, height, age, gender);
      final calories = _calculateDailyCalories(bmr, healthGoal);

      state = AsyncValue.data(
        currentState.copyWith(
          calculatedBmi: bmi,
          calculatedBmr: bmr,
          recommendedCalories: calories,
          weightToLose:
              healthGoal == HealthGoal.loseWeight && targetWeight != null
              ? weight - targetWeight
              : (healthGoal == HealthGoal.loseWeight
                    ? weight - calculateTargetWeight(height, healthGoal.value)
                    : null),
          weightToGain:
              healthGoal == HealthGoal.gainWeight && targetWeight != null
              ? targetWeight - weight
              : (healthGoal == HealthGoal.gainWeight
                    ? calculateTargetWeight(height, healthGoal.value) - weight
                    : null),
        ),
      );
    }
  }
}

final healthProfileProvider =
    AsyncNotifierProvider<HealthProfileNotifier, HealthProfileState>(() {
      return HealthProfileNotifier();
    });
