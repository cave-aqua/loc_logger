import 'package:flutter/material.dart';

class MonthSwitcher extends StatelessWidget {
  final void Function() incrementMonth;
  final void Function() decrementMonth;
  final DateTime currentDate;

  MonthSwitcher({
    super.key,
    required this.currentDate,
    required this.incrementMonth,
    required this.decrementMonth,
  });

  List<String> months = [
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: decrementMonth, icon: const Icon(Icons.arrow_back)),
        Text('${months[currentDate.month - 1]} ${currentDate.year}'),
        IconButton(
            onPressed: incrementMonth, icon: const Icon(Icons.arrow_forward)),
      ],
    );
  }
}
