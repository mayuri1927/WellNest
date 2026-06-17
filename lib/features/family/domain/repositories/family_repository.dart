abstract class FamilyRepository {
  Future<List<Map<String, dynamic>>> getMembers();
  Future<void> addMember(Map<String, dynamic> member);
  Future<void> deleteMember(String id);
}
