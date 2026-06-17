import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AppointmentLocalDatasource {
  Future<List<Map<String, dynamic>>> getAppointments();
  Future<void> saveAppointment(Map<String, dynamic> appointment);
  Future<void> deleteAppointment(String id);
}

class AppointmentLocalDatasourceImpl implements AppointmentLocalDatasource {
  late Box _box;
  AppointmentLocalDatasourceImpl() { _box = Hive.box('appointments'); }

  @override
  Future<List<Map<String, dynamic>>> getAppointments() async {
    final data = _box.get('appointments', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveAppointment(Map<String, dynamic> appointment) async {
    final appointments = await getAppointments();
    appointments.add(appointment);
    await _box.put('appointments', appointments);
  }

  @override
  Future<void> deleteAppointment(String id) async {
    final appointments = await getAppointments();
    appointments.removeWhere((a) => a['id'] == id);
    await _box.put('appointments', appointments);
  }
}

final appointmentLocalDatasourceProvider = Provider<AppointmentLocalDatasource>((ref) => AppointmentLocalDatasourceImpl());
