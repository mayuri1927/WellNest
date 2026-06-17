import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/repositories/family_repository_impl.dart';

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

  Future<void> fetchMembers() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(familyRepositoryProvider);
      final data = await repository.getMembers();
      final members = data.map((m) => FamilyMember(
        id: m['id'] ?? '',
        name: m['name'] ?? '',
        relation: m['relation'] ?? '',
        bloodType: m['bloodType'] ?? m['bloodGroup'],
        dateOfBirth: m['dateOfBirth']?.toString(),
        notes: m['notes'],
        createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt']) : DateTime.now(),
      )).toList();
      state = AsyncValue.data(FamilyState(members: members));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> addMember(FamilyMember member) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(familyRepositoryProvider);
      await repository.addMember({
        'id': member.id,
        'name': member.name,
        'relation': member.relation,
        'bloodType': member.bloodType,
        'dateOfBirth': member.dateOfBirth,
        'notes': member.notes,
        'createdAt': member.createdAt.toIso8601String(),
      });
      await fetchMembers();
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }

  Future<void> deleteMember(String id) async {
    try {
      final repository = ref.read(familyRepositoryProvider);
      await repository.deleteMember(id);
      final currentMembers = state.value?.members ?? [];
      final newMembers = currentMembers.where((m) => m.id != id).toList();
      state = AsyncValue.data(FamilyState(members: newMembers));
    } catch (e, st) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), st);
    }
  }
}

final familyProvider = AsyncNotifierProvider<FamilyNotifier, FamilyState>(() => FamilyNotifier());
