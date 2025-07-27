import 'package:flutter/material.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/models/visited_location.dart';
import 'package:loc_logger/screens/day_visited_location/day_visited_location.dart';

class DayView extends StatelessWidget {
  final DateTime date;
  final List<VistedLocation>? visitedLocations;
  final Map<String, Location> locations;
  final Map borderSettings;

  const DayView(this.date,
      {super.key,
      required this.locations,
      this.visitedLocations,
      required this.borderSettings});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [];
    const snackBar =
        SnackBar(content: Text('No visited dates available on date'));

    if (visitedLocations != null && locations.isNotEmpty) {
      for (var visitedLocation in visitedLocations!) {
        colors.add(locations[visitedLocation.locationId]!.color);
      }
    }

    return Expanded(
      child: InkWell(
        onLongPress: () {
          if (visitedLocations != null && visitedLocations!.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DayVisitedLocationScreen(
                      date, visitedLocations, locations),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border(
              top: borderSettings['isFirstWeek']
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
              bottom: borderSettings['isLastWeek']
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
              left: borderSettings['isFirstDay']
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
              right: borderSettings['isLastDay']
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: _buildBackground(colors),
              ),
              Center(
                child: Text(
                  date.day.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackground(List<Color> colors) {
    List<Widget> backgroundColors = [];

    for (Color color in colors) {
      backgroundColors.add(
        Flexible(
          child: Container(
            decoration: BoxDecoration(color: color),
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
