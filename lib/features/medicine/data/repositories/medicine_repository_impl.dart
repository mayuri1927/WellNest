import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDatasource _datasource;
  MedicineRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getMedicines() async => await _datasource.getMedicines();

  @override
  Future<void> addMedicine(Map<String, dynamic> medicine) async => await _datasource.saveMedicine(medicine);

  @override
  Future<void> deleteMedicine(String id) async => await _datasource.deleteMedicine(id);
}
