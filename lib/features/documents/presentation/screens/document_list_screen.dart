import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/loading_error.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/extensions/extensions.dart';
import '../providers/document_provider.dart';

class DocumentListScreen extends ConsumerWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentState = ref.watch(documentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Documents'), actions: [IconButton(onPressed: () => context.push(AppRoutes.documentsUpload), icon: const Icon(Icons.add))]),
      body: documentState.when(
        data: (state) {
          if (state.documents.isEmpty) {
            return EmptyStateWidget(
              title: 'No documents',
              subtitle: 'Upload medical documents securely',
              icon: Icons.folder,
              action: ElevatedButton.icon(onPressed: () => context.push(AppRoutes.documentsUpload), icon: const Icon(Icons.add), label: const Text('Upload Document')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(documentProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.documents.length,
              itemBuilder: (context, index) {
                final doc = state.documents[index];
                return CustomCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                        child: Icon(_getDocumentIcon(doc.documentType), color: AppColors.primary),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(doc.documentType, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                            Text('${doc.uploadedAt.day}/${doc.uploadedAt.month}/${doc.uploadedAt.year}', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => ref.read(documentProvider.notifier).deleteDocument(doc.id), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(message: error.toString(), onRetry: () => ref.invalidate(documentProvider)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push(AppRoutes.documentsUpload), child: const Icon(Icons.add)),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'prescription': return Icons.description;
      case 'medical report': return Icons.article;
      case 'lab results': return Icons.science;
      case 'insurance': return Icons.health_and_safety;
      default: return Icons.insert_drive_file;
    }
  }
}
