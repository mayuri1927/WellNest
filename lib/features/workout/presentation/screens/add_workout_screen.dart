import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/date_time_pickers.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/enums/app_enums.dart';
import '../providers/workout_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddWorkoutScreen extends ConsumerStatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  
  WorkoutType _selectedType = WorkoutType.cardio;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final workout = Workout(
      id: 'workout_${DateTime.now().millisecondsSinceEpoch}',
      userId: authState.value?.userId ?? '',
      type: _selectedType.label,
      duration: int.tryParse(_durationController.text) ?? 0,
      caloriesBurned: int.tryParse(_caloriesController.text) ?? 0,
      notes: _notesController.text,
      date: _selectedDate,
      createdAt: DateTime.now(),
    );

    await ref.read(workoutProvider.notifier).addWorkout(workout);
    
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Workout Type'),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: WorkoutType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedType = type);
                    }
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.lg),
            DatePickerField(
              label: 'Date',
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _durationController,
                    label: 'Duration (min)',
                    hint: 'e.g., 30',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.timer_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _caloriesController,
                    label: 'Calories Burned',
                    hint: 'e.g., 200',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.local_fire_department_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _notesController,
              label: 'Notes (optional)',
              hint: 'Add any notes about your workout',
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(
              text: 'Save Workout',
              isFullWidth: true,
              onPressed: _saveWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
