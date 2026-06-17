import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum MedicineStatus {
  ACTIVE = 'active',
  COMPLETED = 'completed',
  PAUSED = 'paused',
  STOPPED = 'stopped',
}

export enum MedicineUnit {
  TABLET = 'tablet',
  CAPSULE = 'capsule',
  ML = 'ml',
  MG = 'mg',
  DROPS = 'drops',
  INJECTION = 'injection',
}

export class Medicine {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiPropertyOptional()
  familyMemberId?: string;

  @ApiProperty({ example: 'Aspirin' })
  medicineName: string;

  @ApiProperty({ example: 500 })
  dosage: number;

  @ApiProperty({ enum: MedicineUnit })
  unit: MedicineUnit;

  @ApiProperty({ example: 'Twice daily' })
  frequency: string;

  @ApiProperty()
  startDate: Date;

  @ApiPropertyOptional()
  endDate?: Date;

  @ApiPropertyOptional({ type: [String] })
  times?: string[];

  @ApiPropertyOptional()
  instructions?: string;

  @ApiProperty({ enum: MedicineStatus })
  status: MedicineStatus;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
