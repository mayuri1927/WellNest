import {
  IsNotEmpty,
  IsString,
  IsNumber,
  IsOptional,
  IsEnum,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { WorkoutType } from '../entities/workout.entity';

export class CreateWorkoutDto {
  @ApiProperty({ example: 'Morning Run' })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiProperty({ enum: WorkoutType })
  @IsNotEmpty()
  @IsEnum(WorkoutType)
  workoutType: WorkoutType;

  @ApiProperty({ example: 30 })
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  duration: number;

  @ApiProperty({ example: 250 })
  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  caloriesBurned: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;
}
