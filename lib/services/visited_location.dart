import 'package:loc_logger/models/visited_location.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geodesy/geodesy.dart' show Geodesy;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

Future<int> addVisitedLocation(VistedLocation vistedLocation) async {
  Database db = await initDb();

  int result = await db.insert(VISISTED_LOCATION_TABLE, {
    'id': vistedLocation.id,
    'date_time': vistedLocation.dateTime,
    'location_id': vistedLocation.locationId,
  });

  return result;
}

Future<List<VistedLocation>> getVisitedLocationsByLocationId() async {
  Database db = await initDb();

  List<Map> visitedLocations = await db.query(VISISTED_LOCATION_TABLE);

  List<VistedLocation> formattedVisitedLocations = visitedLocations
      .map((locationMap) => VistedLocation.fromMap(locationMap))
      .toList();

  return formattedVisitedLocations;
}

Future<String?> getCurrentLocationId() async {
  Database db = await initDb();

  if (defaultTargetPlatform == TargetPlatform.android) {
    GeolocatorAndroid.registerWith();
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    GeolocatorApple.registerWith();
  }

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
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

  List locations = await db.rawQuery('SELECT * FROM $LOCATIONS_TABLE');
  if (locations.isEmpty) {
    return null;
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
    return null;
  }

  return location['id'];
}

String createCoordsKey(double latitude, double longitude) {
  return const Uuid().v5(Uuid.NAMESPACE_NIL, "$latitude$longitude");
}
