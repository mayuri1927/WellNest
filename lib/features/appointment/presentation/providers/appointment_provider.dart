import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Future<void> addAppointment(Appointment appointment) async {
    state = const AsyncValue.loading();
    try {
      final current = state.value?.appointments ?? [];
      final newList = [...current, appointment];
      await _box.put('appointments', newList.map((a) => {'id': a.id, 'userId': a.userId, 'doctorName': a.doctorName, 'specialty': a.specialty, 'dateTime': a.dateTime.toIso8601String(), 'location': a.location, 'notes': a.notes, 'createdAt': a.createdAt.toIso8601String()}).toList());
      state = AsyncValue.data(AppointmentState(appointments: newList));
    } catch (e, st) { state = AsyncValue.error(e.toString(), st); }
  }

  Future<void> deleteAppointment(String id) async {
    final current = state.value?.appointments ?? [];
    final newList = current.where((a) => a.id != id).toList();
    await _box.put('appointments', newList.map((a) => {'id': a.id, 'userId': a.userId, 'doctorName': a.doctorName, 'specialty': a.specialty, 'dateTime': a.dateTime.toIso8601String(), 'location': a.location, 'notes': a.notes, 'createdAt': a.createdAt.toIso8601String()}).toList());
    state = AsyncValue.data(AppointmentState(appointments: newList));
  }
}

final appointmentProvider = AsyncNotifierProvider<AppointmentNotifier, AppointmentState>(() => AppointmentNotifier());
