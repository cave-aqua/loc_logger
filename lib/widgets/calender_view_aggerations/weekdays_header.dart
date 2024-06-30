import 'package:flutter/material.dart';
import 'package:loc_logger/widgets/calender_view_aggerations/week_view.dart';

class WeekDaysHeader extends StatelessWidget {
  const WeekDaysHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeekView(
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
