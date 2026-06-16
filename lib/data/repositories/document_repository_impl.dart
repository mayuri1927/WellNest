import 'dart:io';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/storage_datasource.dart';
import '../models/document_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentDataSource _documentDataSource;
  final StorageDataSource _storageDataSource;

  DocumentRepositoryImpl({
    required DocumentDataSource documentDataSource,
    required StorageDataSource storageDataSource,
  })  : _documentDataSource = documentDataSource,
        _storageDataSource = storageDataSource;

  @override
  Future<void> addDocument(DocumentEntity document, File? file) async {
    String fileUrl = document.fileUrl;
    
    if (file != null) {
      final path = 'documents/${document.userId}/${file.path.split('/').last}';
      fileUrl = await _storageDataSource.uploadFile(file, path);
    }

    final model = DocumentModel(
      id: document.id,
      userId: document.userId,
      title: document.title,
      type: document.type,
      fileUrl: fileUrl,
      fileName: document.fileName,
      fileSize: document.fileSize,
      mimeType: document.mimeType,
      expiryDate: document.expiryDate,
      notes: document.notes,
      createdAt: document.createdAt,
      updatedAt: document.updatedAt,
    );
    await _documentDataSource.addDocument(model);
  }

  @override
  Future<void> updateDocument(DocumentEntity document, File? file) async {
    String fileUrl = document.fileUrl;

    if (file != null) {
      final path = 'documents/${document.userId}/${file.path.split('/').last}';
      fileUrl = await _storageDataSource.uploadFile(file, path);
    }

    final model = DocumentModel(
      id: document.id,
      userId: document.userId,
      title: document.title,
      type: document.type,
      fileUrl: fileUrl,
      fileName: document.fileName,
      fileSize: document.fileSize,
      mimeType: document.mimeType,
      expiryDate: document.expiryDate,
      notes: document.notes,
      createdAt: document.createdAt,
      updatedAt: document.updatedAt,
    );
    await _documentDataSource.updateDocument(document.id, model);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _documentDataSource.deleteDocument(id);
  }

  @override
  Future<List<DocumentEntity>> getDocuments(String userId) async {
    final models = await _documentDataSource.getDocuments(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<DocumentEntity>> streamDocuments(String userId) {
    return _documentDataSource.streamDocuments(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<File> downloadDocument(String url, String fileName) async {
    return await _storageDataSource.downloadFile(url, fileName);
  }
}
