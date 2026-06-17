import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DocumentState {
  final List<Document> documents;
  final bool isLoading;
  final String? error;

  const DocumentState({this.documents = const [], this.isLoading = false, this.error});

  DocumentState copyWith({List<Document>? documents, bool? isLoading, String? error}) {
    return DocumentState(documents: documents ?? this.documents, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class Document {
  final String id;
  final String userId;
  final String title;
  final String documentType;
  final String? fileUrl;
  final String? fileName;
  final String? notes;
  final DateTime uploadedAt;
  final DateTime createdAt;

  Document({required this.id, required this.userId, required this.title, required this.documentType, this.fileUrl, this.fileName, this.notes, required this.uploadedAt, required this.createdAt});
}

class DocumentNotifier extends AsyncNotifier<DocumentState> {
  late Box _box;

  @override
  Future<DocumentState> build() async {
    _box = Hive.box('documents');
    return _loadDocuments();
  }

  DocumentState _loadDocuments() {
    final data = _box.get('documents', defaultValue: []);
    if (data is List) {
      final documents = data.map((d) {
        if (d is Map) {
          return Document(
            id: d['id'] ?? '', userId: d['userId'] ?? '', title: d['title'] ?? '', documentType: d['documentType'] ?? 'Other',
            fileUrl: d['fileUrl'], fileName: d['fileName'], notes: d['notes'],
            uploadedAt: d['uploadedAt'] != null ? DateTime.parse(d['uploadedAt']) : DateTime.now(),
            createdAt: d['createdAt'] != null ? DateTime.parse(d['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<Document>().toList();
      return DocumentState(documents: documents);
    }
    return const DocumentState();
  }

  Future<void> addDocument(Document document) async {
    state = const AsyncValue.loading();
    try {
      final current = state.value?.documents ?? [];
      final newList = [...current, document];
      await _box.put('documents', newList.map((d) => {'id': d.id, 'userId': d.userId, 'title': d.title, 'documentType': d.documentType, 'fileUrl': d.fileUrl, 'fileName': d.fileName, 'notes': d.notes, 'uploadedAt': d.uploadedAt.toIso8601String(), 'createdAt': d.createdAt.toIso8601String()}).toList());
      state = AsyncValue.data(DocumentState(documents: newList));
    } catch (e, st) { state = AsyncValue.error(e.toString(), st); }
  }

  Future<void> deleteDocument(String id) async {
    final current = state.value?.documents ?? [];
    final newList = current.where((d) => d.id != id).toList();
    await _box.put('documents', newList.map((d) => {'id': d.id, 'userId': d.userId, 'title': d.title, 'documentType': d.documentType, 'fileUrl': d.fileUrl, 'fileName': d.fileName, 'notes': d.notes, 'uploadedAt': d.uploadedAt.toIso8601String(), 'createdAt': d.createdAt.toIso8601String()}).toList());
    state = AsyncValue.data(DocumentState(documents: newList));
  }
}

final documentProvider = AsyncNotifierProvider<DocumentNotifier, DocumentState>(() => DocumentNotifier());
