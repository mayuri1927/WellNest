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
import { AppointmentsService } from './appointments.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { UpdateAppointmentStatusDto } from './dto/update-appointment-status.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('appointments')
@Controller('appointments')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class AppointmentsController {
  constructor(private readonly appointmentsService: AppointmentsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new appointment' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createAppointmentDto: CreateAppointmentDto,
  ) {
    return this.appointmentsService.create(userId, createAppointmentDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all appointments' })
  async findAll(@CurrentUser('sub') userId: string) {
    return this.appointmentsService.findAll(userId);
  }

  @Get('upcoming')
  @ApiOperation({ summary: 'Get upcoming appointments' })
  async findUpcoming(@CurrentUser('sub') userId: string) {
    return this.appointmentsService.findUpcoming(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get appointment by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.appointmentsService.findOne(userId, id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update appointment' })
  async update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateAppointmentDto: UpdateAppointmentDto,
  ) {
    return this.appointmentsService.update(userId, id, updateAppointmentDto);
  }

  @Put(':id/status')
  @ApiOperation({ summary: 'Update appointment status' })
  async updateStatus(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateStatusDto: UpdateAppointmentStatusDto,
  ) {
    return this.appointmentsService.updateStatus(userId, id, updateStatusDto.status);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete appointment' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.appointmentsService.remove(userId, id);
    return { message: 'Appointment deleted successfully' };
  }
}
