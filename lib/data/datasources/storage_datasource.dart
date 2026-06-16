import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/errors/exceptions.dart';

abstract class StorageDataSource {
  Future<String> uploadFile(File file, String path);
  Future<void> deleteFile(String path);
  Future<String> getFileUrl(String path);
  Future<File> downloadFile(String url, String fileName);
}

class StorageDataSourceImpl implements StorageDataSource {
  final FirebaseStorage _storage;

  StorageDataSourceImpl({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(message: 'Failed to upload file: $e');
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw StorageException(message: 'Failed to delete file: $e');
    }
  }

  @override
  Future<String> getFileUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException(message: 'Failed to get file URL: $e');
    }
  }

  @override
  Future<File> downloadFile(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        return file;
      }
      
      final response = await HttpClient().getUrl(Uri.parse(url));
      final httpFile = await response.close();
      await httpFile.pipe(file.openWrite());
      
      return file;
    } catch (e) {
      throw StorageException(message: 'Failed to download file: $e');
    }
  }
}
