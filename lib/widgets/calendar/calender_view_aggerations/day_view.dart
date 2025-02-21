import 'package:flutter/material.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/models/visited_location.dart';

class DayView extends StatelessWidget {
  final DateTime date;
  final List<VistedLocation>? visitedLocations;
  final List<Location> locations;

  const DayView(
    this.date, {
    super.key,
    required this.locations,
    this.visitedLocations,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [];

    if (visitedLocations != null && locations.isNotEmpty) {
      for (var visitedLocation in visitedLocations!) {
        Location location = locations.firstWhere(
            (Location location) => location.id == visitedLocation.locationId);

        colors.add(location.color);
      }
    }

    BoxDecoration? background;

    if (colors.length > 1) {
      background = BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
    } else if (colors.length == 1) {
      background = BoxDecoration(color: colors.first);
    }

    return InkWell(
      child: Container(
        width: 40,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: background,
        child: Center(
          child: Text(date.day.toString()),
        ),
      ),
    );
  }
}

class EmptyDayView extends StatelessWidget {
  const EmptyDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 46,
    );
  }
}
