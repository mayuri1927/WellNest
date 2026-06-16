import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_nest/presentation/providers/document_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/presentation/widgets/common/loading_widget.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';
import 'package:well_nest/core/constants/app_constants.dart';

class DocumentListScreen extends ConsumerWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentState = ref.watch(documentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Documents'),
      ),
      body: documentState.isLoading
          ? const LoadingWidget()
          : documentState.documents.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.folder,
                  title: 'No Documents Yet',
                  subtitle: 'Upload medical documents to keep them safe',
                  actionLabel: 'Add Document',
                  onAction: () => Navigator.pushNamed(context, '/documents/add'),
                )
              : _buildDocumentList(context, ref, documentState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/documents/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentList(
    BuildContext context,
    WidgetRef ref,
    DocumentState documentState,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documentState.documents.length,
      itemBuilder: (context, index) {
        final document = documentState.documents[index];
        return Dismissible(
          key: Key(document.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Document'),
                content: const Text(
                    'Are you sure you want to delete this document?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            ref.read(documentProvider.notifier).deleteDocument(document.id);
          },
          child: CustomCard(
            onTap: () => _showDocumentOptions(context, ref, document),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getDocumentTypeColor(document.type)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getDocumentTypeIcon(document.type),
                        color: _getDocumentTypeColor(document.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            document.type,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Added: ${DateTimeUtils.formatDate(document.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (document.expiryDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.event, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Expires: ${DateTimeUtils.formatDate(document.expiryDate!)}',
                        style: TextStyle(
                          color: _isExpiringSoon(document.expiryDate!)
                              ? Colors.red
                              : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                if (document.notes != null && document.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    document.notes!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'Prescription':
        return Icons.description;
      case 'Medical Report':
        return Icons.summarize;
      case 'Lab Results':
        return Icons.science;
      case 'Insurance':
        return Icons.health_and_safety;
      case 'ID Proof':
        return Icons.badge;
      default:
        return Icons.folder;
    }
  }

  Color _getDocumentTypeColor(String type) {
    switch (type) {
      case 'Prescription':
        return Colors.blue;
      case 'Medical Report':
        return Colors.green;
      case 'Lab Results':
        return Colors.orange;
      case 'Insurance':
        return Colors.purple;
      case 'ID Proof':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  bool _isExpiringSoon(DateTime expiryDate) {
    return expiryDate.isBefore(DateTime.now().add(const Duration(days: 30)));
  }

  void _showDocumentOptions(
      BuildContext context, WidgetRef ref, dynamic document) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Document'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(documentProvider.notifier).deleteDocument(document.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
