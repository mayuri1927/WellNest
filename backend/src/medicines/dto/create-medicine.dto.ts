import {
  IsNotEmpty,
  IsString,
  IsNumber,
  IsOptional,
  IsEnum,
  IsArray,
  IsDateString,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MedicineUnit } from '../entities/medicine.entity';

export class CreateMedicineDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  familyMemberId?: string;

  @ApiProperty({ example: 'Aspirin' })
  @IsNotEmpty()
  @IsString()
  medicineName: string;

  @ApiProperty({ example: 500 })
  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  dosage: number;

  @ApiProperty({ enum: MedicineUnit })
  @IsNotEmpty()
  @IsEnum(MedicineUnit)
  unit: MedicineUnit;

  @ApiProperty({ example: 'Twice daily' })
  @IsNotEmpty()
  @IsString()
  frequency: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsDateString()
  startDate: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({ type: [String], example: ['08:00', '20:00'] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  times?: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  instructions?: string;
}
