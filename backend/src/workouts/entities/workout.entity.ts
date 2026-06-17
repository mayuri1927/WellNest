import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum WorkoutType {
  CARDIO = 'cardio',
  STRENGTH = 'strength',
  FLEXIBILITY = 'flexibility',
  HIIT = 'hiit',
  YOGA = 'yoga',
  SPORTS = 'sports',
  OTHER = 'other',
}

export class Workout {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ example: 'Morning Run' })
  title: string;

  @ApiProperty({ enum: WorkoutType, example: WorkoutType.CARDIO })
  workoutType: WorkoutType;

  @ApiProperty({ example: 30 })
  duration: number;

  @ApiProperty({ example: 250 })
  caloriesBurned: number;

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty({ type: [String] })
  exercises: string[];

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
