import { ExerciseLog } from '../entities/exercise-log.entity';

export class ExerciseLogRepository {
  private logs: Map<string, ExerciseLog> = new Map();

  async create(log: ExerciseLog): Promise<ExerciseLog> {
    this.logs.set(log.id, log);
    return log;
  }

  async findById(id: string): Promise<ExerciseLog | null> {
    return this.logs.get(id) || null;
  }

  async findByWorkoutId(workoutId: string): Promise<ExerciseLog[]> {
    return Array.from(this.logs.values()).filter((log) => log.workoutId === workoutId);
  }

  async delete(id: string): Promise<void> {
    this.logs.delete(id);
  }
}
