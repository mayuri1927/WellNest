import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ExerciseLog {
  @ApiProperty()
  id: string;

  @ApiProperty()
  workoutId: string;

  @ApiProperty({ example: 'Bench Press' })
  exerciseName: string;

  @ApiPropertyOptional({ example: 3 })
  sets?: number;

  @ApiPropertyOptional({ example: 10 })
  reps?: number;

  @ApiPropertyOptional({ example: 50 })
  weight?: number;

  @ApiPropertyOptional({ example: 30 })
  duration?: number;

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty()
  createdAt: Date;
}
