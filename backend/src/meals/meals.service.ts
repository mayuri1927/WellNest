import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { Meal, MealType } from './entities/meal.entity';
import { MealRepository } from './repositories/meal.repository';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';

@Injectable()
export class MealsService {
  constructor(private mealRepository: MealRepository) {}

  async create(userId: string, createMealDto: CreateMealDto): Promise<Meal> {
    const meal: Meal = {
      id: uuidv4(),
      userId,
      foodName: createMealDto.foodName,
      mealType: createMealDto.mealType,
      calories: createMealDto.calories,
      protein: createMealDto.protein || 0,
      carbs: createMealDto.carbs || 0,
      fat: createMealDto.fat || 0,
      fiber: createMealDto.fiber || 0,
      mealDate: new Date(createMealDto.mealDate),
      notes: createMealDto.notes,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.mealRepository.create(meal);
  }

  async findAll(userId: string, date?: string): Promise<Meal[]> {
    if (date) {
      return this.mealRepository.findByDate(userId, new Date(date));
    }
    return this.mealRepository.findByUserId(userId);
  }

  async findOne(userId: string, mealId: string): Promise<Meal> {
    const meal = await this.mealRepository.findById(mealId);
    if (!meal || meal.userId !== userId) {
      throw new NotFoundException('Meal not found');
    }
    return meal;
  }

  async update(
    userId: string,
    mealId: string,
    updateMealDto: UpdateMealDto,
  ): Promise<Meal> {
    await this.findOne(userId, mealId);
    const { mealDate, ...rest } = updateMealDto;
    const updateData: Partial<Meal> = { ...rest };
    if (mealDate) {
      updateData.mealDate = new Date(mealDate);
    }
    return this.mealRepository.update(mealId, {
      ...updateData,
      updatedAt: new Date(),
    });
  }

  async remove(userId: string, mealId: string): Promise<void> {
    await this.findOne(userId, mealId);
    await this.mealRepository.delete(mealId);
  }

  async getNutritionSummary(userId: string, startDate: Date, endDate: Date) {
    const meals = await this.mealRepository.findByDateRange(userId, startDate, endDate);

    return {
      totalMeals: meals.length,
      totalCalories: meals.reduce((sum, m) => sum + m.calories, 0),
      totalProtein: meals.reduce((sum, m) => sum + (m.protein || 0), 0),
      totalCarbs: meals.reduce((sum, m) => sum + (m.carbs || 0), 0),
      totalFat: meals.reduce((sum, m) => sum + (m.fat || 0), 0),
      totalFiber: meals.reduce((sum, m) => sum + (m.fiber || 0), 0),
      averageCaloriesPerMeal: meals.length > 0 
        ? Math.round(meals.reduce((sum, m) => sum + m.calories, 0) / meals.length)
        : 0,
    };
  }
}
