import { ApiProperty } from '@nestjs/swagger';

export class WorkoutAnalytics {
  @ApiProperty()
  totalWorkouts: number;

  @ApiProperty()
  totalDuration: number;

  @ApiProperty()
  totalCaloriesBurned: number;

  @ApiProperty()
  averageDurationPerWorkout: number;

  @ApiProperty()
  averageCaloriesPerWorkout: number;

  @ApiProperty()
  workoutsLast7Days: number;

  @ApiProperty()
  workoutsLast30Days: number;

  @ApiProperty()
  caloriesBurnedLast7Days: number;

  @ApiProperty({ example: { cardio: 10, strength: 5 } })
  workoutsByType: Record<string, number>;

  @ApiProperty({ type: [Object] })
  weeklyData: { day: string; count: number; calories: number }[];
}
