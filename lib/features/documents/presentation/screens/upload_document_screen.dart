import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/enums/app_enums.dart';
import '../providers/document_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class UploadDocumentScreen extends ConsumerStatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  ConsumerState<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends ConsumerState<UploadDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DocumentType _selectedType = DocumentType.other;
  String? _selectedFileName;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;
    final authState = ref.read(authProvider);
    final document = Document(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      userId: authState.value?.userId ?? '',
      title: _titleController.text,
      documentType: _selectedType.label,
      fileName: _selectedFileName,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      uploadedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await ref.read(documentProvider.notifier).addDocument(document);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document'), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SectionHeader(title: 'Document Information'),
            AppTextField(controller: _titleController, label: 'Document Title', hint: 'Enter title', prefixIcon: Icons.title, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: Spacing.md),
            const SectionHeader(title: 'Document Type'),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: DocumentType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedType = type);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.md),
            InkWell(
              onTap: () => setState(() => _selectedFileName = 'sample_document.pdf'),
              child: Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: Column(
                  children: [
                    Icon(_selectedFileName != null ? Icons.check_circle : Icons.cloud_upload, size: 48, color: _selectedFileName != null ? AppColors.success : AppColors.textTertiary),
                    const SizedBox(height: Spacing.sm),
                    Text(_selectedFileName ?? 'Tap to select file', style: TextStyle(color: _selectedFileName != null ? AppColors.success : AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(controller: _notesController, label: 'Notes (optional)', hint: 'Any additional notes', maxLines: 3),
            const SizedBox(height: Spacing.xl),
            PrimaryButton(text: 'Upload Document', isFullWidth: true, onPressed: _saveDocument),
          ],
        ),
      ),
    );
  }
}
