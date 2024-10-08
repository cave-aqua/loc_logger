import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class LocationNotifier extends StateNotifier<List<Location>> {
  LocationNotifier() : super([]);

  Future<void> loadLocations() async {
    List<Location> formattedLocations = [];
    Database db = await _getDatabaseLocations();
    List locations = await db.query('locations');

    for (var location in locations) {
      formattedLocations.add(Location(
        id: location['id'],
        name: location['name'],
        lat: location['lat'],
        long: location['long'],
        // color: Color(int.parse(location['color'].substring(1, 7), radix: 16) +
        //     0xFF000000),
        color: Colors.black,
        isHome: location['is_home'] == 1, // Handle bool conversion
      ));
    }

    state = formattedLocations;
  }

  void addLocation(Location location) async {
    Database db = await _getDatabaseLocations();
    db.insert('locations', {
      'id': location.id,
      'name': location.name,
      'lat': location.lat,
      'long': location.long,
      'color': '#${location.color.value.toRadixString(16).substring(2)}',
      'is_home': location.isHome,
    });

    state = [location, ...state];
  }

  void removeLocation(String locationId) async {
    Database db = await _getDatabaseLocations();
    db.delete('locations', where: 'id = ?', whereArgs: [locationId]);

    state = state.where((location) => location.id != locationId).toList();
  }

  Future<Database> _getDatabaseLocations() async {
    final dbPath = await sql.getDatabasesPath();
    Database db = await sql
        .openDatabase(path.join(dbPath, 'vistedLocations.db'), version: 2,
            onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');
    });

    return db;
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<Location>>(
        (ref) => LocationNotifier());
