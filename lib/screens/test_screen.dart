import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:loc_logger/services/visited_location.dart';
import 'package:workmanager/workmanager.dart';
import 'package:loc_logger/models/visited_location.dart';
import 'package:loc_logger/services/register_location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geodesy/geodesy.dart' show Geodesy;

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List? locations;
  List? visitedLocations;

  List<Location> formattedLocations = [];

  List<VistedLocation> formattedVisitedLocations = [];

  @override
  Widget build(BuildContext context) {
    List<VistedLocation> formattedVisitedLocations = [];

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder(
              future: getVisitedLocationsByLocationId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  }

                  visitedLocations = snapshot.data;

                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: visitedLocations!.length,
                      itemBuilder: (context, index) {
                        VistedLocation visitedLocation =
                            visitedLocations![index];
                        return Column(
                          children: [
                            Text(visitedLocation.locationId),
                            Text(visitedLocation.dateTime),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        );
                      },
                    ),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  registerVisitedLocation();
                },
                child: const Text('Add new record')),
            ElevatedButton(
                onPressed: () async {
                  final db = await initDb();
                  formattedVisitedLocations.clear();
                  db.rawDelete('DELETE FROM $VISISTED_LOCATION_TABLE');
                  // db.rawDelete('DELETE FROM $LOCATIONS_TABLE');
                },
                child: const Text('Empty data'))
          ],
        ),
      ),
    );
  }
}
