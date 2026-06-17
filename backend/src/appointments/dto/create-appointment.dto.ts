import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsDateString,
  IsEnum,
  IsArray,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AppointmentStatus } from '../entities/appointment.entity';

export class CreateAppointmentDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  familyMemberId?: string;

  @ApiProperty({ example: 'Dr. Smith' })
  @IsNotEmpty()
  @IsString()
  doctorName: string;

  @ApiPropertyOptional({ example: 'Cardiologist' })
  @IsOptional()
  @IsString()
  specialty?: string;

  @ApiPropertyOptional({ example: 'City Hospital' })
  @IsOptional()
  @IsString()
  hospital?: string;

  @ApiPropertyOptional({ example: '123 Medical Center, Suite 100' })
  @IsOptional()
  @IsString()
  location?: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsDateString()
  appointmentDate: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ type: [Number], description: 'Minutes before appointment to send reminder' })
  @IsOptional()
  @IsArray()
  reminders?: number[];
}

export class UpdateAppointmentDto extends CreateAppointmentDto {}

export class UpdateAppointmentStatusDto {
  @ApiProperty({ enum: AppointmentStatus })
  @IsEnum(AppointmentStatus)
  status: AppointmentStatus;
}
