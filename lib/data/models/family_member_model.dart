import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/family_member_entity.dart';

class FamilyMemberModel extends FamilyMemberEntity {
  const FamilyMemberModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.relationship,
    super.dateOfBirth,
    super.bloodType,
    super.allergies,
    super.medicalConditions,
    super.emergencyContact,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FamilyMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyMemberModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      relationship: data['relationship'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.parse(data['dateOfBirth'])
          : null,
      bloodType: data['bloodType'],
      allergies: data['allergies'],
      medicalConditions: data['medicalConditions'],
      emergencyContact: data['emergencyContact'],
      notes: data['notes'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  factory FamilyMemberModel.fromEntity(FamilyMemberEntity entity) {
    return FamilyMemberModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      relationship: entity.relationship,
      dateOfBirth: entity.dateOfBirth,
      bloodType: entity.bloodType,
      allergies: entity.allergies,
      medicalConditions: entity.medicalConditions,
      emergencyContact: entity.emergencyContact,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'relationship': relationship,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'emergencyContact': emergencyContact,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      id: id,
      userId: userId,
      name: name,
      relationship: relationship,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType,
      allergies: allergies,
      medicalConditions: medicalConditions,
      emergencyContact: emergencyContact,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
