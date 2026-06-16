import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String dosage;
  final String unit;
  final String frequency;
  final List<String> timeSlots;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicineEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.frequency,
    required this.timeSlots,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        dosage,
        unit,
        frequency,
        timeSlots,
        startDate,
        endDate,
        isActive,
        notes,
        createdAt,
        updatedAt,
      ];

  MedicineEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    String? unit,
    String? frequency,
    List<String>? timeSlots,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicineEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      frequency: frequency ?? this.frequency,
      timeSlots: timeSlots ?? this.timeSlots,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
