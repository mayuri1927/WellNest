import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FamilyState {
  final List<FamilyMember> members;
  final bool isLoading;
  final String? error;

  const FamilyState({this.members = const [], this.isLoading = false, this.error});

  FamilyState copyWith({List<FamilyMember>? members, bool? isLoading, String? error}) {
    return FamilyState(members: members ?? this.members, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String? bloodType;
  final String? dateOfBirth;
  final String? notes;
  final DateTime createdAt;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    this.bloodType,
    this.dateOfBirth,
    this.notes,
    required this.createdAt,
  });
}

class FamilyNotifier extends AsyncNotifier<FamilyState> {
  late Box _box;

  @override
  Future<FamilyState> build() async {
    _box = Hive.box('family');
    return _loadMembers();
  }

  FamilyState _loadMembers() {
    final data = _box.get('members', defaultValue: []);
    if (data is List) {
      final members = data.map((m) {
        if (m is Map) {
          return FamilyMember(
            id: m['id'] ?? '',
            name: m['name'] ?? '',
            relation: m['relation'] ?? '',
            bloodType: m['bloodType'],
            dateOfBirth: m['dateOfBirth'],
            notes: m['notes'],
            createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt']) : DateTime.now(),
          );
        }
        return null;
      }).whereType<FamilyMember>().toList();
      return FamilyState(members: members);
    }
    return const FamilyState();
  }

  Future<void> addMember(FamilyMember member) async {
    state = const AsyncValue.loading();
    try {
      final currentMembers = state.value?.members ?? [];
      final newMembers = [...currentMembers, member];
      await _box.put('members', newMembers.map((m) => {'id': m.id, 'name': m.name, 'relation': m.relation, 'bloodType': m.bloodType, 'dateOfBirth': m.dateOfBirth, 'notes': m.notes, 'createdAt': m.createdAt.toIso8601String()}).toList());
      state = AsyncValue.data(FamilyState(members: newMembers));
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> deleteMember(String id) async {
    final currentMembers = state.value?.members ?? [];
    final newMembers = currentMembers.where((m) => m.id != id).toList();
    await _box.put('members', newMembers.map((m) => {'id': m.id, 'name': m.name, 'relation': m.relation, 'bloodType': m.bloodType, 'dateOfBirth': m.dateOfBirth, 'notes': m.notes, 'createdAt': m.createdAt.toIso8601String()}).toList());
    state = AsyncValue.data(FamilyState(members: newMembers));
  }
}

final familyProvider = AsyncNotifierProvider<FamilyNotifier, FamilyState>(() => FamilyNotifier());
