import '../../domain/repositories/document_repository.dart';
import '../datasources/document_local_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentLocalDatasource _datasource;
  DocumentRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getDocuments() async => await _datasource.getDocuments();

  @override
  Future<void> addDocument(Map<String, dynamic> document) async => await _datasource.saveDocument(document);

  @override
  Future<void> deleteDocument(String id) async => await _datasource.deleteDocument(id);
}
