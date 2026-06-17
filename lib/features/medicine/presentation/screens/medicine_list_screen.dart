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
import '../providers/medicine_provider.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Medicines'), actions: [IconButton(onPressed: () => context.push(AppRoutes.medicinesAdd), icon: const Icon(Icons.add))]),
      body: medicineState.when(
        data: (state) {
          if (state.medicines.isEmpty) {
            return EmptyStateWidget(
              title: 'No medicines',
              subtitle: 'Add medicines to set reminders',
              icon: Icons.medication,
              action: ElevatedButton.icon(onPressed: () => context.push(AppRoutes.medicinesAdd), icon: const Icon(Icons.add), label: const Text('Add Medicine')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(medicineProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.medicines.length,
              itemBuilder: (context, index) {
                final medicine = state.medicines[index];
                return CustomCard(
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                        child: const Icon(Icons.medication, color: AppColors.warning),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${medicine.dosage} ${medicine.unit}', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                            if (medicine.frequency != null) Text(medicine.frequency!, style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: medicine.isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(medicine.isActive ? 'Active' : 'Inactive', style: TextStyle(color: medicine.isActive ? AppColors.success : AppColors.error, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                      IconButton(onPressed: () => ref.read(medicineProvider.notifier).deleteMedicine(medicine.id), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(message: error.toString(), onRetry: () => ref.invalidate(medicineProvider)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push(AppRoutes.medicinesAdd), child: const Icon(Icons.add)),
    );
  }
}
