import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class MedicineLocalDatasource {
  Future<List<Map<String, dynamic>>> getMedicines();
  Future<void> saveMedicine(Map<String, dynamic> medicine);
  Future<void> deleteMedicine(String id);
}

class MedicineLocalDatasourceImpl implements MedicineLocalDatasource {
  late Box _box;
  MedicineLocalDatasourceImpl() { _box = Hive.box('medicines'); }

  @override
  Future<List<Map<String, dynamic>>> getMedicines() async {
    final data = _box.get('medicines', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveMedicine(Map<String, dynamic> medicine) async {
    final medicines = await getMedicines();
    medicines.add(medicine);
    await _box.put('medicines', medicines);
  }

  @override
  Future<void> deleteMedicine(String id) async {
    final medicines = await getMedicines();
    medicines.removeWhere((m) => m['id'] == id);
    await _box.put('medicines', medicines);
  }
}

final medicineLocalDatasourceProvider = Provider<MedicineLocalDatasource>((ref) => MedicineLocalDatasourceImpl());
