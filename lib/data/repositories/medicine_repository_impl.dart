import '../../domain/entities/medicine_entity.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/medicine_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineDataSource _medicineDataSource;

  MedicineRepositoryImpl({required MedicineDataSource medicineDataSource})
      : _medicineDataSource = medicineDataSource;

  @override
  Future<void> addMedicine(MedicineEntity medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    await _medicineDataSource.addMedicine(model);
  }

  @override
  Future<void> updateMedicine(MedicineEntity medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    await _medicineDataSource.updateMedicine(medicine.id, model);
  }

  @override
  Future<void> deleteMedicine(String id) async {
    await _medicineDataSource.deleteMedicine(id);
  }

  @override
  Future<List<MedicineEntity>> getMedicines(String userId) async {
    final models = await _medicineDataSource.getMedicines(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<MedicineEntity>> streamMedicines(String userId) {
    return _medicineDataSource.streamMedicines(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<MedicineEntity>> getActiveMedicines(String userId) async {
    final allMedicines = await getMedicines(userId);
    return allMedicines.where((m) => m.isActive).toList();
  }

  @override
  Future<void> toggleMedicineActive(String id, bool isActive) async {
    final medicines = await _medicineDataSource.getMedicines(id);
    final medicine = medicines.firstWhere((m) => m.id == id);
    final updated = MedicineModel(
      id: medicine.id,
      userId: medicine.userId,
      name: medicine.name,
      dosage: medicine.dosage,
      unit: medicine.unit,
      frequency: medicine.frequency,
      timeSlots: medicine.timeSlots,
      startDate: medicine.startDate,
      endDate: medicine.endDate,
      isActive: isActive,
      notes: medicine.notes,
      createdAt: medicine.createdAt,
      updatedAt: DateTime.now(),
    );
    await _medicineDataSource.updateMedicine(id, updated);
  }
}
