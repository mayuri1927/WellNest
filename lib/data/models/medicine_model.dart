import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.dosage,
    required super.unit,
    required super.frequency,
    required super.timeSlots,
    required super.startDate,
    super.endDate,
    super.isActive,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MedicineModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? '',
      unit: data['unit'] ?? '',
      frequency: data['frequency'] ?? '',
      timeSlots: List<String>.from(data['timeSlots'] ?? []),
      startDate: data['startDate'] != null
          ? DateTime.parse(data['startDate'])
          : DateTime.now(),
      endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
      isActive: data['isActive'] ?? true,
      notes: data['notes'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  factory MedicineModel.fromEntity(MedicineEntity entity) {
    return MedicineModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      dosage: entity.dosage,
      unit: entity.unit,
      frequency: entity.frequency,
      timeSlots: entity.timeSlots,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'unit': unit,
      'frequency': frequency,
      'timeSlots': timeSlots,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MedicineEntity toEntity() {
    return MedicineEntity(
      id: id,
      userId: userId,
      name: name,
      dosage: dosage,
      unit: unit,
      frequency: frequency,
      timeSlots: timeSlots,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
