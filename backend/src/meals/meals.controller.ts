import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { MealsService } from './meals.service';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('meals')
@Controller('meals')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class MealsController {
  constructor(private readonly mealsService: MealsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new meal' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createMealDto: CreateMealDto,
  ) {
    return this.mealsService.create(userId, createMealDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all meals for current user' })
  async findAll(
    @CurrentUser('sub') userId: string,
    @Query('date') date?: string,
  ) {
    return this.mealsService.findAll(userId, date);
  }

  @Get('nutrition-summary')
  @ApiOperation({ summary: 'Get nutrition summary for date range' })
  async getNutritionSummary(
    @CurrentUser('sub') userId: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    return this.mealsService.getNutritionSummary(
      userId,
      new Date(startDate),
      new Date(endDate),
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get meal by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.mealsService.findOne(userId, id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update meal' })
  async update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateMealDto: UpdateMealDto,
  ) {
    return this.mealsService.update(userId, id, updateMealDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete meal' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.mealsService.remove(userId, id);
    return { message: 'Meal deleted successfully' };
  }
}
