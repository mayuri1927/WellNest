abstract class MedicineRepository {
  Future<List<Map<String, dynamic>>> getMedicines();
  Future<void> addMedicine(Map<String, dynamic> medicine);
  Future<void> deleteMedicine(String id);
}
