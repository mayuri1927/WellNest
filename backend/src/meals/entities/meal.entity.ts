import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum MealType {
  BREAKFAST = 'breakfast',
  LUNCH = 'lunch',
  DINNER = 'dinner',
  SNACK = 'snack',
}

export class Meal {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ example: 'Grilled Chicken Salad' })
  foodName: string;

  @ApiProperty({ enum: MealType })
  mealType: MealType;

  @ApiProperty({ example: 350 })
  calories: number;

  @ApiPropertyOptional({ example: 30 })
  protein?: number;

  @ApiPropertyOptional({ example: 20 })
  carbs?: number;

  @ApiPropertyOptional({ example: 15 })
  fat?: number;

  @ApiPropertyOptional({ example: 5 })
  fiber?: number;

  @ApiProperty()
  mealDate: Date;

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
