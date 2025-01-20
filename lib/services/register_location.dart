import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:geodesy/geodesy.dart' show Geodesy;

Future<bool> registerLocation() async {
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

  await getClosestLocation(userLoc);

  return true;
}

Future<bool> getClosestLocation(Position userLocation) async {
  double lat = userLocation.latitude;
  double long = userLocation.longitude;

  final db = await initDb();

  List locations = await db.rawQuery('SELECT * FROM $LOCATIONS_TABLE');
  if (locations.isEmpty) {
    return false;
  }

  Map<String, Map> computedLocations = {};
  List<LatLng> latLongListLocations = [];

  for (var location in locations) {
    double lat = location['lat'];
    double long = location['long'];
    computedLocations[createCoordsKey(lat, long)] = location;
    latLongListLocations.add(LatLng(lat, long));
  }

  List<LatLng> result =
      Geodesy().pointsInRange(LatLng(lat, long), latLongListLocations, 200);

  Map? location = computedLocations[
      createCoordsKey(result.first.latitude, result.first.longitude)];

  if (location == null) {
    return false;
  }

  bool checkIfLocationHasBeenSet = await isAlreadySet(location['id']);

  if (checkIfLocationHasBeenSet) {
    return true;
  }

  String currentDay = DateTime.now().toString();

  db.insert(VISISTED_LOCATION_TABLE, {
    'id': const Uuid().v4(),
    'dateVisited': currentDay,
    'locationId': location['id'],
  });

  return true;
}

String createCoordsKey(double latitude, double longitude) {
  return const Uuid().v5(Uuid.NAMESPACE_NIL, "$latitude$longitude");
}

Future<bool> isAlreadySet(String locationId) async {
  final db = await initDb();

  List checkLocation = await db.rawQuery(
      'SELECT COUNT(*) FROM $VISISTED_LOCATION_TABLE WHERE location_id = "$locationId"');

  int Counter = checkLocation.first.row[0];
  if (Counter > 0) {
    return true;
  }

  return false;
}
