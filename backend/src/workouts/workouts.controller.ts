import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  Query,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { WorkoutsService } from './workouts.service';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { UpdateWorkoutDto } from './dto/update-workout.dto';
import { CreateExerciseLogDto } from './dto/create-exercise-log.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('workouts')
@Controller('workouts')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class WorkoutsController {
  constructor(private readonly workoutsService: WorkoutsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new workout' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createWorkoutDto: CreateWorkoutDto,
  ) {
    return this.workoutsService.create(userId, createWorkoutDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all workouts for current user' })
  async findAll(@CurrentUser('sub') userId: string) {
    return this.workoutsService.findAll(userId);
  }

  @Get('analytics')
  @ApiOperation({ summary: 'Get workout analytics' })
  async getAnalytics(@CurrentUser('sub') userId: string) {
    return this.workoutsService.getAnalytics(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get workout by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.workoutsService.findOne(userId, id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update workout' })
  async update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateWorkoutDto: UpdateWorkoutDto,
  ) {
    return this.workoutsService.update(userId, id, updateWorkoutDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete workout' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.workoutsService.remove(userId, id);
    return { message: 'Workout deleted successfully' };
  }

  @Post(':id/exercises')
  @ApiOperation({ summary: 'Add exercise to workout' })
  async addExercise(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() createExerciseLogDto: CreateExerciseLogDto,
  ) {
    return this.workoutsService.addExercise(userId, id, createExerciseLogDto);
  }

  @Delete(':id/exercises/:exerciseId')
  @ApiOperation({ summary: 'Remove exercise from workout' })
  async removeExercise(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Param('exerciseId') exerciseId: string,
  ) {
    await this.workoutsService.removeExercise(userId, id, exerciseId);
    return { message: 'Exercise removed successfully' };
  }
}
