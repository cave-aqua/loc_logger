import 'package:flutter/material.dart';
import 'package:loc_logger/screens/calender_view_aggerations/day_view.dart';
import 'package:loc_logger/screens/calender_view_aggerations/month_switcher.dart';
import 'package:loc_logger/screens/calender_view_aggerations/week_view.dart';
import 'package:loc_logger/screens/calender_view_aggerations/weekdays_header.dart';

class CalenderView extends StatelessWidget {
  final DateTime givenDate;

  const CalenderView({super.key, required this.givenDate});

  @override
  Widget build(BuildContext context) {
    List<WeekView> weeks = buildCalenderMonth(givenDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonthSwitcher(currentDate: givenDate),
        const WeekDaysHeader(),
        ...weeks
      ],
    );
  }

  List<WeekView> buildCalenderMonth(DateTime chosenDate) {
    int month = chosenDate.month;
    int year = chosenDate.year;

    DateTime firstDayOfTheMonth = DateTime(year, month, 1);
    DateTime lastDayOfTheMonth = DateTime(year, month + 1, 0);

    int weekDay = DateTime(year, month, 1).weekday;
    int toBeRetractedWeekDay = weekDay - 1;

    int startCounter = 0;
    DateTime dayPointer = firstDayOfTheMonth;
    List<List<DayView>> days = [];

    List<WeekView> weeks = [];

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
      if (dayPointer.day == lastDayOfTheMonth.day) {
        weeks.add(WeekView(
          children: days[startCounter],
        ));
      }

      //We go to next week
      if (days[startCounter].length == DateTime.daysPerWeek) {
        weeks.add(WeekView(
          children: days[startCounter],
        ));
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

    return weeks;
  }
}
