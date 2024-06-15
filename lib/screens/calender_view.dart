import 'package:flutter/material.dart';
import 'package:loc_logger/screens/calender_view_aggerations/day_view.dart';

class CalenderView extends StatelessWidget {
  const CalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    int lastDayOfMonth = DateTime(year, month, 0).day;
    int weekDay = DateTime(year, month, 1).weekday;
    int toBeRetractedWeekDay = weekDay == 1 ? weekDay : weekDay - weekDay--;

    List<List<DayView>> weeks = buildCalenderMonth(DateTime.now());

    return Column();
  }

  List<List<DayView>> buildCalenderMonth(DateTime chosenDate) {
    int month = chosenDate.month;
    int year = chosenDate.year;

    DateTime firstDayOfTheMonth = DateTime(year, month, 1);
    int lastDayOfMonth = DateTime(year, month, 0).day;

    int weekDay = DateTime(year, month, 1).weekday;
    int toBeRetractedWeekDay = weekDay - 1;

    int startCounter = 0;
    DateTime dayPointer = firstDayOfTheMonth;
    List<List<DayView>> days = [];

    if (toBeRetractedWeekDay > 0) {
      List<DayView> offSetWeek = [];

      for (var i = 0; i < toBeRetractedWeekDay; i++) {
        offSetWeek.add(
          DayView(
            firstDayOfTheMonth.subtract(
              Duration(days: toBeRetractedWeekDay - i),
            ),
          ),
        );
      }
      days.add(offSetWeek);
    } else {
      days.add([]);
    }

    while (dayPointer.month == month) {
      //We go to next week
      if (days[startCounter].length == 7) {
        startCounter++;
        days.add([]);
      }

      days[startCounter].add(
        DayView(dayPointer),
      );

      dayPointer = dayPointer.add(
        const Duration(days: 1),
      );
    }

    return days;
  }
}
