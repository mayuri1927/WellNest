import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FamilyLocalDatasource {
  Future<List<Map<String, dynamic>>> getMembers();
  Future<void> saveMember(Map<String, dynamic> member);
  Future<void> deleteMember(String id);
}

class FamilyLocalDatasourceImpl implements FamilyLocalDatasource {
  late Box _box;
  FamilyLocalDatasourceImpl() { _box = Hive.box('family'); }

  @override
  Future<List<Map<String, dynamic>>> getMembers() async {
    final data = _box.get('members', defaultValue: []);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<void> saveMember(Map<String, dynamic> member) async {
    final members = await getMembers();
    members.add(member);
    await _box.put('members', members);
  }

  @override
  Future<void> deleteMember(String id) async {
    final members = await getMembers();
    members.removeWhere((m) => m['id'] == id);
    await _box.put('members', members);
  }
}

final familyLocalDatasourceProvider = Provider<FamilyLocalDatasource>((ref) => FamilyLocalDatasourceImpl());
