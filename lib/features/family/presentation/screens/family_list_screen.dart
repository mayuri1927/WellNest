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
import '../providers/family_provider.dart';

class FamilyListScreen extends ConsumerWidget {
  const FamilyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyState = ref.watch(familyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Family Members'), actions: [IconButton(onPressed: () => context.push(AppRoutes.familyAdd), icon: const Icon(Icons.add))]),
      body: familyState.when(
        data: (state) {
          if (state.members.isEmpty) {
            return EmptyStateWidget(
              title: 'No family members',
              subtitle: 'Add your family members to track their health',
              icon: Icons.family_restroom,
              action: ElevatedButton.icon(onPressed: () => context.push(AppRoutes.familyAdd), icon: const Icon(Icons.add), label: const Text('Add Member')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(familyProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];
                return CustomCard(
                  child: Row(
                    children: [
                      ProfileAvatar(name: member.name, size: 56),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(member.relation, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                            if (member.bloodType != null) Text('Blood: ${member.bloodType}', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => ref.read(familyProvider.notifier).deleteMember(member.id), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(message: error.toString(), onRetry: () => ref.invalidate(familyProvider)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push(AppRoutes.familyAdd), child: const Icon(Icons.add)),
    );
  }
}
