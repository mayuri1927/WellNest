import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_nest/presentation/providers/appointment_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';

class AddAppointmentScreen extends ConsumerStatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  ConsumerState<AddAppointmentScreen> createState() =>
      _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends ConsumerState<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _reminderSet = true;

  @override
  void dispose() {
    _doctorNameController.dispose();
    _specialtyController.dispose();
    _clinicNameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await ref.read(appointmentProvider.notifier).addAppointment(
            doctorName: _doctorNameController.text.trim(),
            specialty: _specialtyController.text.trim(),
            clinicName: _clinicNameController.text.trim().isEmpty
                ? null
                : _clinicNameController.text.trim(),
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
            dateTime: dateTime,
            durationMinutes: int.parse(_durationController.text),
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            reminderSet: _reminderSet,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _doctorNameController,
                label: 'Doctor Name',
                hint: 'e.g., Dr. John Smith',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _specialtyController,
                label: 'Specialty',
                hint: 'e.g., Cardiologist',
                prefixIcon: Icons.local_hospital,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specialty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _clinicNameController,
                label: 'Clinic Name (optional)',
                hint: 'e.g., City Hospital',
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                label: 'Address (optional)',
                hint: 'e.g., 123 Main St',
                prefixIcon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date'),
                      subtitle: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text(_selectedTime.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _durationController,
                label: 'Duration (minutes)',
                hint: '30',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.timer,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Set Reminder'),
                subtitle: const Text('Get notified before the appointment'),
                value: _reminderSet,
                onChanged: (value) {
                  setState(() {
                    _reminderSet = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes (optional)',
                hint: 'Add any notes...',
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: appointmentState.isLoading ? null : _handleSubmit,
                  child: appointmentState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
