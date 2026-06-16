import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_nest/presentation/providers/appointment_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/presentation/widgets/common/loading_widget.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';

class AppointmentListScreen extends ConsumerWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Appointments'),
      ),
      body: appointmentState.isLoading
          ? const LoadingWidget()
          : appointmentState.appointments.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.calendar_today,
                  title: 'No Appointments Yet',
                  subtitle: 'Schedule doctor appointments here',
                  actionLabel: 'Add Appointment',
                  onAction: () =>
                      Navigator.pushNamed(context, '/appointments/add'),
                )
              : _buildAppointmentList(context, ref, appointmentState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/appointments/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentList(
    BuildContext context,
    WidgetRef ref,
    AppointmentState appointmentState,
  ) {
    final upcomingAppointments = appointmentState.upcomingAppointments;
    final pastAppointments = appointmentState.appointments
        .where((a) => a.isCompleted || a.dateTime.isBefore(DateTime.now()))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAppointmentSection(
                  context,
                  ref,
                  upcomingAppointments,
                  'No upcoming appointments',
                ),
                _buildAppointmentSection(
                  context,
                  ref,
                  pastAppointments,
                  'No past appointments',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection(
    BuildContext context,
    WidgetRef ref,
    List appointments,
    String emptyMessage,
  ) {
    if (appointments.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Dismissible(
          key: Key(appointment.id),
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
                title: const Text('Delete Appointment'),
                content: const Text(
                    'Are you sure you want to delete this appointment?'),
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
            ref
                .read(appointmentProvider.notifier)
                .deleteAppointment(appointment.id);
          },
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appointment.isCompleted
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_hospital,
                        color: appointment.isCompleted
                            ? Colors.grey
                            : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appointment.isCompleted
                                  ? Colors.grey[600]
                                  : null,
                            ),
                          ),
                          Text(
                            appointment.specialty,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!appointment.isCompleted)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () {
                          ref
                              .read(appointmentProvider.notifier)
                              .markAsCompleted(appointment.id);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      DateTimeUtils.formatDate(appointment.dateTime),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      DateTimeUtils.formatTime(appointment.dateTime),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (appointment.clinicName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appointment.clinicName!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    appointment.notes!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
