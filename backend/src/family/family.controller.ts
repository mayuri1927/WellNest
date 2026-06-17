import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { FamilyService } from './family.service';
import { CreateFamilyMemberDto } from './dto/create-family-member.dto';
import { UpdateFamilyMemberDto } from './dto/update-family-member.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('family')
@Controller('family')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class FamilyController {
  constructor(private readonly familyService: FamilyService) {}

  @Post()
  @ApiOperation({ summary: 'Add a family member' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createFamilyMemberDto: CreateFamilyMemberDto,
  ) {
    return this.familyService.create(userId, createFamilyMemberDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all family members' })
  async findAll(@CurrentUser('sub') userId: string) {
    return this.familyService.findAll(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get family member by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.familyService.findOne(userId, id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update family member' })
  async update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() updateFamilyMemberDto: UpdateFamilyMemberDto,
  ) {
    return this.familyService.update(userId, id, updateFamilyMemberDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Remove family member' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.familyService.remove(userId, id);
    return { message: 'Family member removed successfully' };
  }
}
