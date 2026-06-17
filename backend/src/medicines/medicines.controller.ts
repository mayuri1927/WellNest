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
import { MedicinesService } from './medicines.service';
import { CreateMedicineDto } from './dto/create-medicine.dto';
import { UpdateMedicineDto } from './dto/update-medicine.dto';
import { MarkMedicineTakenDto } from './dto/mark-medicine-taken.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('medicines')
@Controller('medicines')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class MedicinesController {
  constructor(private readonly medicinesService: MedicinesService) {}

  @Post()
  @ApiOperation({ summary: 'Add a new medicine' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createMedicineDto: CreateMedicineDto,
  ) {
    return this.medicinesService.create(userId, createMedicineDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all medicines' })
  async findAll(@CurrentUser('sub') userId: string) {
    return this.medicinesService.findAll(userId);
  }

  @Get('adherence-stats')
  @ApiOperation({ summary: 'Get medicine adherence statistics' })
  async getAdherenceStats(
    @CurrentUser('sub') userId: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    return this.medicinesService.getAdherenceStats(
      userId,
      new Date(startDate),
      new Date(endDate),
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get medicine by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.medicinesService.findOne(userId, id);
  }

  @Get(':id/logs')
  @ApiOperation({ summary: 'Get medicine logs' })
  async getMedicineLogs(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.medicinesService.getMedicineLogs(userId, id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update medicine' })
  async update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateMedicineDto: UpdateMedicineDto,
  ) {
    return this.medicinesService.update(userId, id, updateMedicineDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete medicine' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.medicinesService.remove(userId, id);
    return { message: 'Medicine deleted successfully' };
  }

  @Post(':id/mark-taken')
  @ApiOperation({ summary: 'Mark medicine as taken' })
  async markAsTaken(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() markMedicineTakenDto: MarkMedicineTakenDto,
  ) {
    return this.medicinesService.markAsTaken(userId, id, markMedicineTakenDto.status);
  }
}
