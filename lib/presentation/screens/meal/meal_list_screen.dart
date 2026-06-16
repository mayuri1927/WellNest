import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:well_nest/presentation/providers/meal_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/presentation/widgets/common/loading_widget.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';
import 'package:well_nest/core/constants/app_constants.dart';

class MealListScreen extends ConsumerWidget {
  const MealListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(mealProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showCalendar(context, ref),
          ),
        ],
      ),
      body: mealState.isLoading
          ? const LoadingWidget()
          : mealState.meals.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.restaurant,
                  title: 'No Meals Yet',
                  subtitle: 'Start tracking your meals to see them here',
                  actionLabel: 'Add Meal',
                  onAction: () => Navigator.pushNamed(context, '/meals/add'),
                )
              : _buildMealList(context, ref, mealState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/meals/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealList(
    BuildContext context,
    WidgetRef ref,
    MealState mealState,
  ) {
    final meals = mealState.mealsForSelectedDate;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              Text(
                DateTimeUtils.formatDate(mealState.selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${mealState.totalCaloriesForSelectedDate} calories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: meals.isEmpty
              ? const Center(child: Text('No meals for this day'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Dismissible(
                      key: Key(meal.id),
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
                            title: const Text('Delete Meal'),
                            content: const Text(
                                'Are you sure you want to delete this meal?'),
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
                        ref.read(mealProvider.notifier).deleteMeal(meal.id);
                      },
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _getMealTypeColor(meal.type)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getMealTypeIcon(meal.type),
                                    color: _getMealTypeColor(meal.type),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        meal.type,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${meal.calories} cal',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildNutrientInfo('Protein', '${meal.protein}g'),
                                _buildNutrientInfo('Carbs', '${meal.carbs}g'),
                                _buildNutrientInfo('Fat', '${meal.fat}g'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  IconData _getMealTypeIcon(String type) {
    switch (type) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealTypeColor(String type) {
    switch (type) {
      case 'Breakfast':
        return Colors.orange;
      case 'Lunch':
        return Colors.green;
      case 'Dinner':
        return Colors.blue;
      case 'Snack':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
                focusedDay: ref.read(mealProvider).selectedDate,
                selectedDayPredicate: (day) {
                  return isSameDay(ref.read(mealProvider).selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  ref.read(mealProvider.notifier).setSelectedDate(selectedDay);
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
