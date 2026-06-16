import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.type,
    required super.durationMinutes,
    required super.caloriesBurned,
    required super.date,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkoutModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      durationMinutes: data['durationMinutes'] ?? 0,
      caloriesBurned: data['caloriesBurned'] ?? 0,
      date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(),
      notes: data['notes'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  factory WorkoutModel.fromEntity(WorkoutEntity entity) {
    return WorkoutModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      type: entity.type,
      durationMinutes: entity.durationMinutes,
      caloriesBurned: entity.caloriesBurned,
      date: entity.date,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'type': type,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      id: id,
      userId: userId,
      title: title,
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      date: date,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
