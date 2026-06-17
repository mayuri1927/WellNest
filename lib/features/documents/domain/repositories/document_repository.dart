abstract class DocumentRepository {
  Future<List<Map<String, dynamic>>> getDocuments();
  Future<void> addDocument(Map<String, dynamic> document);
  Future<void> deleteDocument(String id);
}
