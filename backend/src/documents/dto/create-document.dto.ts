import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsEnum,
  IsNumber,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DocumentType } from '../entities/document.entity';

export class CreateDocumentDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  familyMemberId?: string;

  @ApiProperty({ example: 'Blood Test Report - January 2024' })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiProperty({ enum: DocumentType })
  @IsNotEmpty()
  @IsEnum(DocumentType)
  documentType: DocumentType;

  @ApiProperty({ example: 'https://storage.example.com/documents/123.pdf' })
  @IsNotEmpty()
  @IsString()
  fileUrl: string;

  @ApiPropertyOptional({ example: 'blood_test_report.pdf' })
  @IsOptional()
  @IsString()
  fileName?: string;

  @ApiPropertyOptional({ example: 1024000 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  fileSize?: number;

  @ApiPropertyOptional({ example: 'application/pdf' })
  @IsOptional()
  @IsString()
  mimeType?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;
}
