import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { MedicalDocument, DocumentType } from './entities/document.entity';
import { DocumentRepository } from './repositories/document.repository';
import { CreateDocumentDto } from './dto/create-document.dto';

@Injectable()
export class DocumentsService {
  constructor(private documentRepository: DocumentRepository) {}

  async create(userId: string, createDocumentDto: CreateDocumentDto): Promise<MedicalDocument> {
    const document: MedicalDocument = {
      id: uuidv4(),
      userId,
      familyMemberId: createDocumentDto.familyMemberId,
      title: createDocumentDto.title,
      documentType: createDocumentDto.documentType,
      fileUrl: createDocumentDto.fileUrl,
      fileName: createDocumentDto.fileName,
      fileSize: createDocumentDto.fileSize,
      mimeType: createDocumentDto.mimeType,
      notes: createDocumentDto.notes,
      uploadedAt: new Date(),
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.documentRepository.create(document);
  }

  async findAll(userId: string): Promise<MedicalDocument[]> {
    return this.documentRepository.findByUserId(userId);
  }

  async findOne(userId: string, documentId: string): Promise<MedicalDocument> {
    const document = await this.documentRepository.findById(documentId);
    if (!document || document.userId !== userId) {
      throw new NotFoundException('Document not found');
    }
    return document;
  }

  async findByFamilyMember(
    userId: string,
    familyMemberId: string,
  ): Promise<MedicalDocument[]> {
    const documents = await this.documentRepository.findByUserId(userId);
    return documents.filter((doc) => doc.familyMemberId === familyMemberId);
  }

  async findByType(
    userId: string,
    documentType: DocumentType,
  ): Promise<MedicalDocument[]> {
    const documents = await this.documentRepository.findByUserId(userId);
    return documents.filter((doc) => doc.documentType === documentType);
  }

  async remove(userId: string, documentId: string): Promise<void> {
    await this.findOne(userId, documentId);
    await this.documentRepository.delete(documentId);
  }

  async getDocumentStats(userId: string) {
    const documents = await this.documentRepository.findByUserId(userId);

    const documentsByType: Record<string, number> = {};
    documents.forEach((doc) => {
      documentsByType[doc.documentType] = (documentsByType[doc.documentType] || 0) + 1;
    });

    return {
      totalDocuments: documents.length,
      totalSize: documents.reduce((sum, doc) => sum + (doc.fileSize || 0), 0),
      documentsByType,
    };
  }
}
