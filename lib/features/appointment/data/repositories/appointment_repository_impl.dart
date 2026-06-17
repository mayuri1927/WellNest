import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_local_datasource.dart';
import '../datasources/appointment_remote_datasource.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDatasource _remoteDatasource;
  final AppointmentLocalDatasource _localDatasource;

  AppointmentRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      return await _remoteDatasource.getAppointments();
    } catch (e) {
      return await _localDatasource.getAppointments();
    }
  }

  @override
  Future<void> addAppointment(Map<String, dynamic> appointment) async {
    try {
      await _remoteDatasource.createAppointment(appointment);
    } catch (e) {
      await _localDatasource.saveAppointment(appointment);
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await _remoteDatasource.deleteAppointment(id);
    } catch (e) {
      await _localDatasource.deleteAppointment(id);
      rethrow;
    }
  }
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final remoteDatasource = ref.watch(appointmentRemoteDatasourceProvider);
  final localDatasource = ref.watch(appointmentLocalDatasourceProvider);
  return AppointmentRepositoryImpl(remoteDatasource, localDatasource);
});
