import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class DocumentLocalDatasource {
  Future<List<Map<String, dynamic>>> getDocuments();
  Future<void> saveDocument(Map<String, dynamic> document);
  Future<void> deleteDocument(String id);
}

class DocumentLocalDatasourceImpl implements DocumentLocalDatasource {
  late Box _box;
  DocumentLocalDatasourceImpl() { _box = Hive.box('documents'); }

  @override
  Future<List<Map<String, dynamic>>> getDocuments() async {
    final data = _box.get('documents', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveDocument(Map<String, dynamic> document) async {
    final documents = await getDocuments();
    documents.add(document);
    await _box.put('documents', documents);
  }

  @override
  Future<void> deleteDocument(String id) async {
    final documents = await getDocuments();
    documents.removeWhere((d) => d['id'] == id);
    await _box.put('documents', documents);
  }
}

final documentLocalDatasourceProvider = Provider<DocumentLocalDatasource>((ref) => DocumentLocalDatasourceImpl());
