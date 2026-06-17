import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: () => context.push(AppRoutes.settings), icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          children: [
            const SizedBox(height: Spacing.lg),
            ProfileAvatar(
              name: authState.value?.userName ?? 'User',
              size: 100,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              authState.value?.userName ?? 'User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              authState.value?.userEmail ?? '',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: Spacing.xl),
            CustomCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                    child: const Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                  const SizedBox(width: Spacing.md),
                  const Expanded(child: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
            CustomCard(
              onTap: () => context.push(AppRoutes.settings),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                    child: const Icon(Icons.notifications_outlined, color: AppColors.secondary),
                  ),
                  const SizedBox(width: Spacing.md),
                  const Expanded(child: Text('Notification Settings', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
            CustomCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                    child: const Icon(Icons.privacy_tip_outlined, color: AppColors.warning),
                  ),
                  const SizedBox(width: Spacing.md),
                  const Expanded(child: Text('Privacy Settings', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
            CustomCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                    child: const Icon(Icons.help_outline, color: AppColors.info),
                  ),
                  const SizedBox(width: Spacing.md),
                  const Expanded(child: Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: Spacing.xxl),
          ],
        ),
      ),
    );
  }
}
