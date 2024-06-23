import 'package:flutter/material.dart';
import 'package:loc_logger/screens/calender_view_aggerations/day_view.dart';
import 'package:loc_logger/screens/calender_view_aggerations/month_switcher.dart';
import 'package:loc_logger/screens/calender_view_aggerations/week_view.dart';
import 'package:loc_logger/screens/calender_view_aggerations/weekdays_header.dart';

// ignore: must_be_immutable
class CalenderView extends StatefulWidget {
  DateTime givenDate;

  CalenderView({super.key, required this.givenDate});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  @override
  Widget build(BuildContext context) {
    List<WeekView> weeks = buildCalenderMonth(widget.givenDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonthSwitcher(
          currentDate: widget.givenDate,
          incrementMonth: incrementMonth,
          decrementMonth: decrementMonth,
        ),
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
    List<List<Widget>> days = [];

    List<WeekView> weeks = [];

    void addDayToPointer() {
      days[startCounter].add(
        DayView(dayPointer),
      );

      dayPointer = dayPointer.add(
        const Duration(days: 1),
      );
    }

    //We set a empty days if the first day of the month is not the first day of the week.
    if (toBeRetractedWeekDay > 0) {
      List<Widget> offSetWeek = [];

      for (var i = 0; i < toBeRetractedWeekDay; i++) {
        offSetWeek.add(const EmptyDayView());
      }
      days.add(offSetWeek);
    } else {
      days.add([]);
    }

    while (dayPointer.month == month) {
      if (dayPointer.day == lastDayOfTheMonth.day) {
        if (days[startCounter].length < 7) {
          addDayToPointer();
        }

        int lastWeekLength = days[startCounter].length;

        if (lastWeekLength < DateTime.daysPerWeek) {
          for (var i = 0; i < DateTime.daysPerWeek - lastWeekLength; i++) {
            days[startCounter].add(
              const EmptyDayView(),
            );
          }
        }

        weeks.add(WeekView(
          children: days[startCounter],
        ));

        break;
      }

      addDayToPointer();

      //We go to next week
      if (days[startCounter].length == DateTime.daysPerWeek) {
        weeks.add(WeekView(
          children: days[startCounter],
        ));
        startCounter++;
        days.add([]);
      }
    }

    return weeks;
  }

  void incrementMonth() {
    setState(() {
      widget.givenDate = DateTime(widget.givenDate.year,
          widget.givenDate.month + 1, widget.givenDate.day);
    });
  }

  void decrementMonth() {
    setState(() {
      widget.givenDate = DateTime(widget.givenDate.year,
          widget.givenDate.month - 1, widget.givenDate.day);
    });
  }
}
