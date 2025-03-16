import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';

class LocationNotifier extends StateNotifier<List<Location>> {
  LocationNotifier() : super([]);

  Future<void> loadLocations() async {
    List<Location> formattedLocations = [];
    Database db = await initDb();
    List locations = await db.query(LOCATIONS_TABLE);

    for (var location in locations) {
      formattedLocations.add(Location(
        id: location['id'],
        name: location['name'],
        lat: location['lat'],
        long: location['long'],
        color: Color(int.parse(location['color'])).withOpacity(1),
        isHome: location['is_home'] == 1, // Handle bool conversion
      ));
    }

    state = formattedLocations;
  }

  void addLocation(Location location) async {
    Database db = await initDb();
    db.insert(LOCATIONS_TABLE, {
      'id': location.id,
      'name': location.name,
      'lat': location.lat,
      'long': location.long,
      'color': location.color.value,
      'is_home': location.isHome,
    });

    state = [location, ...state];
  }

  void updateLocation(Location location) async {
    Database db = await initDb();
    db.update(
      LOCATIONS_TABLE,
      {
        'name': location.name,
        'lat': location.lat,
        'long': location.long,
        'color': location.color.value,
        'is_home': location.isHome,
      },
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state.removeWhere((element) => element.id == location.id);
    state = [location, ...state];
  }

  void removeLocation(String locationId) async {
    Database db = await initDb();
    db.delete(LOCATIONS_TABLE, where: 'id = ?', whereArgs: [locationId]);
    db.delete(VISISTED_LOCATION_TABLE,
        where: 'location_id = ?', whereArgs: [locationId]);

    state = state.where((location) => location.id != locationId).toList();
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<Location>>(
        (ref) => LocationNotifier());
