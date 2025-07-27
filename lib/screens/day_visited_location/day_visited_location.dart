import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/models/visited_location.dart';

class DayVisitedLocationScreen extends StatelessWidget {
  final DateTime date;
  final List<VistedLocation>? visitedLocations;
  final Map<String, Location> locations;

  const DayVisitedLocationScreen(
      this.date, this.visitedLocations, this.locations,
      {super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          VistedLocation vistedLocation = visitedLocations![index];

          return Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(
                      color: locations[vistedLocation.locationId]?.color),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                locations[vistedLocation.locationId]!.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                vistedLocation.getFormattedDate()!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        },
        itemCount: visitedLocations!.length,
      ),
    );
  }
}
