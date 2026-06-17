import {
  IsNotEmpty,
  IsString,
  IsNumber,
  IsOptional,
  IsEnum,
  Min,
  IsDateString,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MealType } from '../entities/meal.entity';

export class CreateMealDto {
  @ApiProperty({ example: 'Grilled Chicken Salad' })
  @IsNotEmpty()
  @IsString()
  foodName: string;

  @ApiProperty({ enum: MealType })
  @IsNotEmpty()
  @IsEnum(MealType)
  mealType: MealType;

  @ApiProperty({ example: 350 })
  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  calories: number;

  @ApiPropertyOptional({ example: 30 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  protein?: number;

  @ApiPropertyOptional({ example: 20 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  carbs?: number;

  @ApiPropertyOptional({ example: 15 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  fat?: number;

  @ApiPropertyOptional({ example: 5 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  fiber?: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsDateString()
  mealDate: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;
}
