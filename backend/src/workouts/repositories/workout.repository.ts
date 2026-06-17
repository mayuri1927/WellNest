import { Workout } from '../entities/workout.entity';

export class WorkoutRepository {
  private workouts: Map<string, Workout> = new Map();
  private userIndex: Map<string, string[]> = new Map(); // userId -> workoutIds

  async create(workout: Workout): Promise<Workout> {
    this.workouts.set(workout.id, workout);

    const userWorkouts = this.userIndex.get(workout.userId) || [];
    userWorkouts.push(workout.id);
    this.userIndex.set(workout.userId, userWorkouts);

    return workout;
  }

  async findById(id: string): Promise<Workout | null> {
    return this.workouts.get(id) || null;
  }

  async findByUserId(userId: string): Promise<Workout[]> {
    const workoutIds = this.userIndex.get(userId) || [];
    return workoutIds
      .map((id) => this.workouts.get(id))
      .filter((w): w is Workout => w !== undefined)
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  }

  async update(id: string, data: Partial<Workout>): Promise<Workout> {
    const workout = this.workouts.get(id);
    if (!workout) throw new Error('Workout not found');

    const updated = { ...workout, ...data };
    this.workouts.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    const workout = this.workouts.get(id);
    if (workout) {
      const userWorkouts = this.userIndex.get(workout.userId) || [];
      this.userIndex.set(
        workout.userId,
        userWorkouts.filter((wid) => wid !== id),
      );
    }
    this.workouts.delete(id);
  }
}
