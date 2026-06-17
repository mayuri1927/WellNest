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
import '../providers/appointment_provider.dart';

class AppointmentListScreen extends ConsumerWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments'), actions: [IconButton(onPressed: () => context.push(AppRoutes.appointmentsAdd), icon: const Icon(Icons.add))]),
      body: appointmentState.when(
        data: (state) {
          if (state.appointments.isEmpty) {
            return EmptyStateWidget(
              title: 'No appointments',
              subtitle: 'Schedule doctor appointments',
              icon: Icons.calendar_today,
              action: ElevatedButton.icon(onPressed: () => context.push(AppRoutes.appointmentsAdd), icon: const Icon(Icons.add), label: const Text('Add Appointment')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(appointmentProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final apt = state.appointments[index];
                return CustomCard(
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Radii.md)),
                        child: const Icon(Icons.calendar_today, color: AppColors.info),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(apt.doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            if (apt.specialty != null) Text(apt.specialty!, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                            if (apt.location != null) Text(apt.location!, style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${apt.dateTime.day}/${apt.dateTime.month}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          Text('${apt.dateTime.hour}:${apt.dateTime.minute.toString().padLeft(2, '0')}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      IconButton(onPressed: () => ref.read(appointmentProvider.notifier).deleteAppointment(apt.id), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(message: error.toString(), onRetry: () => ref.invalidate(appointmentProvider)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push(AppRoutes.appointmentsAdd), child: const Icon(Icons.add)),
    );
  }
}
