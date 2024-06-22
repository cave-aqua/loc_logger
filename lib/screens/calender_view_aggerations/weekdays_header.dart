import 'package:flutter/material.dart';

class WeekDaysHeader extends StatelessWidget {
  const WeekDaysHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DayHeaderHolder(dayString: "Mon"),
        DayHeaderHolder(dayString: "Tue"),
        DayHeaderHolder(dayString: "Wed"),
        DayHeaderHolder(dayString: "Thu"),
        DayHeaderHolder(dayString: "Fri"),
        DayHeaderHolder(dayString: "Sat"),
        DayHeaderHolder(dayString: "Sun"),
      ],
    );
  }
}

class DayHeaderHolder extends StatelessWidget {
  final String dayString;

  const DayHeaderHolder({super.key, required this.dayString});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      // padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Center(
        child: Text(
          dayString,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
