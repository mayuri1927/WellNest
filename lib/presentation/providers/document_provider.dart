import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/document_entity.dart';
import 'providers.dart';
import 'auth_provider.dart';

class DocumentState {
  final List<DocumentEntity> documents;
  final bool isLoading;
  final String? errorMessage;

  DocumentState({
    this.documents = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DocumentState copyWith({
    List<DocumentEntity>? documents,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DocumentState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DocumentNotifier extends StateNotifier<DocumentState> {
  final Ref _ref;

  DocumentNotifier(this._ref) : super(DocumentState()) {
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final documents = await _ref.read(documentRepositoryProvider).getDocuments(user.id);
        state = state.copyWith(documents: documents, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addDocument({
    required String title,
    required String type,
    required String fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    DateTime? expiryDate,
    String? notes,
    File? file,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        final document = DocumentEntity(
          id: const Uuid().v4(),
          userId: user.id,
          title: title,
          type: type,
          fileUrl: fileUrl,
          fileName: fileName,
          fileSize: fileSize,
          mimeType: mimeType,
          expiryDate: expiryDate,
          notes: notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _ref.read(documentRepositoryProvider).addDocument(document, file);
        await loadDocuments();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateDocument(DocumentEntity document, {File? file}) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(documentRepositoryProvider).updateDocument(document, file);
      await loadDocuments();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteDocument(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _ref.read(documentRepositoryProvider).deleteDocument(id);
      await loadDocuments();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<File> downloadDocument(String url, String fileName) async {
    return await _ref.read(documentRepositoryProvider).downloadDocument(url, fileName);
  }
}

final documentProvider = StateNotifierProvider<DocumentNotifier, DocumentState>((ref) {
  return DocumentNotifier(ref);
});
