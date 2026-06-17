enum WorkoutType {
  cardio('Cardio', 'cardio'),
  strength('Strength', 'strength'),
  flexibility('Flexibility', 'flexibility'),
  hiit('HIIT', 'hiit'),
  yoga('Yoga', 'yoga'),
  sports('Sports', 'sports'),
  other('Other', 'other');

  final String label;
  final String value;

  const WorkoutType(this.label, this.value);

  static WorkoutType fromString(String value) =>
      WorkoutType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => WorkoutType.other,
      );
}

enum MealType {
  breakfast('Breakfast', 'breakfast'),
  lunch('Lunch', 'lunch'),
  dinner('Dinner', 'dinner'),
  snack('Snack', 'snack');

  final String label;
  final String value;

  const MealType(this.label, this.value);

  static MealType fromString(String value) => MealType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => MealType.snack,
      );
}

enum MedicineUnit {
  tablet('Tablet', 'tablet'),
  capsule('Capsule', 'capsule'),
  ml('ML', 'ml'),
  mg('MG', 'mg'),
  drops('Drops', 'drops'),
  injection('Injection', 'injection');

  final String label;
  final String value;

  const MedicineUnit(this.label, this.value);

  static MedicineUnit fromString(String value) => MedicineUnit.values.firstWhere(
        (e) => e.value == value,
        orElse: () => MedicineUnit.tablet,
      );
}

enum DocumentType {
  prescription('Prescription', 'prescription'),
  medicalReport('Medical Report', 'medical_report'),
  labResults('Lab Results', 'lab_results'),
  insurance('Insurance', 'insurance'),
  idProof('ID Proof', 'id_proof'),
  other('Other', 'other');

  final String label;
  final String value;

  const DocumentType(this.label, this.value);

  static DocumentType fromString(String value) => DocumentType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => DocumentType.other,
      );
}

enum Gender {
  male('Male', 'male'),
  female('Female', 'female'),
  other('Other', 'other');

  final String label;
  final String value;

  const Gender(this.label, this.value);

  static Gender fromString(String value) => Gender.values.firstWhere(
        (e) => e.value == value,
        orElse: () => Gender.other,
      );
}

enum BloodType {
  aPositive('A+', 'a_positive'),
  aNegative('A-', 'a_negative'),
  bPositive('B+', 'b_positive'),
  bNegative('B-', 'b_negative'),
  oPositive('O+', 'o_positive'),
  oNegative('O-', 'o_negative'),
  abPositive('AB+', 'ab_positive'),
  abNegative('AB-', 'ab_negative');

  final String label;
  final String value;

  const BloodType(this.label, this.value);

  static BloodType fromString(String value) => BloodType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => BloodType.oPositive,
      );
}

enum AppointmentStatus {
  scheduled('Scheduled', 'scheduled'),
  completed('Completed', 'completed'),
  cancelled('Cancelled', 'cancelled'),
  noShow('No Show', 'no_show');

  final String label;
  final String value;

  const AppointmentStatus(this.label, this.value);

  static AppointmentStatus fromString(String value) =>
      AppointmentStatus.values.firstWhere(
        (e) => e.value == value,
        orElse: () => AppointmentStatus.scheduled,
      );
}

enum OnboardingPage {
  welcome(
    title: 'Welcome to WellNest',
    description: 'Your complete family health management companion',
    icon: '🏠',
  ),
  workouts(
    title: 'Track Your Workouts',
    description: 'Log exercises, monitor progress, and achieve your fitness goals',
    icon: '💪',
  ),
  meals(
    title: 'Monitor Nutrition',
    description: 'Track meals, calories, and maintain healthy eating habits',
    icon: '🥗',
  ),
  medicines(
    title: 'Medicine Reminders',
    description: 'Never miss a dose with timely medication reminders',
    icon: '💊',
  ),
  appointments(
    title: 'Doctor Appointments',
    description: 'Schedule and manage healthcare appointments easily',
    icon: '📅',
  ),
  documents(
    title: 'Medical Documents',
    description: 'Securely store and access your medical records',
    icon: '📁',
  );

  final String title;
  final String description;
  final String icon;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
