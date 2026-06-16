import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/domain/entities/meal_entity.dart';

void main() {
  group('MealEntity', () {
    test('creates meal with required fields', () {
      final meal = MealEntity(
        id: '1',
        userId: 'user1',
        title: 'Grilled Chicken',
        type: 'Lunch',
        calories: 350,
        protein: 30,
        carbs: 10,
        fat: 15,
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(meal.id, '1');
      expect(meal.title, 'Grilled Chicken');
      expect(meal.type, 'Lunch');
      expect(meal.calories, 350);
      expect(meal.protein, 30);
    });

    test('copyWith creates new instance with updated fields', () {
      final meal = MealEntity(
        id: '1',
        userId: 'user1',
        title: 'Grilled Chicken',
        type: 'Lunch',
        calories: 350,
        protein: 30,
        carbs: 10,
        fat: 15,
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = meal.copyWith(
        title: 'Grilled Salmon',
        calories: 400,
      );

      expect(updated.title, 'Grilled Salmon');
      expect(updated.calories, 400);
      expect(updated.protein, 30);
    });
  });
}
