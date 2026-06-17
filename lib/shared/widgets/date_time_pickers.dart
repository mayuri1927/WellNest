import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_colors.dart';
import '../../core/utils/responsive.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime) onDateSelected;
  final bool readOnly;
  final IconData? icon;

  const DatePickerField({
    super.key,
    this.selectedDate,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.readOnly = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: readOnly
              ? null
              : () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(2000),
                    lastDate: lastDate ?? DateTime(2100),
                  );
                  if (date != null) onDateSelected(date);
                },
          borderRadius: BorderRadius.circular(Radii.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                        : hint ?? 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedDate != null
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final String? label;
  final String? hint;
  final void Function(TimeOfDay) onTimeSelected;
  final bool readOnly;
  final IconData? icon;

  const TimePickerField({
    super.key,
    this.selectedTime,
    this.label,
    this.hint,
    required this.onTimeSelected,
    this.readOnly = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: readOnly
              ? null
              : () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) onTimeSelected(time);
                },
          borderRadius: BorderRadius.circular(Radii.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : hint ?? 'Select time',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedTime != null
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
