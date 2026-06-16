class AppConstants {
  AppConstants._();

  static const String appName = 'WellNest';
  static const String appVersion = '1.0.0';

  static const int maxWorkoutDuration = 300;
  static const int maxMealCalories = 5000;
  static const int maxMedicineDosage = 100;

  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration cacheExpiration = Duration(minutes: 30);

  static const List<String> workoutTypes = [
    'Cardio',
    'Strength',
    'Flexibility',
    'HIIT',
    'Yoga',
    'Sports',
    'Other',
  ];

  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  static const List<String> medicineUnits = [
    'tablet',
    'capsule',
    'ml',
    'mg',
    'drops',
    'injection',
  ];

  static const List<String> documentTypes = [
    'Prescription',
    'Medical Report',
    'Lab Results',
    'Insurance',
    'ID Proof',
    'Other',
  ];
}
