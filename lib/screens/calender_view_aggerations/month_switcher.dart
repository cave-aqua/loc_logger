import 'package:flutter/material.dart';

class MonthSwitcher extends StatefulWidget {
  final DateTime currentDate;

  const MonthSwitcher({super.key, required this.currentDate});

  @override
  State<MonthSwitcher> createState() => _MonthSwitcherState();
}

class _MonthSwitcherState extends State<MonthSwitcher> {
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
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              // TODO: substract a month
            },
            icon: const Icon(Icons.arrow_back)),
        Text(
            '${months[widget.currentDate.month - 1]} ${widget.currentDate.year}'),
        IconButton(
            onPressed: () {
              // TODO: Add a month
            },
            icon: const Icon(Icons.arrow_forward)),
      ],
    );
  }
}
