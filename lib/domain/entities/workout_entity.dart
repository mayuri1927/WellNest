import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String type;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        type,
        durationMinutes,
        caloriesBurned,
        date,
        notes,
        createdAt,
        updatedAt,
      ];

  WorkoutEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
