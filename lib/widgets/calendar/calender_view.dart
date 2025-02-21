import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/providers/days_visited_located_notifier.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/widgets/calendar/calender_view_aggerations/day_view.dart';
import 'package:loc_logger/widgets/calendar/calender_view_aggerations/month_switcher.dart';
import 'package:loc_logger/widgets/calendar/calender_view_aggerations/week_view.dart';
import 'package:loc_logger/widgets/calendar/calender_view_aggerations/weekdays_header.dart';
import 'package:loc_logger/providers/selected_date_notifier.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/models/visited_location.dart';

class CalenderView extends ConsumerStatefulWidget {
  final DateTime givenDate;

  const CalenderView({super.key, required this.givenDate});

  @override
  ConsumerState<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends ConsumerState<CalenderView> {
  @override
  void initState() {
    super.initState();
    // Call the loadLocations method to fetch data from the database
    Future.microtask(() => ref.read(locationProvider.notifier).loadLocations());
  }

  @override
  Widget build(BuildContext context) {
    List<WeekView> weeks = buildCalenderMonth();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonthSwitcher(
          currentDate: widget.givenDate,
        ),
        const WeekDaysHeader(),
        ...weeks
      ],
    );
  }

  List<WeekView> buildCalenderMonth() {
    DateTime chosenDate = ref.watch(selectedDateNotifierProvider);
    List<Location> locations = ref.read(locationProvider);
    Map<String, List<VistedLocation>> daysVisitedLocations =
        ref.watch(daysVisitedProvider);

    int month = chosenDate.month;
    int year = chosenDate.year;

    DateTime firstDayOfTheMonth = DateTime(year, month, 1);
    DateTime lastDayOfTheMonth = DateTime(year, month + 1, 0);

    int weekDay = DateTime(year, month, 1).weekday;
    int toBeRetractedWeekDay = weekDay - 1;

    int weekCounter = 0;
    DateTime dayPointer = firstDayOfTheMonth;
    List<List<Widget>> daysOfTheMonth = [];

    List<WeekView> weeks = [];

    void addDayToPointer() {
      daysOfTheMonth[weekCounter].add(
        DayView(
          dayPointer,
          locations: locations,
          visitedLocations: daysVisitedLocations['${dayPointer.day}'],
        ),
      );

      dayPointer =
          DateTime(dayPointer.year, dayPointer.month, dayPointer.day + 1);
    }

    //We set a empty days if the first day of the month is not the first day of the week.
    if (toBeRetractedWeekDay > 0) {
      List<Widget> offSetWeek = [];

      for (var i = 0; i < toBeRetractedWeekDay; i++) {
        offSetWeek.add(const EmptyDayView());
      }
      daysOfTheMonth.add(offSetWeek);
    } else {
      daysOfTheMonth.add([]);
    }

    while (dayPointer.month == month) {
      //We build here the last week with empty day views
      if (dayPointer.day == lastDayOfTheMonth.day) {
        if (daysOfTheMonth[weekCounter].length < DateTime.daysPerWeek) {
          addDayToPointer();
        }

        int lastWeekLength = daysOfTheMonth[weekCounter].length;

        if (lastWeekLength < DateTime.daysPerWeek) {
          for (var i = 0; i < DateTime.daysPerWeek - lastWeekLength; i++) {
            daysOfTheMonth[weekCounter].add(
              const EmptyDayView(),
            );
          }
        }

        weeks.add(WeekView(
          children: daysOfTheMonth[weekCounter],
        ));

        break;
      }

      addDayToPointer();

      //We go to next week
      if (daysOfTheMonth[weekCounter].length == DateTime.daysPerWeek) {
        weeks.add(WeekView(
          children: daysOfTheMonth[weekCounter],
        ));
        weekCounter++;
        daysOfTheMonth.add([]);
      }
    }

    return weeks;
  }
}
