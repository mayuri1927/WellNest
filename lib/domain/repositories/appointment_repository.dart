import '../../domain/entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(String id);
  Future<List<AppointmentEntity>> getAppointments(String userId);
  Stream<List<AppointmentEntity>> streamAppointments(String userId);
  Future<List<AppointmentEntity>> getUpcomingAppointments(String userId);
  Future<void> markAsCompleted(String id);
}
