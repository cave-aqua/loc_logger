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

const String registerLocationKey = 'periodic-visited-location-register';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    DartPluginRegistrant.ensureInitialized();
    String currentDay = DateTime.now().toString();

    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
        version: 2);

    if (defaultTargetPlatform == TargetPlatform.android) {
      GeolocatorAndroid.registerWith();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      GeolocatorApple.registerWith();
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position userLoc = await Geolocator.getCurrentPosition();

    double lat = userLoc.latitude;
    double long = userLoc.longitude;

    List locations = await db.rawQuery('SELECT * FROM locations');
    if (locations.isEmpty) {
      return false;
    }

    Map<String, Map> computedLocations = {};
    List<LatLng> latLongListLocations = [];

    locations.forEach((location) {
      double lat = location['lat'];
      double long = location['long'];
      computedLocations[createCoordsKey(lat, long)] = location;
      latLongListLocations.add(LatLng(lat, long));
    });

    List<LatLng> result =
        Geodesy().pointsInRange(LatLng(lat, long), latLongListLocations, 200);

    Map? location = computedLocations[
        createCoordsKey(result.first.latitude, result.first.longitude)];

    if (location == null) {
      return false;
    }

    await db.insert('vistedLocations', {
      'id': const Uuid().v4(),
      'dateVisited': currentDay,
      'locationId': location['id'],
    });

    return Future.value(true);
  });
}

String createCoordsKey(double latitude, double longitude) {
  return const Uuid().v5(Uuid.NAMESPACE_NIL, "$latitude$longitude");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    registerLocationKey,
    'register-location',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresCharging: false,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Database? databaseLocs;
  List? visitedLocations;
  List? locations;
  List<VistedLocation> formattedVisitedLocations = [];
  List<Location> formattedLocations = [];

  Future<void> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    Database dbNew = await sql.openDatabase(
        path.join(dbPath, 'vistedLocations.db'), onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, address TEXT, lat REAL, long REAL)');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS vistedLocations (id TEXT PRIMARY KEY, dateVisited DATETIME, locationId TEXT, FOREIGN KEY (locationId) REFERENCES locations(id))');
    }, version: 2);
    visitedLocations = await dbNew.query('vistedLocations');
    locations = await dbNew.query('locations');

    if (visitedLocations != null && locations != null) {
      if (visitedLocations!.isNotEmpty && locations!.isNotEmpty) {
        formattedVisitedLocations.clear();
        for (var vistetedLocation in visitedLocations!) {
          formattedVisitedLocations.add(VistedLocation(
              id: vistetedLocation['id'],
              dateTime: vistetedLocation['dateVisited'],
              locationId: vistetedLocation['locationId']));
        }

        for (var location in locations!) {
          formattedLocations.add(
            Location(
                id: location['id'],
                name: location['name'],
                lat: location['lat'],
                long: location['long'],
                color: Colors.black,
                isHome: true),
          );
        }
      }
    }

    setState(() {
      databaseLocs = dbNew;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDatabase();
  }

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            activeBody,
            ElevatedButton(
              onPressed: () {
                _getDatabase();
                print(locations);
                print(formattedVisitedLocations);
              },
              child: const Text('Refresh'),
            ),
            ElevatedButton(
                onPressed: () async {
                  // final dbPath = await sql.getDatabasesPath();
                  // final db = await sql.openDatabase(
                  //     path.join(dbPath, 'vistedLocations.db'),
                  //     version: 2);
                  // await db.insert('locations', {
                  //   'id': Uuid().v4(),
                  //   'name': 'Home',
                  //   'address': '',
                  //   'lat': 51.9592,
                  //   'long': 5.2236,
                  // });

                  registerLocation();

                  print('created');
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
      ),
    );
  }
}
