import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/repositories/medicine_repository_impl.dart';

class MedicineState {
  final List<Medicine> medicines;
  final bool isLoading;
  final String? error;

  const MedicineState({this.medicines = const [], this.isLoading = false, this.error});

  MedicineState copyWith({List<Medicine>? medicines, bool? isLoading, String? error}) {
    return MedicineState(medicines: medicines ?? this.medicines, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class Medicine {
  final String id;
  final String userId;
  final String name;
  final double dosage;
  final String unit;
  final String? frequency;
  final DateTime? reminderTime;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;

  Medicine({required this.id, required this.userId, required this.name, required this.dosage, required this.unit, this.frequency, this.reminderTime, this.notes, this.isActive = true, required this.createdAt});
}

class MedicineNotifier extends AsyncNotifier<MedicineState> {
  late Box _box;

  @override
  Future<MedicineState> build() async {
    _box = Hive.box('medicines');
    return _loadMedicines();
  }

  MedicineState _loadMedicines() {
    final data = _box.get('medicines', defaultValue: []);
    if (data is List) {
      final medicines = data.map((m) {
        if (m is Map) {
          return Medicine(
            id: m['id'] ?? '', userId: m['userId'] ?? '', name: m['name'] ?? '', dosage: (m['dosage'] ?? 0).toDouble(), unit: m['unit'] ?? 'mg',
            frequency: m['frequency'], reminderTime: m['reminderTime'] != null ? DateTime.parse(m['reminderTime']) : null,
            notes: m['notes'], isActive: m['isActive'] ?? true, createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<Medicine>().toList();
      return MedicineState(medicines: medicines);
    }
    return const MedicineState();
  }

  Future<void> fetchMedicines() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      final data = await repository.getMedicines();
      final medicines = data.map((m) => Medicine(
        id: m['id'] ?? '',
        userId: m['userId'] ?? '',
        name: m['medicineName'] ?? m['name'] ?? '',
        dosage: (m['dosage'] ?? 0).toDouble(),
        unit: m['unit'] ?? 'mg',
        frequency: m['frequency'],
        reminderTime: m['times'] != null && (m['times'] as List).isNotEmpty ? DateTime.parse((m['times'] as List).first) : null,
        notes: m['instructions'] ?? m['notes'],
        isActive: m['status'] == 'active',
        createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt']) : DateTime.now(),
      )).toList();
      state = AsyncValue.data(MedicineState(medicines: medicines));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      await repository.addMedicine({
        'id': medicine.id,
        'userId': medicine.userId,
        'medicineName': medicine.name,
        'dosage': medicine.dosage,
        'unit': medicine.unit.toLowerCase(),
        'frequency': medicine.frequency,
        'instructions': medicine.notes,
        'status': medicine.isActive ? 'active' : 'completed',
        'createdAt': medicine.createdAt.toIso8601String(),
      });
      await fetchMedicines();
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      final repository = ref.read(medicineRepositoryProvider);
      await repository.deleteMedicine(id);
      final current = state.value?.medicines ?? [];
      final newList = current.where((m) => m.id != id).toList();
      state = AsyncValue.data(MedicineState(medicines: newList));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }
}

final medicineProvider = AsyncNotifierProvider<MedicineNotifier, MedicineState>(() => MedicineNotifier());
