import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'dart:math';

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

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position userLoc = await Geolocator.getCurrentPosition();

    String currentDay = DateTime.now().toString();

    db.insert('vistedLocations', {
      'id': const Uuid().v4(),
      'dateVisited': currentDay.toString(),
      'locationId': 'background_fetch_new'
    });

    db.close();
    BackgroundFetch.finish(taskId);
  });
}

getClosestLocation(Position userLocation) async {
  double lat = userLocation.latitude;
  double long = userLocation.longitude;
  double searchAbleDegreesLong = convertMetersToDegreesBasedOnLong(200, long);
  double searchAbleDegreesLat = convertMetersToDegreesBasedOnLat(200);
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
      version: 2);

  List result = await db.rawQuery(
      'SELECT * FROM locations WHERE (6371000 * acos(cos(radians(lat)) * cos(radians(?)) * cos(radians(?) - radians(long)) + sin(radians(loc_lat)) * sin(radians(?)) ) <= :radius_meters',
      [lat, long]);
  if (result.isNotEmpty) {
    return result.first;
  }

  return null;
}

double convertMetersToDegreesBasedOnLong(double meters, double longitude) {
  double metersPerDegreeLon = 111320 * cos(longitude * pi / 180);
  return meters / metersPerDegreeLon;
}

double convertMetersToDegreesBasedOnLat(double meters) {
  return meters / 111320;
}
