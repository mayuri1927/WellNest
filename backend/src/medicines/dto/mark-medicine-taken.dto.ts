import { IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { LogStatus } from '../entities/medicine-log.entity';

export class MarkMedicineTakenDto {
  @ApiProperty({ enum: LogStatus })
  @IsEnum(LogStatus)
  status: LogStatus;
}
