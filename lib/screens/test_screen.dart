import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loc_logger/models/location.dart';
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

  // Future<void> _getDatabase() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   Database dbNew = await sql.openDatabase(
  //       path.join(dbPath, 'vistedLocations.db'), onCreate: (db, version) async {
  //     // await db.execute(
  //     //     'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, address TEXT, lat REAL, long REAL)');

  //     await db.execute(
  //         'CREATE TABLE IF NOT EXISTS vistedLocations (id TEXT PRIMARY KEY, dateVisited DATETIME, locationId TEXT, FOREIGN KEY (locationId) REFERENCES locations(id))');
  //   }, version: 2);
  //   locations = await dbNew.query('locations');
  //   visitedLocations = await dbNew.query('vistedLocations');

  //   setState(() {});

  //   if (visitedLocations != null && locations != null) {
  //     if (visitedLocations!.isNotEmpty && locations!.isNotEmpty) {
  //       formattedVisitedLocations.clear();
  //       for (var vistetedLocation in visitedLocations!) {
  //         formattedVisitedLocations.add(VistedLocation(
  //             id: vistetedLocation['id'],
  //             dateTime: vistetedLocation['dateVisited'],
  //             locationId: vistetedLocation['locationId']));
  //       }

  //       for (var location in locations!) {
  //         formattedLocations.add(
  //           Location(
  //               id: location['id'],
  //               name: location['name'],
  //               lat: location['lat'],
  //               long: location['long'],
  //               color: Colors.black,
  //               isHome: true),
  //         );
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List? locations;
    List<Location> formattedLocations = [];
    List<VistedLocation> formattedVisitedLocations = [];

    Widget activeBody = const Center(child: CircularProgressIndicator());

    if (visitedLocations == null || visitedLocations!.isEmpty) {
      activeBody = const Center(child: Text('No items found'));
    }

    if (visitedLocations != null && visitedLocations!.isNotEmpty) {
      activeBody = Center(
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: ListView.builder(
            itemCount: formattedVisitedLocations.length,
            itemBuilder: (context, index) {
              VistedLocation currentLocation = formattedVisitedLocations[index];
              DateTime? date = currentLocation.getDate();
              String? getFormattedDate = currentLocation.getFormattedDate();

              if (date != null) {
                if (getFormattedDate != null) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Text(getFormattedDate),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          activeBody,
          ElevatedButton(
            onPressed: () {
              // _getDatabase();
              print(locations);
              print(formattedVisitedLocations);
              print(visitedLocations);
            },
            child: const Text('Refresh'),
          ),
          ElevatedButton(
              onPressed: () async {
                final dbPath = await sql.getDatabasesPath();
                final db = await sql.openDatabase(
                    path.join(dbPath, 'vistedLocations.db'),
                    version: 2);
                await db.insert('locations', {
                  'id': Uuid().v4(),
                  'name': 'Home',
                  'address': '',
                  'lat': 51.9592,
                  'long': 5.2236,
                });

                registerLocation();
              },
              child: const Text('Add new record')),
          ElevatedButton(
              onPressed: () async {
                final dbPath = await sql.getDatabasesPath();
                final db = await sql.openDatabase(
                    path.join(dbPath, 'vistedLocations.db'),
                    version: 2);
                formattedVisitedLocations.clear();
                db.rawDelete('DELETE FROM vistedLocations');
                // db.rawDelete('DELETE FROM locations');
              },
              child: const Text('Empty data'))
        ],
      ),
    );
  }
}
