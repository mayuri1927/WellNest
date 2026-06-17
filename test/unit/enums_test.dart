import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/shared/enums/app_enums.dart';

void main() {
  group('AppEnums', () {
    test('WorkoutType fromString should return correct type', () {
      expect(WorkoutType.fromString('cardio'), WorkoutType.cardio);
      expect(WorkoutType.fromString('invalid'), WorkoutType.other);
    });

    test('MealType fromString should return correct type', () {
      expect(MealType.fromString('breakfast'), MealType.breakfast);
      expect(MealType.fromString('invalid'), MealType.snack);
    });

    test('MedicineUnit fromString should return correct type', () {
      expect(MedicineUnit.fromString('tablet'), MedicineUnit.tablet);
      expect(MedicineUnit.fromString('invalid'), MedicineUnit.tablet);
    });

    test('DocumentType fromString should return correct type', () {
      expect(DocumentType.fromString('prescription'), DocumentType.prescription);
      expect(DocumentType.fromString('invalid'), DocumentType.other);
    });
  });
}
