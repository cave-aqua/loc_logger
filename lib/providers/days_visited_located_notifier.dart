import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/visited_location.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:loc_logger/services/visited_location.dart';

class DaysVisitedNotitifer extends Notifier<Map<String, List<VistedLocation>>> {
  @override
  Map<String, List<VistedLocation>> build() {
    return {};
  }

  Future<void> loadDaysVisited(DateTime dateTime) async {
    final db = await initDb();

    String monthStr = dateTime.month
        .toString()
        .padLeft(2, '0'); // Ensure month has two digits

    List<Map> visitedLocationsSelectedMonth = await db.query(
      VISISTED_LOCATION_TABLE,
      where: "strftime('%Y-%m', date_time) = ?",
      whereArgs: ["${dateTime.year}-$monthStr"],
    );

    Map<String, List<VistedLocation>> formattedListedVisited = {};

    if (visitedLocationsSelectedMonth.isEmpty) {
      _emptyState();
    }

    for (var i = 0; i < visitedLocationsSelectedMonth.length; i++) {
      VistedLocation rawVisitedLocation =
          VistedLocation.fromMap(visitedLocationsSelectedMonth[i]);

      //We don't check on null because vistedLocation wouldn't be returned from query.
      String dayKey = '${rawVisitedLocation.getDate()!.day}';

      if (formattedListedVisited.containsKey(dayKey)) {
        formattedListedVisited[dayKey]!.add(rawVisitedLocation);
      } else {
        formattedListedVisited[dayKey] = [rawVisitedLocation];
      }
    }

    state = formattedListedVisited;
  }

  Future<void> removeDay(int dayString, VistedLocation vistedLocation) {
    final currentState = state;

    final updatedList = (currentState[dayString.toString()] ?? [])
        .where((element) => element.id != vistedLocation.id)
        .toList();

    state = {
      ...currentState,
      dayString.toString(): updatedList,
    };

    return removeVisitedLocation(vistedLocation);
  }

  void _emptyState() {
    state = {};
  }
}

final daysVisitedProvider =
    NotifierProvider<DaysVisitedNotitifer, Map<String, List<VistedLocation>>>(
        () => DaysVisitedNotitifer());
