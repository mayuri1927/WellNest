abstract class AppointmentRepository {
  Future<List<Map<String, dynamic>>> getAppointments();
  Future<void> addAppointment(Map<String, dynamic> appointment);
  Future<void> deleteAppointment(String id);
}
