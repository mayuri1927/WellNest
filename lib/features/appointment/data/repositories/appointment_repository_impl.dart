import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_local_datasource.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDatasource _datasource;
  AppointmentRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getAppointments() async => await _datasource.getAppointments();

  @override
  Future<void> addAppointment(Map<String, dynamic> appointment) async => await _datasource.saveAppointment(appointment);

  @override
  Future<void> deleteAppointment(String id) async => await _datasource.deleteAppointment(id);
}
