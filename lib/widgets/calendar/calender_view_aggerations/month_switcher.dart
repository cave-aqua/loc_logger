import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/providers/selected_date_notifier.dart';

class MonthSwitcher extends ConsumerWidget {
  final DateTime currentDate;

  MonthSwitcher({
    super.key,
    required this.currentDate,
  });

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => ref
                .read(selectedDateNotifierProvider.notifier)
                .decreaseByMonth(),
            icon: const Icon(Icons.arrow_back)),
        Text(
          '${months[currentDate.month - 1]} ${currentDate.year}',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        IconButton(
            onPressed: () => ref
                .read(selectedDateNotifierProvider.notifier)
                .increaseByMonth(),
            icon: const Icon(Icons.arrow_forward)),
      ],
    );
  }
}
