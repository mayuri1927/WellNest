import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/appointment_entity.dart';
import 'providers.dart';
import 'auth_provider.dart';

class AppointmentState {
  final List<AppointmentEntity> appointments;
  final bool isLoading;
  final String? errorMessage;

  AppointmentState({
    this.appointments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AppointmentState copyWith({
    List<AppointmentEntity>? appointments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  List<AppointmentEntity> get upcomingAppointments {
    final now = DateTime.now();
    return appointments
        .where((a) => a.dateTime.isAfter(now) && !a.isCompleted)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<AppointmentEntity> get todayAppointments {
    final now = DateTime.now();
    return appointments.where((a) {
      return a.dateTime.year == now.year &&
          a.dateTime.month == now.month &&
          a.dateTime.day == now.day;
    }).toList();
  }
}

class AppointmentNotifier extends StateNotifier<AppointmentState> {
  final Ref _ref;

  AppointmentNotifier(this._ref) : super(AppointmentState()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final appointments = await _ref.read(appointmentRepositoryProvider).getAppointments(user.id);
        state = state.copyWith(appointments: appointments, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addAppointment({
    required String doctorName,
    required String specialty,
    String? clinicName,
    String? address,
    required DateTime dateTime,
    required int durationMinutes,
    String? notes,
    bool reminderSet = true,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final appointment = AppointmentEntity(
          id: const Uuid().v4(),
          userId: user.id,
          doctorName: doctorName,
          specialty: specialty,
          clinicName: clinicName,
          address: address,
          dateTime: dateTime,
          durationMinutes: durationMinutes,
          notes: notes,
          reminderSet: reminderSet,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _ref.read(appointmentRepositoryProvider).addAppointment(appointment);
        await loadAppointments();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateAppointment(AppointmentEntity appointment) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(appointmentRepositoryProvider).updateAppointment(appointment);
      await loadAppointments();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteAppointment(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(appointmentRepositoryProvider).deleteAppointment(id);
      await loadAppointments();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> markAsCompleted(String id) async {
    try {
      await _ref.read(appointmentRepositoryProvider).markAsCompleted(id);
      await loadAppointments();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final appointmentProvider = StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier(ref);
});

final upcomingAppointmentsProvider = Provider<List<AppointmentEntity>>((ref) {
  final appointmentState = ref.watch(appointmentProvider);
  return appointmentState.upcomingAppointments;
});
