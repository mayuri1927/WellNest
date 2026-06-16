import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String type;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime dateTime;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.dateTime,
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
        calories,
        protein,
        carbs,
        fat,
        dateTime,
        notes,
        createdAt,
        updatedAt,
      ];

  MealEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? dateTime,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
