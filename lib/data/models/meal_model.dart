import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.type,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.dateTime,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MealModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      calories: data['calories'] ?? 0,
      protein: (data['protein'] ?? 0).toDouble(),
      carbs: (data['carbs'] ?? 0).toDouble(),
      fat: (data['fat'] ?? 0).toDouble(),
      dateTime: data['dateTime'] != null
          ? DateTime.parse(data['dateTime'])
          : DateTime.now(),
      notes: data['notes'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  factory MealModel.fromEntity(MealEntity entity) {
    return MealModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      type: entity.type,
      calories: entity.calories,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      dateTime: entity.dateTime,
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
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MealEntity toEntity() {
    return MealEntity(
      id: id,
      userId: userId,
      title: title,
      type: type,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      dateTime: dateTime,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
