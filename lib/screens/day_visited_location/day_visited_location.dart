import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/models/visited_location.dart';
import 'package:loc_logger/providers/days_visited_located_notifier.dart';

class DayVisitedLocationScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final List<VistedLocation>? visitedLocations;
  final Map<String, Location> locations;

  const DayVisitedLocationScreen(
      this.date, this.visitedLocations, this.locations,
      {super.key});

  @override
  ConsumerState<DayVisitedLocationScreen> createState() =>
      _DayVisitedLocationScreenState();
}

class _DayVisitedLocationScreenState
    extends ConsumerState<DayVisitedLocationScreen> {
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(widget.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          VistedLocation vistedLocation = widget.visitedLocations![index];

          return Dismissible(
            key: Key(vistedLocation.id),
            onDismissed: (dismissDirection) {
              ref
                  .read(daysVisitedProvider.notifier)
                  .removeDay(vistedLocation.getDate()!.day, vistedLocation);
            },
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            widget.locations[vistedLocation.locationId]?.color),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  widget.locations[vistedLocation.locationId]!.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(child: Container()),
                Text(
                  vistedLocation.getFormattedDate()!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          );
        },
        itemCount: widget.visitedLocations!.length,
      ),
    );
  }
}
