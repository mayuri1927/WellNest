import '../../domain/entities/family_member_entity.dart';

abstract class FamilyMemberRepository {
  Future<void> addFamilyMember(FamilyMemberEntity member);
  Future<void> updateFamilyMember(FamilyMemberEntity member);
  Future<void> deleteFamilyMember(String id);
  Future<List<FamilyMemberEntity>> getFamilyMembers(String userId);
  Stream<List<FamilyMemberEntity>> streamFamilyMembers(String userId);
}
