import { Module } from '@nestjs/common';
import { WorkoutsController } from './workouts.controller';
import { WorkoutsService } from './workouts.service';
import { WorkoutRepository } from './repositories/workout.repository';
import { ExerciseLogRepository } from './repositories/exercise-log.repository';

@Module({
  controllers: [WorkoutsController],
  providers: [WorkoutsService, WorkoutRepository, ExerciseLogRepository],
  exports: [WorkoutsService],
})
export class WorkoutsModule {}
