import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { DocumentsService } from './documents.service';
import { CreateDocumentDto } from './dto/create-document.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('documents')
@Controller('documents')
@UseGuards(Auth)
@ApiBearerAuth('JWT-auth')
export class DocumentsController {
  constructor(private readonly documentsService: DocumentsService) {}

  @Post()
  @ApiOperation({ summary: 'Upload a new document' })
  async create(
    @CurrentUser('sub') userId: string,
    @Body() createDocumentDto: CreateDocumentDto,
  ) {
    return this.documentsService.create(userId, createDocumentDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all documents' })
  async findAll(@CurrentUser('sub') userId: string) {
    return this.documentsService.findAll(userId);
  }

  @Get('stats')
  @ApiOperation({ summary: 'Get document statistics' })
  async getDocumentStats(@CurrentUser('sub') userId: string) {
    return this.documentsService.getDocumentStats(userId);
  }

  @Get('by-type/:type')
  @ApiOperation({ summary: 'Get documents by type' })
  async findByType(
    @CurrentUser('sub') userId: string,
    @Param('type') type: string,
  ) {
    return this.documentsService.findByType(userId, type as any);
  }

  @Get('family/:familyMemberId')
  @ApiOperation({ summary: 'Get documents for family member' })
  async findByFamilyMember(
    @CurrentUser('sub') userId: string,
    @Param('familyMemberId') familyMemberId: string,
  ) {
    return this.documentsService.findByFamilyMember(userId, familyMemberId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get document by ID' })
  async findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    return this.documentsService.findOne(userId, id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete document' })
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ) {
    await this.documentsService.remove(userId, id);
    return { message: 'Document deleted successfully' };
  }
}
