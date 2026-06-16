import 'dart:io';
import '../../domain/entities/document_entity.dart';

abstract class DocumentRepository {
  Future<void> addDocument(DocumentEntity document, File? file);
  Future<void> updateDocument(DocumentEntity document, File? file);
  Future<void> deleteDocument(String id);
  Future<List<DocumentEntity>> getDocuments(String userId);
  Stream<List<DocumentEntity>> streamDocuments(String userId);
  Future<File> downloadDocument(String url, String fileName);
}
