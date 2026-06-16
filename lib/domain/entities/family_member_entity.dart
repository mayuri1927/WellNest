import 'package:equatable/equatable.dart';

class FamilyMemberEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String relationship;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final String? allergies;
  final String? medicalConditions;
  final String? emergencyContact;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FamilyMemberEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    this.dateOfBirth,
    this.bloodType,
    this.allergies,
    this.medicalConditions,
    this.emergencyContact,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        relationship,
        dateOfBirth,
        bloodType,
        allergies,
        medicalConditions,
        emergencyContact,
        notes,
        createdAt,
        updatedAt,
      ];

  FamilyMemberEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? relationship,
    DateTime? dateOfBirth,
    String? bloodType,
    String? allergies,
    String? medicalConditions,
    String? emergencyContact,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMemberEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
