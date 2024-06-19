import 'package:flutter/material.dart';

class DayView extends StatelessWidget {
  final DateTime date;

  const DayView(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: Should open view about the day.
        //TODO: retrieve data to know where the user has been.
      },
      child: Container(
        width: 40,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: Center(
          child: Text(date.day.toString()),
        ),
      ),
    );
  }
}
