import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_local_datasource.dart';
import '../datasources/document_remote_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDatasource _remoteDatasource;
  final DocumentLocalDatasource _localDatasource;

  DocumentRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      return await _remoteDatasource.getDocuments();
    } catch (e) {
      return await _localDatasource.getDocuments();
    }
  }

  @override
  Future<void> addDocument(Map<String, dynamic> document) async {
    try {
      await _remoteDatasource.createDocument(document);
    } catch (e) {
      await _localDatasource.saveDocument(document);
      rethrow;
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    try {
      await _remoteDatasource.deleteDocument(id);
    } catch (e) {
      await _localDatasource.deleteDocument(id);
      rethrow;
    }
  }
}

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final remoteDatasource = ref.watch(documentRemoteDatasourceProvider);
  final localDatasource = ref.watch(documentLocalDatasourceProvider);
  return DocumentRepositoryImpl(remoteDatasource, localDatasource);
});
