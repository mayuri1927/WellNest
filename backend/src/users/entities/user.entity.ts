import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class User {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  email: string;

  @ApiPropertyOptional()
  phone?: string;

  @ApiPropertyOptional()
  profileImage?: string;

  @ApiPropertyOptional()
  height?: number;

  @ApiPropertyOptional()
  weight?: number;

  @ApiPropertyOptional()
  fitnessGoal?: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;

  // Password should not be exposed in API responses
  password?: string;
}
