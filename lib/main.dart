import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:loc_logger/services/register_location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());

  // BackgroundFetch.registerHeadlessTask(registerLocation);
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

    print(visitedLocations);
    print(locations);

    setState(() {
      databaseLocs = dbNew;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeBody = const Center(child: CircularProgressIndicator());

    if (visitedLocations == null || visitedLocations!.isEmpty) {
      activeBody = const Center(child: Text('No items found'));
    }

    if (visitedLocations != null && visitedLocations!.isNotEmpty) {
      activeBody = const Center(child: Text('Locations found'));
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
              },
              child: const Text('Refresh'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final dbPath = await sql.getDatabasesPath();
                  final db = await sql.openDatabase(
                      path.join(dbPath, 'vistedLocations.db'),
                      version: 2);

                  String? currentLocationId;
                  String currentDay = DateTime.now().toString();
                  db.insert('vistedLocations', {
                    'id': const Uuid().v4(),
                    'dateVisited': currentDay.toString(),
                    'locationId': 'locationId'
                  });

                  db.insert('locations', {
                    'id': const Uuid().v4(),
                    'name': 'Home',
                    'address': 'Tollenstraat 25A',
                    'lat': 51.959053,
                    'long': 5.223487
                  });
                },
                child: const Text('Add new record')),
            ElevatedButton(
                onPressed: () async {
                  final dbPath = await sql.getDatabasesPath();
                  final db = await sql.openDatabase(
                      path.join(dbPath, 'vistedLocations.db'),
                      version: 2);

                  db.rawDelete('DELETE FROM vistedLocations');
                  db.rawDelete('DELETE FROM locations');
                },
                child: const Text('Empty data'))
          ],
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
          startOnBoot: true,
        ), (String taskId) async {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
          version: 2);

      String? currentLocationId;
      String currentDay = DateTime.now().toString();

      db.insert('vistedLocations', {
        'id': const Uuid().v4(),
        'dateVisited': currentDay.toString(),
        'locationId': 'background_fetch_2'
      });

      db.close();
      BackgroundFetch.finish(taskId);
    });
  }
}
