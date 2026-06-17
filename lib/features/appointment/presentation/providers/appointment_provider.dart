import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/repositories/appointment_repository_impl.dart';

class AppointmentState {
  final List<Appointment> appointments;
  final bool isLoading;
  final String? error;

  const AppointmentState({this.appointments = const [], this.isLoading = false, this.error});

  AppointmentState copyWith({List<Appointment>? appointments, bool? isLoading, String? error}) {
    return AppointmentState(appointments: appointments ?? this.appointments, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class Appointment {
  final String id;
  final String userId;
  final String doctorName;
  final String? specialty;
  final DateTime dateTime;
  final String? location;
  final String? notes;
  final DateTime createdAt;

  Appointment({required this.id, required this.userId, required this.doctorName, this.specialty, required this.dateTime, this.location, this.notes, required this.createdAt});
}

class AppointmentNotifier extends AsyncNotifier<AppointmentState> {
  late Box _box;

  @override
  Future<AppointmentState> build() async {
    _box = Hive.box('appointments');
    return _loadAppointments();
  }

  AppointmentState _loadAppointments() {
    final data = _box.get('appointments', defaultValue: []);
    if (data is List) {
      final appointments = data.map((a) {
        if (a is Map) {
          return Appointment(
            id: a['id'] ?? '', userId: a['userId'] ?? '', doctorName: a['doctorName'] ?? '',
            specialty: a['specialty'], dateTime: a['dateTime'] != null ? DateTime.parse(a['dateTime']) : DateTime.now(),
            location: a['location'], notes: a['notes'], createdAt: a['createdAt'] != null ? DateTime.parse(a['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<Appointment>().toList();
      return AppointmentState(appointments: appointments);
    }
    return const AppointmentState();
  }

  Future<void> fetchAppointments() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final data = await repository.getAppointments();
      final appointments = data.map((a) => Appointment(
        id: a['id'] ?? '',
        userId: a['userId'] ?? '',
        doctorName: a['doctorName'] ?? '',
        specialty: a['specialty'],
        dateTime: a['appointmentDate'] != null ? DateTime.parse(a['appointmentDate']) : DateTime.now(),
        location: a['location'],
        notes: a['notes'],
        createdAt: a['createdAt'] != null ? DateTime.parse(a['createdAt']) : DateTime.now(),
      )).toList();
      state = AsyncValue.data(AppointmentState(appointments: appointments));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      await repository.addAppointment({
        'id': appointment.id,
        'userId': appointment.userId,
        'doctorName': appointment.doctorName,
        'specialty': appointment.specialty,
        'appointmentDate': appointment.dateTime.toIso8601String(),
        'location': appointment.location,
        'notes': appointment.notes,
        'status': 'scheduled',
        'createdAt': appointment.createdAt.toIso8601String(),
      });
      await fetchAppointments();
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      await repository.deleteAppointment(id);
      final current = state.value?.appointments ?? [];
      final newList = current.where((a) => a.id != id).toList();
      state = AsyncValue.data(AppointmentState(appointments: newList));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }
}

final appointmentProvider = AsyncNotifierProvider<AppointmentNotifier, AppointmentState>(() => AppointmentNotifier());
