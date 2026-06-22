import '../../../../shared/enums/app_enums.dart';

class HealthProfile {
  final String? id;
  final String userId;
  final double height;
  final int age;
  final double weight;
  final double? targetWeight;
  final Gender gender;
  final HealthGoal healthGoal;
  final int dailyCalorieTarget;
  final double? bmi;
  final double? bmr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HealthProfile({
    this.id,
    required this.userId,
    required this.height,
    required this.age,
    required this.weight,
    this.targetWeight,
    required this.gender,
    required this.healthGoal,
    required this.dailyCalorieTarget,
    this.bmi,
    this.bmr,
    this.createdAt,
    this.updatedAt,
  });

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      height: (json['height'] as num).toDouble(),
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      targetWeight: json['targetWeight'] != null
          ? (json['targetWeight'] as num).toDouble()
          : null,
      gender: Gender.fromString(json['gender'] as String),
      healthGoal: HealthGoal.fromString(json['healthGoal'] as String),
      dailyCalorieTarget: json['dailyCalorieTarget'] as int,
      bmi: json['bmi'] != null ? (json['bmi'] as num).toDouble() : null,
      bmr: json['bmr'] != null ? (json['bmr'] as num).toDouble() : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'height': height,
      'age': age,
      'weight': weight,
      if (targetWeight != null) 'targetWeight': targetWeight,
      'gender': gender.value,
      'healthGoal': healthGoal.value,
      'dailyCalorieTarget': dailyCalorieTarget,
      if (bmi != null) 'bmi': bmi,
      if (bmr != null) 'bmr': bmr,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  HealthProfile copyWith({
    String? id,
    String? userId,
    double? height,
    int? age,
    double? weight,
    double? targetWeight,
    Gender? gender,
    HealthGoal? healthGoal,
    int? dailyCalorieTarget,
    double? bmi,
    double? bmr,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      height: height ?? this.height,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      gender: gender ?? this.gender,
      healthGoal: healthGoal ?? this.healthGoal,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      bmi: bmi ?? this.bmi,
      bmr: bmr ?? this.bmr,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
