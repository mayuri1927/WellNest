import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/enums/app_enums.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/health_profile_provider.dart';

class HealthProfileSetupScreen extends ConsumerStatefulWidget {
  const HealthProfileSetupScreen({super.key});

  @override
  ConsumerState<HealthProfileSetupScreen> createState() =>
      _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState
    extends ConsumerState<HealthProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _targetWeightController = TextEditingController();

  Gender _selectedGender = Gender.male;
  HealthGoal _selectedGoal = HealthGoal.maintainWeight;
  bool _hasTargetWeight = false;

  double? _previewBmi;
  int? _previewCalories;
  String _bmiCategory = 'Normal';

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_updatePreview);
    _weightController.addListener(_updatePreview);
    _ageController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (height != null && weight != null && age != null && age > 0) {
      final notifier = ref.read(healthProfileProvider.notifier);
      notifier.updateCalculations(
        height: height,
        weight: weight,
        age: age,
        gender: _selectedGender,
        healthGoal: _selectedGoal,
        targetWeight: _hasTargetWeight
            ? double.tryParse(_targetWeightController.text)
            : null,
      );

      setState(() {
        final heightM = height / 100;
        _previewBmi = weight / (heightM * heightM);
        _bmiCategory = _getBmiCategory(_previewBmi!);

        double bmr;
        if (_selectedGender == Gender.male) {
          bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
        } else {
          bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
        }

        const activityFactor = 1.55;
        double tdee = bmr * activityFactor;

        switch (_selectedGoal) {
          case HealthGoal.loseWeight:
            _previewCalories = (tdee - 500).round();
            break;
          case HealthGoal.gainWeight:
            _previewCalories = (tdee + 500).round();
            break;
          case HealthGoal.maintainWeight:
            _previewCalories = tdee.round();
            break;
        }
      });
    }
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final userId = authState.value?.userId;

    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please sign up first')));
      }
      return;
    }

    await ref
        .read(healthProfileProvider.notifier)
        .saveHealthProfile(
          userId: userId,
          height: double.parse(_heightController.text),
          age: int.parse(_ageController.text),
          weight: double.parse(_weightController.text),
          targetWeight: _hasTargetWeight
              ? double.parse(_targetWeightController.text)
              : null,
          gender: _selectedGender,
          healthGoal: _selectedGoal,
        );

    if (mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Your Profile'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  'This helps us calculate your health goals and provide personalized recommendations.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                AppTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  hint: 'Enter your height in cm',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.height,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 50 || height > 300) {
                      return 'Enter a valid height (50-300 cm)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Spacing.md),

                AppTextField(
                  controller: _ageController,
                  label: 'Age',
                  hint: 'Enter your age',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.cake_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Enter a valid age (1-120)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Spacing.md),

                AppTextField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  hint: 'Enter your weight in kg',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: Icons.monitor_weight_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 20 || weight > 500) {
                      return 'Enter a valid weight (20-500 kg)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Spacing.lg),

                Text(
                  'Gender',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: Gender.values.map((gender) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: gender != Gender.values.last ? Spacing.sm : 0,
                        ),
                        child: _GenderOption(
                          gender: gender,
                          isSelected: _selectedGender == gender,
                          onTap: () {
                            setState(() => _selectedGender = gender);
                            _updatePreview();
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: Spacing.lg),

                Text(
                  'Health Goal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                ...HealthGoal.values.map((goal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: _GoalOption(
                      goal: goal,
                      isSelected: _selectedGoal == goal,
                      onTap: () {
                        setState(() => _selectedGoal = goal);
                        _updatePreview();
                      },
                    ),
                  );
                }),
                const SizedBox(height: Spacing.lg),

                Row(
                  children: [
                    Checkbox(
                      value: _hasTargetWeight,
                      onChanged: (value) {
                        setState(() => _hasTargetWeight = value ?? false);
                        if (!_hasTargetWeight) {
                          _targetWeightController.clear();
                        }
                      },
                    ),
                    const Expanded(child: Text('Set a target weight')),
                  ],
                ),

                if (_hasTargetWeight) ...[
                  const SizedBox(height: Spacing.sm),
                  AppTextField(
                    controller: _targetWeightController,
                    label: 'Target Weight (kg)',
                    hint: 'Enter your target weight',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: Icons.flag_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                    onChanged: (_) => _updatePreview(),
                    validator: (value) {
                      if (!_hasTargetWeight) return null;
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      final target = double.tryParse(value);
                      if (target == null || target < 20 || target > 500) {
                        return 'Enter a valid weight (20-500 kg)';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: Spacing.xl),

                if (_previewBmi != null) ...[
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Health Preview',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _MetricTile(
                                label: 'BMI',
                                value: _previewBmi!.toStringAsFixed(1),
                                subtitle: _bmiCategory,
                                color: _getBmiColor(_bmiCategory),
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: _MetricTile(
                                label: 'Daily Calories',
                                value: '$_previewCalories',
                                subtitle: 'kcal/day',
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                ],

                PrimaryButton(
                  text: 'Complete Setup',
                  isFullWidth: true,
                  onPressed: _saveProfile,
                ),
                const SizedBox(height: Spacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBmiColor(String category) {
    switch (category) {
      case 'Underweight':
        return AppColors.warning;
      case 'Normal':
        return AppColors.success;
      case 'Overweight':
        return AppColors.warning;
      case 'Obese':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _GenderOption extends StatelessWidget {
  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Column(
          children: [
            Icon(
              gender == Gender.male ? Icons.male : Icons.female,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              gender.label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final HealthGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (goal) {
      case HealthGoal.loseWeight:
        return Icons.trending_down;
      case HealthGoal.gainWeight:
        return Icons.trending_up;
      case HealthGoal.maintainWeight:
        return Icons.check_circle_outline;
    }
  }

  String get _description {
    switch (goal) {
      case HealthGoal.loseWeight:
        return 'Lose weight through calorie deficit';
      case HealthGoal.gainWeight:
        return 'Build muscle with calorie surplus';
      case HealthGoal.maintainWeight:
        return 'Stay at your current weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(
                _icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
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
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
