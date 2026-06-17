import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { Workout, WorkoutType } from './entities/workout.entity';
import { ExerciseLog } from './entities/exercise-log.entity';
import { WorkoutRepository } from './repositories/workout.repository';
import { ExerciseLogRepository } from './repositories/exercise-log.repository';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { UpdateWorkoutDto } from './dto/update-workout.dto';
import { CreateExerciseLogDto } from './dto/create-exercise-log.dto';
import { WorkoutAnalytics } from './dto/workout-analytics.dto';

@Injectable()
export class WorkoutsService {
  constructor(
    private workoutRepository: WorkoutRepository,
    private exerciseLogRepository: ExerciseLogRepository,
  ) {}

  /**
   * Create a new workout
   */
  async create(userId: string, createWorkoutDto: CreateWorkoutDto): Promise<Workout> {
    const workout: Workout = {
      id: uuidv4(),
      userId,
      title: createWorkoutDto.title,
      workoutType: createWorkoutDto.workoutType,
      duration: createWorkoutDto.duration,
      caloriesBurned: createWorkoutDto.caloriesBurned,
      notes: createWorkoutDto.notes,
      exercises: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.workoutRepository.create(workout);
  }

  /**
   * Find all workouts for a user
   */
  async findAll(userId: string): Promise<Workout[]> {
    return this.workoutRepository.findByUserId(userId);
  }

  /**
   * Find workout by ID
   */
  async findOne(userId: string, workoutId: string): Promise<Workout> {
    const workout = await this.workoutRepository.findById(workoutId);
    
    if (!workout || workout.userId !== userId) {
      throw new NotFoundException('Workout not found');
    }

    return workout;
  }

  /**
   * Update a workout
   */
  async update(
    userId: string,
    workoutId: string,
    updateWorkoutDto: UpdateWorkoutDto,
  ): Promise<Workout> {
    const workout = await this.findOne(userId, workoutId);
    return this.workoutRepository.update(workoutId, {
      ...updateWorkoutDto,
      updatedAt: new Date(),
    });
  }

  /**
   * Delete a workout
   */
  async remove(userId: string, workoutId: string): Promise<void> {
    await this.findOne(userId, workoutId);
    await this.workoutRepository.delete(workoutId);
  }

  /**
   * Add exercise to workout
   */
  async addExercise(
    userId: string,
    workoutId: string,
    createExerciseLogDto: CreateExerciseLogDto,
  ): Promise<ExerciseLog> {
    const workout = await this.findOne(userId, workoutId);

    const exercise: ExerciseLog = {
      id: uuidv4(),
      workoutId,
      exerciseName: createExerciseLogDto.exerciseName,
      sets: createExerciseLogDto.sets,
      reps: createExerciseLogDto.reps,
      weight: createExerciseLogDto.weight,
      duration: createExerciseLogDto.duration,
      notes: createExerciseLogDto.notes,
      createdAt: new Date(),
    };

    await this.exerciseLogRepository.create(exercise);

    // Update workout's exercise list
    workout.exercises.push(exercise.id);
    await this.workoutRepository.update(workoutId, {
      exercises: workout.exercises,
      updatedAt: new Date(),
    });

    return exercise;
  }

  /**
   * Remove exercise from workout
   */
  async removeExercise(
    userId: string,
    workoutId: string,
    exerciseId: string,
  ): Promise<void> {
    await this.findOne(userId, workoutId);
    await this.exerciseLogRepository.delete(exerciseId);

    const workout = await this.workoutRepository.findById(workoutId);
    if (!workout) {
      throw new NotFoundException('Workout not found');
    }
    workout.exercises = workout.exercises.filter((id: string) => id !== exerciseId);
    await this.workoutRepository.update(workoutId, {
      exercises: workout.exercises,
      updatedAt: new Date(),
    });
  }

  /**
   * Get workout analytics for a user
   */
  async getAnalytics(userId: string): Promise<WorkoutAnalytics> {
    const workouts = await this.workoutRepository.findByUserId(userId);

    const now = new Date();
    const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    const sevenDaysAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    const last30DaysWorkouts = workouts.filter(
      (w) => new Date(w.createdAt) >= thirtyDaysAgo,
    );
    const last7DaysWorkouts = workouts.filter(
      (w) => new Date(w.createdAt) >= sevenDaysAgo,
    );

    const totalWorkouts = workouts.length;
    const totalDuration = workouts.reduce((sum, w) => sum + w.duration, 0);
    const totalCaloriesBurned = workouts.reduce((sum, w) => sum + w.caloriesBurned, 0);

    const workoutsByType: Record<string, number> = {};
    workouts.forEach((w) => {
      workoutsByType[w.workoutType] = (workoutsByType[w.workoutType] || 0) + 1;
    });

    const weeklyData = this.getWeeklyData(workouts);

    return {
      totalWorkouts,
      totalDuration,
      totalCaloriesBurned,
      averageDurationPerWorkout: totalWorkouts > 0 ? Math.round(totalDuration / totalWorkouts) : 0,
      averageCaloriesPerWorkout: totalWorkouts > 0 ? Math.round(totalCaloriesBurned / totalWorkouts) : 0,
      workoutsLast7Days: last7DaysWorkouts.length,
      workoutsLast30Days: last30DaysWorkouts.length,
      caloriesBurnedLast7Days: last7DaysWorkouts.reduce((sum, w) => sum + w.caloriesBurned, 0),
      workoutsByType,
      weeklyData,
    };
  }

  private getWeeklyData(workouts: Workout[]): { day: string; count: number; calories: number }[] {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const now = new Date();
    const result: { day: string; count: number; calories: number }[] = [];

    for (let i = 6; i >= 0; i--) {
      const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const dayWorkouts = workouts.filter((w) => {
        const workoutDate = new Date(w.createdAt);
        return (
          workoutDate.getDate() === date.getDate() &&
          workoutDate.getMonth() === date.getMonth() &&
          workoutDate.getFullYear() === date.getFullYear()
        );
      });

      result.push({
        day: days[date.getDay()],
        count: dayWorkouts.length,
        calories: dayWorkouts.reduce((sum, w) => sum + w.caloriesBurned, 0),
      });
    }

    return result;
  }
}
