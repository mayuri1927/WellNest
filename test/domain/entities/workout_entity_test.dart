import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/domain/entities/workout_entity.dart';

void main() {
  group('WorkoutEntity', () {
    test('creates workout with required fields', () {
      final workout = WorkoutEntity(
        id: '1',
        userId: 'user1',
        title: 'Morning Run',
        type: 'Cardio',
        durationMinutes: 30,
        caloriesBurned: 300,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(workout.id, '1');
      expect(workout.title, 'Morning Run');
      expect(workout.type, 'Cardio');
      expect(workout.durationMinutes, 30);
      expect(workout.caloriesBurned, 300);
    });

    test('copyWith creates new instance with updated fields', () {
      final workout = WorkoutEntity(
        id: '1',
        userId: 'user1',
        title: 'Morning Run',
        type: 'Cardio',
        durationMinutes: 30,
        caloriesBurned: 300,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = workout.copyWith(
        title: 'Evening Run',
        durationMinutes: 45,
      );

      expect(updated.title, 'Evening Run');
      expect(updated.durationMinutes, 45);
      expect(updated.type, 'Cardio');
      expect(updated.id, '1');
    });

    test('props returns correct list for equality', () {
      final date = DateTime.now();
      final workout1 = WorkoutEntity(
        id: '1',
        userId: 'user1',
        title: 'Morning Run',
        type: 'Cardio',
        durationMinutes: 30,
        caloriesBurned: 300,
        date: date,
        createdAt: date,
        updatedAt: date,
      );

      final workout2 = WorkoutEntity(
        id: '1',
        userId: 'user1',
        title: 'Morning Run',
        type: 'Cardio',
        durationMinutes: 30,
        caloriesBurned: 300,
        date: date,
        createdAt: date,
        updatedAt: date,
      );

      expect(workout1, workout2);
    });
  });
}
