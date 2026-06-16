import '../../domain/entities/medicine_entity.dart';

abstract class MedicineRepository {
  Future<void> addMedicine(MedicineEntity medicine);
  Future<void> updateMedicine(MedicineEntity medicine);
  Future<void> deleteMedicine(String id);
  Future<List<MedicineEntity>> getMedicines(String userId);
  Stream<List<MedicineEntity>> streamMedicines(String userId);
  Future<List<MedicineEntity>> getActiveMedicines(String userId);
  Future<void> toggleMedicineActive(String id, bool isActive);
}
