import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:loc_logger/services/visited_location.dart';
import 'package:loc_logger/widgets/calender_view.dart';
import 'package:loc_logger/widgets/main_drawer.dart';
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
import 'package:loc_logger/services/visited_location.dart';

const String registerLocationKey = 'periodic-visited-location-register';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    DartPluginRegistrant.ensureInitialized();

    String? locationId = await getCurrentLocationId();

    if (locationId == null) {
      return false;
    }

    VistedLocation visitedLocation = VistedLocation(
        id: const Uuid().v4(),
        dateTime: DateTime.now().toString(),
        locationId: locationId);

    addVisitedLocation(visitedLocation);

    return Future.value(true);
  });
}

String createCoordsKey(double latitude, double longitude) {
  return const Uuid().v5(Uuid.NAMESPACE_NIL, "$latitude$longitude");
}

void main() async {
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

  await initDb();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeBody = const Center(child: CircularProgressIndicator());

    if (visitedLocations == null || visitedLocations!.isEmpty) {
      activeBody = const Center(child: Text('No items found'));
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Text'),
          actions: [],
        ),
        drawer: const MainDrawer(),
        body: Center(
            child: CalenderView(
          givenDate: DateTime.now(),
        )),
      ),
    );
  }
}
