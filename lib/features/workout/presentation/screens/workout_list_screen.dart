import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/loading_error.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/extensions/extensions.dart';
import '../providers/workout_provider.dart';
import '../../../../app/routes/app_router.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.workoutAdd),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: workoutState.when(
        data: (state) {
          if (state.workouts.isEmpty) {
            return EmptyStateWidget(
              title: 'No workouts yet',
              subtitle: 'Start tracking your fitness journey',
              icon: Icons.fitness_center,
              action: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.workoutAdd),
                icon: const Icon(Icons.add),
                label: const Text('Add Workout'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(workoutProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                final workout = state.workouts[index];
                return CustomCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Radii.md),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workout.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${workout.duration} min • ${workout.caloriesBurned} cal',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            if (workout.notes != null && workout.notes!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                workout.notes!,
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${workout.date.day}/${workout.date.month}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(workoutProvider.notifier)
                                  .deleteWorkout(workout.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(workoutProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.workoutAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}
