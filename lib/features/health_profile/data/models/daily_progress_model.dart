class DailyProgress {
  final String id;
  final String userId;
  final DateTime date;
  final double? caloriesConsumed;
  final double? caloriesBurned;
  final int? waterGlasses;
  final double? sleepHours;
  final bool workoutCompleted;
  final bool dietFollowed;
  final double? currentWeight;
  final String? notes;

  const DailyProgress({
    required this.id,
    required this.userId,
    required this.date,
    this.caloriesConsumed,
    this.caloriesBurned,
    this.waterGlasses,
    this.sleepHours,
    this.workoutCompleted = false,
    this.dietFollowed = false,
    this.currentWeight,
    this.notes,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      caloriesConsumed: json['caloriesConsumed'] != null
          ? (json['caloriesConsumed'] as num).toDouble()
          : null,
      caloriesBurned: json['caloriesBurned'] != null
          ? (json['caloriesBurned'] as num).toDouble()
          : null,
      waterGlasses: json['waterGlasses'] as int?,
      sleepHours: json['sleepHours'] != null
          ? (json['sleepHours'] as num).toDouble()
          : null,
      workoutCompleted: json['workoutCompleted'] as bool? ?? false,
      dietFollowed: json['dietFollowed'] as bool? ?? false,
      currentWeight: json['currentWeight'] != null
          ? (json['currentWeight'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      if (caloriesConsumed != null) 'caloriesConsumed': caloriesConsumed,
      if (caloriesBurned != null) 'caloriesBurned': caloriesBurned,
      if (waterGlasses != null) 'waterGlasses': waterGlasses,
      if (sleepHours != null) 'sleepHours': sleepHours,
      'workoutCompleted': workoutCompleted,
      'dietFollowed': dietFollowed,
      if (currentWeight != null) 'currentWeight': currentWeight,
      if (notes != null) 'notes': notes,
    };
  }

  DailyProgress copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? caloriesConsumed,
    double? caloriesBurned,
    int? waterGlasses,
    double? sleepHours,
    bool? workoutCompleted,
    bool? dietFollowed,
    double? currentWeight,
    String? notes,
  }) {
    return DailyProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      sleepHours: sleepHours ?? this.sleepHours,
      workoutCompleted: workoutCompleted ?? this.workoutCompleted,
      dietFollowed: dietFollowed ?? this.dietFollowed,
      currentWeight: currentWeight ?? this.currentWeight,
      notes: notes ?? this.notes,
    );
  }
}
