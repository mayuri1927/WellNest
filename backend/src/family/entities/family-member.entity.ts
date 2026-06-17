import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum Gender {
  MALE = 'male',
  FEMALE = 'female',
  OTHER = 'other',
}

export enum BloodGroup {
  A_POSITIVE = 'A+',
  A_NEGATIVE = 'A-',
  B_POSITIVE = 'B+',
  B_NEGATIVE = 'B-',
  O_POSITIVE = 'O+',
  O_NEGATIVE = 'O-',
  AB_POSITIVE = 'AB+',
  AB_NEGATIVE = 'AB-',
}

export class FamilyMember {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ example: 'Jane Doe' })
  name: string;

  @ApiProperty({ example: 'Spouse' })
  relation: string;

  @ApiPropertyOptional()
  dateOfBirth?: Date;

  @ApiPropertyOptional({ enum: BloodGroup })
  bloodGroup?: BloodGroup;

  @ApiPropertyOptional({ enum: Gender })
  gender?: Gender;

  @ApiPropertyOptional({ example: 165 })
  height?: number;

  @ApiPropertyOptional({ example: 60 })
  weight?: number;

  @ApiPropertyOptional({ example: ['Diabetes'] })
  medicalConditions?: string[];

  @ApiPropertyOptional({ example: ['Peanuts'] })
  allergies?: string[];

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
