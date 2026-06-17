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
import '../providers/meal_provider.dart';

class MealListScreen extends ConsumerWidget {
  const MealListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(mealProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.mealsAdd),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: mealState.when(
        data: (state) {
          if (state.meals.isEmpty) {
            return EmptyStateWidget(
              title: 'No meals logged',
              subtitle: 'Track your nutrition by adding meals',
              icon: Icons.restaurant,
              action: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.mealsAdd),
                icon: const Icon(Icons.add),
                label: const Text('Add Meal'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(mealProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return CustomCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Radii.md),
                        ),
                        child: const Icon(Icons.restaurant, color: AppColors.secondary),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              '${meal.mealType} • ${meal.calories} cal',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${meal.date.day}/${meal.date.month}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            onPressed: () => ref.read(mealProvider.notifier).deleteMeal(meal.id),
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
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
        error: (error, stack) => AppErrorWidget(message: error.toString(), onRetry: () => ref.invalidate(mealProvider)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.mealsAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}
