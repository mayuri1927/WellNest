import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.userId,
    required super.doctorName,
    required super.specialty,
    super.clinicName,
    super.address,
    required super.dateTime,
    required super.durationMinutes,
    super.notes,
    super.isCompleted,
    super.reminderSet,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      specialty: data['specialty'] ?? '',
      clinicName: data['clinicName'],
      address: data['address'],
      dateTime: data['dateTime'] != null
          ? DateTime.parse(data['dateTime'])
          : DateTime.now(),
      durationMinutes: data['durationMinutes'] ?? 30,
      notes: data['notes'],
      isCompleted: data['isCompleted'] ?? false,
      reminderSet: data['reminderSet'] ?? true,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      doctorName: entity.doctorName,
      specialty: entity.specialty,
      clinicName: entity.clinicName,
      address: entity.address,
      dateTime: entity.dateTime,
      durationMinutes: entity.durationMinutes,
      notes: entity.notes,
      isCompleted: entity.isCompleted,
      reminderSet: entity.reminderSet,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'doctorName': doctorName,
      'specialty': specialty,
      'clinicName': clinicName,
      'address': address,
      'dateTime': dateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'isCompleted': isCompleted,
      'reminderSet': reminderSet,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      userId: userId,
      doctorName: doctorName,
      specialty: specialty,
      clinicName: clinicName,
      address: address,
      dateTime: dateTime,
      durationMinutes: durationMinutes,
      notes: notes,
      isCompleted: isCompleted,
      reminderSet: reminderSet,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
