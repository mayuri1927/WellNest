import { MedicalDocument } from '../entities/document.entity';

export class DocumentRepository {
  private documents: Map<string, MedicalDocument> = new Map();
  private userIndex: Map<string, string[]> = new Map();

  async create(document: MedicalDocument): Promise<MedicalDocument> {
    this.documents.set(document.id, document);
    const userDocs = this.userIndex.get(document.userId) || [];
    userDocs.push(document.id);
    this.userIndex.set(document.userId, userDocs);
    return document;
  }

  async findById(id: string): Promise<MedicalDocument | null> {
    return this.documents.get(id) || null;
  }

  async findByUserId(userId: string): Promise<MedicalDocument[]> {
    const documentIds = this.userIndex.get(userId) || [];
    return documentIds
      .map((id) => this.documents.get(id))
      .filter((d): d is MedicalDocument => d !== undefined)
      .sort((a, b) => new Date(b.uploadedAt).getTime() - new Date(a.uploadedAt).getTime());
  }

  async delete(id: string): Promise<void> {
    const document = this.documents.get(id);
    if (document) {
      const userDocs = this.userIndex.get(document.userId) || [];
      this.userIndex.set(
        document.userId,
        userDocs.filter((did) => did !== id),
      );
    }
    this.documents.delete(id);
  }
}
