import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/date_time_pickers.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/appointment_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddAppointmentScreen extends ConsumerStatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  ConsumerState<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends ConsumerState<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _doctorNameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    final authState = ref.read(authProvider);
    final appointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      userId: authState.value?.userId ?? '',
      doctorName: _doctorNameController.text,
      specialty: _specialtyController.text.isNotEmpty ? _specialtyController.text : null,
      dateTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: DateTime.now(),
    );
    await ref.read(appointmentProvider.notifier).addAppointment(appointment);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Appointment'), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Appointment Details'),
            AppTextField(controller: _doctorNameController, label: 'Doctor Name', hint: 'Enter doctor name', prefixIcon: Icons.person, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _specialtyController, label: 'Specialty (optional)', hint: 'e.g., Cardiologist', prefixIcon: Icons.medical_services),
            const SizedBox(height: Spacing.md),
            DatePickerField(label: 'Date', selectedDate: _selectedDate, onDateSelected: (d) => setState(() => _selectedDate = d)),
            const SizedBox(height: Spacing.md),
            TimePickerField(label: 'Time', selectedTime: _selectedTime, onTimeSelected: (t) => setState(() => _selectedTime = t)),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _locationController, label: 'Location (optional)', hint: 'Clinic or hospital address', prefixIcon: Icons.location_on),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _notesController, label: 'Notes (optional)', hint: 'Any additional notes', maxLines: 3),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(text: 'Save Appointment', isFullWidth: true, onPressed: _saveAppointment),
          ],
        ),
      ),
    );
  }
}
