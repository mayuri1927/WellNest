import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medicine_entity.dart';
import 'providers.dart';
import 'auth_provider.dart';

class MedicineState {
  final List<MedicineEntity> medicines;
  final bool isLoading;
  final String? errorMessage;

  MedicineState({
    this.medicines = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MedicineState copyWith({
    List<MedicineEntity>? medicines,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MedicineState(
      medicines: medicines ?? this.medicines,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  List<MedicineEntity> get activeMedicines {
    return medicines.where((m) => m.isActive).toList();
  }
}

class MedicineNotifier extends StateNotifier<MedicineState> {
  final Ref _ref;

  MedicineNotifier(this._ref) : super(MedicineState()) {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final medicines = await _ref.read(medicineRepositoryProvider).getMedicines(user.id);
        state = state.copyWith(medicines: medicines, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addMedicine({
    required String name,
    required String dosage,
    required String unit,
    required String frequency,
    required List<String> timeSlots,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final medicine = MedicineEntity(
          id: const Uuid().v4(),
          userId: user.id,
          name: name,
          dosage: dosage,
          unit: unit,
          frequency: frequency,
          timeSlots: timeSlots,
          startDate: startDate,
          endDate: endDate,
          notes: notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _ref.read(medicineRepositoryProvider).addMedicine(medicine);
        await loadMedicines();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateMedicine(MedicineEntity medicine) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(medicineRepositoryProvider).updateMedicine(medicine);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteMedicine(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(medicineRepositoryProvider).deleteMedicine(id);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> toggleActive(String id) async {
    try {
      final medicine = state.medicines.firstWhere((m) => m.id == id);
      await _ref.read(medicineRepositoryProvider).toggleMedicineActive(id, !medicine.isActive);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final medicineProvider = StateNotifierProvider<MedicineNotifier, MedicineState>((ref) {
  return MedicineNotifier(ref);
});

final activeMedicinesProvider = Provider<List<MedicineEntity>>((ref) {
  final medicineState = ref.watch(medicineProvider);
  return medicineState.activeMedicines;
});
