import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_nest/presentation/providers/medicine_provider.dart';
import 'package:well_nest/presentation/widgets/common/custom_widgets.dart';
import 'package:well_nest/presentation/widgets/common/loading_widget.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder'),
      ),
      body: medicineState.isLoading
          ? const LoadingWidget()
          : medicineState.medicines.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.medication,
                  title: 'No Medicines Yet',
                  subtitle: 'Add medicines to get reminders',
                  actionLabel: 'Add Medicine',
                  onAction: () => Navigator.pushNamed(context, '/medicines/add'),
                )
              : _buildMedicineList(context, ref, medicineState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/medicines/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicineList(
    BuildContext context,
    WidgetRef ref,
    MedicineState medicineState,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medicineState.medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicineState.medicines[index];
        return Dismissible(
          key: Key(medicine.id),
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
                title: const Text('Delete Medicine'),
                content: const Text(
                    'Are you sure you want to delete this medicine?'),
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
            ref.read(medicineProvider.notifier).deleteMedicine(medicine.id);
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
                        color: medicine.isActive
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.medication,
                        color: medicine.isActive ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  medicine.isActive ? null : Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${medicine.dosage} ${medicine.unit} • ${medicine.frequency}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: medicine.isActive,
                      onChanged: (value) {
                        ref
                            .read(medicineProvider.notifier)
                            .toggleActive(medicine.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: medicine.timeSlots.map((slot) {
                    return Chip(
                      label: Text(
                        slot,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
                if (medicine.notes != null && medicine.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    medicine.notes!,
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
