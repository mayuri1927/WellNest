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
import '../providers/medicine_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();
  MedicineUnit _selectedUnit = MedicineUnit.mg;
  DateTime _reminderTime = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) return;
    final authState = ref.read(authProvider);
    final medicine = Medicine(
      id: 'medicine_${DateTime.now().millisecondsSinceEpoch}',
      userId: authState.value?.userId ?? '',
      name: _nameController.text,
      dosage: double.tryParse(_dosageController.text) ?? 0,
      unit: _selectedUnit.label,
      frequency: _frequencyController.text.isNotEmpty ? _frequencyController.text : null,
      reminderTime: _reminderTime,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: DateTime.now(),
    );
    await ref.read(medicineProvider.notifier).addMedicine(medicine);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine'), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Medicine Details'),
            AppTextField(controller: _nameController, label: 'Medicine Name', hint: 'Enter medicine name', prefixIcon: Icons.medication, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: Spacing.md),
            Row(children: [
              Expanded(child: AppTextField(controller: _dosageController, label: 'Dosage', hint: 'e.g., 500', keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
              const SizedBox(width: Spacing.md),
              Expanded(child: DropdownButtonFormField<MedicineUnit>(
                value: _selectedUnit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: MedicineUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.label))).toList(),
                onChanged: (v) => setState(() => _selectedUnit = v!),
              )),
            ]),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _frequencyController, label: 'Frequency (optional)', hint: 'e.g., Twice daily', prefixIcon: Icons.schedule),
            const SizedBox(height: Spacing.md),
            TimePickerField(label: 'Reminder Time', selectedTime: TimeOfDay.fromDateTime(_reminderTime), onTimeSelected: (t) => setState(() => _reminderTime = DateTime(_reminderTime.year, _reminderTime.month, _reminderTime.day, t.hour, t.minute))),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _notesController, label: 'Notes (optional)', hint: 'Any instructions', maxLines: 3),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(text: 'Save Medicine', isFullWidth: true, onPressed: _saveMedicine),
          ],
        ),
      ),
    );
  }
}
