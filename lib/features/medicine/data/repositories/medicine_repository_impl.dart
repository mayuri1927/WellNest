import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';
import '../datasources/medicine_remote_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDatasource _remoteDatasource;
  final MedicineLocalDatasource _localDatasource;

  MedicineRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getMedicines() async {
    try {
      return await _remoteDatasource.getMedicines();
    } catch (e) {
      return await _localDatasource.getMedicines();
    }
  }

  @override
  Future<void> addMedicine(Map<String, dynamic> medicine) async {
    try {
      await _remoteDatasource.createMedicine(medicine);
    } catch (e) {
      await _localDatasource.saveMedicine(medicine);
      rethrow;
    }
  }

  @override
  Future<void> deleteMedicine(String id) async {
    try {
      await _remoteDatasource.deleteMedicine(id);
    } catch (e) {
      await _localDatasource.deleteMedicine(id);
      rethrow;
    }
  }
}

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final remoteDatasource = ref.watch(medicineRemoteDatasourceProvider);
  final localDatasource = ref.watch(medicineLocalDatasourceProvider);
  return MedicineRepositoryImpl(remoteDatasource, localDatasource);
});
