import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:geodesy/geodesy.dart' show Geodesy;

Future<bool> registerLocation() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
      version: 2);

  db.insert('vistedLocations', {
    'id': const Uuid().v4(),
    'dateVisited': '2024-11-11',
    'locationId': 'workmanager_test5',
  });

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

  db.insert('vistedLocations', {
    'id': const Uuid().v4(),
    'dateVisited': '2024-12-12',
    'locationId': 'workmanager_test3',
  });

  Position userLoc = await Geolocator.getCurrentPosition();

  await db.insert('vistedLocations', {
    'id': const Uuid().v4(),
    'dateVisited': '2024-11-11',
    'locationId': 'workmanager_test2',
  });

  print('gone trough location');

  await getClosestLocation(userLoc);

  await db.insert('vistedLocations', {
    'id': const Uuid().v4(),
    'dateVisited': '2024-01-10',
    'locationId': 'workmanager_test1',
  });

  return true;
}

Future<bool> getClosestLocation(Position userLocation) async {
  double lat = userLocation.latitude;
  double long = userLocation.longitude;

  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
      version: 2);

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
  String currentDay = DateTime.now().toString();

  db.insert('vistedLocations', {
    'id': const Uuid().v4(),
    'dateVisited': currentDay,
    'locationId': location['id'],
  });

  return true;
}

String createCoordsKey(double latitude, double longitude) {
  return const Uuid().v5(Uuid.NAMESPACE_NIL, "$latitude$longitude");
}
