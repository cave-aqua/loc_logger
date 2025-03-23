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

    return Expanded(
      child: Container(
        height: 30,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Stack(
          children: [
            Expanded(
              child: Row(
                children: _buildBackground(colors),
              ),
            ),
            Center(
              child: Text(
                date.day.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackground(List<Color> colors) {
    List<Widget> backgroundColors = [];

    for (Color color in colors) {
      backgroundColors.add(
        Flexible(
          flex: 1,
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(color: color),
            ),
          ),
        ),
      );
    }

    return backgroundColors;
  }
}

class EmptyDayView extends StatelessWidget {
  const EmptyDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container());
  }
}
