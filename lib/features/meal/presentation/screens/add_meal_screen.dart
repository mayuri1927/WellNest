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
import '../providers/meal_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  MealType _selectedType = MealType.snack;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final meal = Meal(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      userId: authState.value?.userId ?? '',
      name: _nameController.text,
      mealType: _selectedType.label,
      calories: int.tryParse(_caloriesController.text) ?? 0,
      notes: _notesController.text,
      date: _selectedDate,
      createdAt: DateTime.now(),
    );

    await ref.read(mealProvider.notifier).addMeal(meal);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Meal Type'),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: MealType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedType = type);
                  },
                  selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.lg),
            AppTextField(
              controller: _nameController,
              label: 'Meal Name',
              hint: 'e.g., Grilled Chicken Salad',
              prefixIcon: Icons.restaurant,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _caloriesController,
              label: 'Calories',
              hint: 'e.g., 350',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.local_fire_department_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (int.tryParse(value) == null) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),
            DatePickerField(
              label: 'Date',
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _notesController,
              label: 'Notes (optional)',
              hint: 'Add any notes',
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(
              text: 'Save Meal',
              isFullWidth: true,
              onPressed: _saveMeal,
            ),
          ],
        ),
      ),
    );
  }
}
