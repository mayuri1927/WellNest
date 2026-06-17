import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum AppointmentStatus {
  SCHEDULED = 'scheduled',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
  NO_SHOW = 'no_show',
}

export class Appointment {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiPropertyOptional()
  familyMemberId?: string;

  @ApiProperty({ example: 'Dr. Smith' })
  doctorName: string;

  @ApiPropertyOptional({ example: 'Cardiologist' })
  specialty?: string;

  @ApiPropertyOptional({ example: 'City Hospital' })
  hospital?: string;

  @ApiPropertyOptional({ example: '123 Medical Center, Suite 100' })
  location?: string;

  @ApiProperty()
  appointmentDate: Date;

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty({ enum: AppointmentStatus })
  status: AppointmentStatus;

  @ApiPropertyOptional({ type: [Number] })
  reminders?: number[];

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
