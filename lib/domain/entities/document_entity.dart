import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String type;
  final String fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final DateTime? expiryDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.expiryDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        type,
        fileUrl,
        fileName,
        fileSize,
        mimeType,
        expiryDate,
        notes,
        createdAt,
        updatedAt,
      ];

  DocumentEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    DateTime? expiryDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
