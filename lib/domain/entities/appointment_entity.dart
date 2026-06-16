import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String userId;
  final String doctorName;
  final String specialty;
  final String? clinicName;
  final String? address;
  final DateTime dateTime;
  final int durationMinutes;
  final String? notes;
  final bool isCompleted;
  final bool reminderSet;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentEntity({
    required this.id,
    required this.userId,
    required this.doctorName,
    required this.specialty,
    this.clinicName,
    this.address,
    required this.dateTime,
    required this.durationMinutes,
    this.notes,
    this.isCompleted = false,
    this.reminderSet = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        doctorName,
        specialty,
        clinicName,
        address,
        dateTime,
        durationMinutes,
        notes,
        isCompleted,
        reminderSet,
        createdAt,
        updatedAt,
      ];

  AppointmentEntity copyWith({
    String? id,
    String? userId,
    String? doctorName,
    String? specialty,
    String? clinicName,
    String? address,
    DateTime? dateTime,
    int? durationMinutes,
    String? notes,
    bool? isCompleted,
    bool? reminderSet,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      clinicName: clinicName ?? this.clinicName,
      address: address ?? this.address,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderSet: reminderSet ?? this.reminderSet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
