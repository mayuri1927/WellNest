import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum DocumentType {
  PRESCRIPTION = 'prescription',
  MEDICAL_REPORT = 'medical_report',
  LAB_RESULTS = 'lab_results',
  INSURANCE = 'insurance',
  ID_PROOF = 'id_proof',
  OTHER = 'other',
}

export class MedicalDocument {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiPropertyOptional()
  familyMemberId?: string;

  @ApiProperty({ example: 'Blood Test Report - January 2024' })
  title: string;

  @ApiProperty({ enum: DocumentType })
  documentType: DocumentType;

  @ApiProperty({ example: 'https://storage.example.com/documents/123.pdf' })
  fileUrl: string;

  @ApiPropertyOptional({ example: 'blood_test_report.pdf' })
  fileName?: string;

  @ApiPropertyOptional({ example: 1024000 })
  fileSize?: number;

  @ApiPropertyOptional({ example: 'application/pdf' })
  mimeType?: string;

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty()
  uploadedAt: Date;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
