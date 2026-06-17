import { Meal } from '../entities/meal.entity';

export class MealRepository {
  private meals: Map<string, Meal> = new Map();
  private userIndex: Map<string, string[]> = new Map();

  async create(meal: Meal): Promise<Meal> {
    this.meals.set(meal.id, meal);
    const userMeals = this.userIndex.get(meal.userId) || [];
    userMeals.push(meal.id);
    this.userIndex.set(meal.userId, userMeals);
    return meal;
  }

  async findById(id: string): Promise<Meal | null> {
    return this.meals.get(id) || null;
  }

  async findByUserId(userId: string): Promise<Meal[]> {
    const mealIds = this.userIndex.get(userId) || [];
    return mealIds
      .map((id) => this.meals.get(id))
      .filter((m): m is Meal => m !== undefined)
      .sort((a, b) => new Date(b.mealDate).getTime() - new Date(a.mealDate).getTime());
  }

  async findByDate(userId: string, date: Date): Promise<Meal[]> {
    const meals = await this.findByUserId(userId);
    return meals.filter((m) => {
      const mealDate = new Date(m.mealDate);
      return (
        mealDate.getDate() === date.getDate() &&
        mealDate.getMonth() === date.getMonth() &&
        mealDate.getFullYear() === date.getFullYear()
      );
    });
  }

  async findByDateRange(userId: string, startDate: Date, endDate: Date): Promise<Meal[]> {
    const meals = await this.findByUserId(userId);
    return meals.filter((m) => {
      const mealDate = new Date(m.mealDate);
      return mealDate >= startDate && mealDate <= endDate;
    });
  }

  async update(id: string, data: Partial<Meal>): Promise<Meal> {
    const meal = this.meals.get(id);
    if (!meal) throw new Error('Meal not found');
    const updated = { ...meal, ...data };
    this.meals.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    const meal = this.meals.get(id);
    if (meal) {
      const userMeals = this.userIndex.get(meal.userId) || [];
      this.userIndex.set(
        meal.userId,
        userMeals.filter((mid) => mid !== id),
      );
    }
    this.meals.delete(id);
  }
}
