import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasources/family_local_datasource.dart';
import '../datasources/family_remote_datasource.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyRemoteDatasource _remoteDatasource;
  final FamilyLocalDatasource _localDatasource;

  FamilyRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Map<String, dynamic>>> getMembers() async {
    try {
      return await _remoteDatasource.getFamilyMembers();
    } catch (e) {
      return await _localDatasource.getMembers();
    }
  }

  @override
  Future<void> addMember(Map<String, dynamic> member) async {
    try {
      await _remoteDatasource.createFamilyMember(member);
    } catch (e) {
      await _localDatasource.saveMember(member);
      rethrow;
    }
  }

  @override
  Future<void> deleteMember(String id) async {
    try {
      await _remoteDatasource.deleteFamilyMember(id);
    } catch (e) {
      await _localDatasource.deleteMember(id);
      rethrow;
    }
  }
}

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  final remoteDatasource = ref.watch(familyRemoteDatasourceProvider);
  final localDatasource = ref.watch(familyLocalDatasourceProvider);
  return FamilyRepositoryImpl(remoteDatasource, localDatasource);
});
