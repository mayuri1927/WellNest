import { PartialType } from '@nestjs/swagger';
import { CreateMedicineDto } from './create-medicine.dto';
import { MedicineStatus } from '../entities/medicine.entity';
import { IsEnum, IsOptional } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateMedicineDto extends PartialType(CreateMedicineDto) {
  @ApiPropertyOptional({ enum: MedicineStatus })
  @IsOptional()
  @IsEnum(MedicineStatus)
  status?: MedicineStatus;
}
