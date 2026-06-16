import '../../domain/entities/family_member_entity.dart';
import '../../domain/repositories/family_member_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/family_member_model.dart';

class FamilyMemberRepositoryImpl implements FamilyMemberRepository {
  final FamilyMemberDataSource _familyMemberDataSource;

  FamilyMemberRepositoryImpl({required FamilyMemberDataSource familyMemberDataSource})
      : _familyMemberDataSource = familyMemberDataSource;

  @override
  Future<void> addFamilyMember(FamilyMemberEntity member) async {
    final model = FamilyMemberModel.fromEntity(member);
    await _familyMemberDataSource.addFamilyMember(model);
  }

  @override
  Future<void> updateFamilyMember(FamilyMemberEntity member) async {
    final model = FamilyMemberModel.fromEntity(member);
    await _familyMemberDataSource.updateFamilyMember(member.id, model);
  }

  @override
  Future<void> deleteFamilyMember(String id) async {
    await _familyMemberDataSource.deleteFamilyMember(id);
  }

  @override
  Future<List<FamilyMemberEntity>> getFamilyMembers(String userId) async {
    final models = await _familyMemberDataSource.getFamilyMembers(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<FamilyMemberEntity>> streamFamilyMembers(String userId) {
    return _familyMemberDataSource.streamFamilyMembers(userId).map(
        (models) => models.map((m) => m.toEntity()).toList());
  }
}
