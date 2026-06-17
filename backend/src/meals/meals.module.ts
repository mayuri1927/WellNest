import { Module } from '@nestjs/common';
import { MealsController } from './meals.controller';
import { MealsService } from './meals.service';
import { MealRepository } from './repositories/meal.repository';

@Module({
  controllers: [MealsController],
  providers: [MealsService, MealRepository],
  exports: [MealsService],
})
export class MealsModule {}
