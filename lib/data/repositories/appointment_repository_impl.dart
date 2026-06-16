import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentDataSource _appointmentDataSource;

  AppointmentRepositoryImpl({required AppointmentDataSource appointmentDataSource})
      : _appointmentDataSource = appointmentDataSource;

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    final model = AppointmentModel.fromEntity(appointment);
    await _appointmentDataSource.addAppointment(model);
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    final model = AppointmentModel.fromEntity(appointment);
    await _appointmentDataSource.updateAppointment(appointment.id, model);
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await _appointmentDataSource.deleteAppointment(id);
  }

  @override
  Future<List<AppointmentEntity>> getAppointments(String userId) async {
    final models = await _appointmentDataSource.getAppointments(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<AppointmentEntity>> streamAppointments(String userId) {
    return _appointmentDataSource.streamAppointments(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<AppointmentEntity>> getUpcomingAppointments(String userId) async {
    final allAppointments = await getAppointments(userId);
    final now = DateTime.now();
    return allAppointments
        .where((a) => a.dateTime.isAfter(now) && !a.isCompleted)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  @override
  Future<void> markAsCompleted(String id) async {
    final appointments = await _appointmentDataSource.getAppointments(id);
    final appointment = appointments.firstWhere((a) => a.id == id);
    final updated = AppointmentModel(
      id: appointment.id,
      userId: appointment.userId,
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      clinicName: appointment.clinicName,
      address: appointment.address,
      dateTime: appointment.dateTime,
      durationMinutes: appointment.durationMinutes,
      notes: appointment.notes,
      isCompleted: true,
      reminderSet: appointment.reminderSet,
      createdAt: appointment.createdAt,
      updatedAt: DateTime.now(),
    );
    await _appointmentDataSource.updateAppointment(id, updated);
  }
}
