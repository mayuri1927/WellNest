import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_nest/presentation/providers/auth_provider.dart';
import 'package:well_nest/presentation/providers/workout_provider.dart';
import 'package:well_nest/presentation/providers/meal_provider.dart';
import 'package:well_nest/presentation/providers/medicine_provider.dart';
import 'package:well_nest/presentation/providers/appointment_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final workoutState = ref.watch(workoutProvider);
    final mealState = ref.watch(mealProvider);
    final medicineState = ref.watch(medicineProvider);
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WellNest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(workoutProvider.notifier).loadWorkouts(),
            ref.read(mealProvider.notifier).loadMeals(),
            ref.read(medicineProvider.notifier).loadMedicines(),
            ref.read(appointmentProvider.notifier).loadAppointments(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(context, authState.user?.displayName ?? 'User'),
              const SizedBox(height: 24),
              _buildDateSelector(context, ref),
              const SizedBox(height: 24),
              _buildTodaySummary(context, ref, workoutState, mealState, medicineState, appointmentState),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildUpcomingAppointments(context, appointmentState),
              const SizedBox(height: 24),
              _buildActiveMedicines(context, medicineState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(workoutProvider).selectedDate;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(workoutProvider.notifier).setSelectedDate(
                    selectedDate.subtract(const Duration(days: 1)),
                  );
            },
          ),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                ref.read(workoutProvider.notifier).setSelectedDate(date);
              }
            },
            child: Text(
              DateTimeUtils.formatDate(selectedDate),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(workoutProvider.notifier).setSelectedDate(
                    selectedDate.add(const Duration(days: 1)),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary(
    BuildContext context,
    WidgetRef ref,
    WorkoutState workoutState,
    MealState mealState,
    MedicineState medicineState,
    AppointmentState appointmentState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Summary",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Workouts',
                workoutState.workoutsForSelectedDate.length.toString(),
                Icons.fitness_center,
                Colors.orange,
                () => Navigator.pushNamed(context, '/workouts'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Calories',
                mealState.totalCaloriesForSelectedDate.toString(),
                Icons.restaurant,
                Colors.red,
                () => Navigator.pushNamed(context, '/meals'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Medicines',
                medicineState.activeMedicines.length.toString(),
                Icons.medication,
                Colors.blue,
                () => Navigator.pushNamed(context, '/medicines'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Appointments',
                appointmentState.todayAppointments.length.toString(),
                Icons.calendar_today,
                Colors.green,
                () => Navigator.pushNamed(context, '/appointments'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionButton(
              context,
              'Add Workout',
              Icons.add,
              () => Navigator.pushNamed(context, '/workouts/add'),
            ),
            _buildQuickActionButton(
              context,
              'Add Meal',
              Icons.add,
              () => Navigator.pushNamed(context, '/meals/add'),
            ),
            _buildQuickActionButton(
              context,
              'Add Medicine',
              Icons.add,
              () => Navigator.pushNamed(context, '/medicines/add'),
            ),
            _buildQuickActionButton(
              context,
              'Documents',
              Icons.folder,
              () => Navigator.pushNamed(context, '/documents'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments(
    BuildContext context,
    AppointmentState appointmentState,
  ) {
    final upcomingAppointments = appointmentState.upcomingAppointments.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Appointments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/appointments'),
              child: const Text('See All'),
            ),
          ],
        ),
        if (upcomingAppointments.isEmpty)
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No upcoming appointments',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...upcomingAppointments.map((appointment) => CustomCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colors.green),
                  ),
                  title: Text(appointment.doctorName),
                  subtitle: Text(
                    '${appointment.specialty} - ${DateTimeUtils.formatDateTime(appointment.dateTime)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
      ],
    );
  }

  Widget _buildActiveMedicines(
    BuildContext context,
    MedicineState medicineState,
  ) {
    final activeMedicines = medicineState.activeMedicines.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Medicines',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/medicines'),
              child: const Text('See All'),
            ),
          ],
        ),
        if (activeMedicines.isEmpty)
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No active medicines',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...activeMedicines.map((medicine) => CustomCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.medication, color: Colors.blue),
                  ),
                  title: Text(medicine.name),
                  subtitle: Text('${medicine.dosage} ${medicine.unit}'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
      ],
    );
  }
}
