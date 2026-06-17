import { ApiProperty } from '@nestjs/swagger';

export enum LogStatus {
  TAKEN = 'taken',
  MISSED = 'missed',
  SKIPPED = 'skipped',
}

export class MedicineLog {
  @ApiProperty()
  id: string;

  @ApiProperty()
  medicineId: string;

  @ApiProperty({ enum: LogStatus })
  status: LogStatus;

  @ApiProperty()
  takenTime: Date;

  @ApiProperty()
  createdAt: Date;
}
