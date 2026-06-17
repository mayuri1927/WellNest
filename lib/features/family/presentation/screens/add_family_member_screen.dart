import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/family_provider.dart';

class AddFamilyMemberScreen extends ConsumerStatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  ConsumerState<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends ConsumerState<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _bloodTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;
    final member = FamilyMember(
      id: 'member_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      relation: _relationController.text,
      bloodType: _bloodTypeController.text.isNotEmpty ? _bloodTypeController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: DateTime.now(),
    );
    await ref.read(familyProvider.notifier).addMember(member);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Family Member'), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Member Information'),
            AppTextField(controller: _nameController, label: 'Full Name', hint: 'Enter name', prefixIcon: Icons.person, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _relationController, label: 'Relation', hint: 'e.g., Spouse, Child, Parent', prefixIcon: Icons.family_restroom, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _bloodTypeController, label: 'Blood Type (optional)', hint: 'e.g., A+, B+', prefixIcon: Icons.bloodtype),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _notesController, label: 'Notes (optional)', hint: 'Any medical conditions or allergies', maxLines: 3),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(text: 'Save Member', isFullWidth: true, onPressed: _saveMember),
          ],
        ),
      ),
    );
  }
}
