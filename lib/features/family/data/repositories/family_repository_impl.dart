import '../../domain/repositories/family_repository.dart';
import '../datasources/family_local_datasource.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyLocalDatasource _datasource;
  FamilyRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getMembers() async => await _datasource.getMembers();

  @override
  Future<void> addMember(Map<String, dynamic> member) async => await _datasource.saveMember(member);

  @override
  Future<void> deleteMember(String id) async => await _datasource.deleteMember(id);
}
