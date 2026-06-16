import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:well_nest/presentation/providers/workout_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/presentation/widgets/common/loading_widget.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';
import 'package:well_nest/core/constants/app_constants.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showCalendar(context, ref),
          ),
        ],
      ),
      body: workoutState.isLoading
          ? const LoadingWidget()
          : workoutState.workouts.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.fitness_center,
                  title: 'No Workouts Yet',
                  subtitle: 'Start tracking your workouts to see them here',
                  actionLabel: 'Add Workout',
                  onAction: () => Navigator.pushNamed(context, '/workouts/add'),
                )
              : _buildWorkoutList(context, ref, workoutState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/workouts/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutList(
    BuildContext context,
    WidgetRef ref,
    WorkoutState workoutState,
  ) {
    final workouts = workoutState.workoutsForSelectedDate;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateTimeUtils.formatDate(workoutState.selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: workouts.isEmpty
              ? const Center(child: Text('No workouts for this day'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return Dismissible(
                      key: Key(workout.id),
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
                            title: const Text('Delete Workout'),
                            content: const Text(
                                'Are you sure you want to delete this workout?'),
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
                            .read(workoutProvider.notifier)
                            .deleteWorkout(workout.id);
                      },
                      child: CustomCard(
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Colors.orange,
                            ),
                          ),
                          title: Text(
                            workout.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${workout.type} • ${workout.durationMinutes} min',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${workout.caloriesBurned}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const Text(
                                'cal',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCalendar(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                focusedDay: ref.read(workoutProvider).selectedDate,
                selectedDayPredicate: (day) {
                  return isSameDay(ref.read(workoutProvider).selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  ref.read(workoutProvider.notifier).setSelectedDate(selectedDay);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
