import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/screens/locations/add_location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class LocationsOverview extends ConsumerStatefulWidget {
  const LocationsOverview({super.key});

  @override
  ConsumerState<LocationsOverview> createState() => _LocationsOverviewState();
}

class _LocationsOverviewState extends ConsumerState<LocationsOverview> {
  @override
  void initState() {
    super.initState();
    // Call the loadLocations method to fetch data from the database
    Future.microtask(() => ref.read(locationProvider.notifier).loadLocations());
  }

  // Future<List> _getLocations() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   Database db = await sql
  //       .openDatabase(path.join(dbPath, 'vistedLocations.db'), version: 2,
  //           onCreate: (db, version) async {
  //     await db.execute(
  //         'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');
  //   }, onUpgrade: (db, oldVersion, newVersion) async {
  //     await db.execute(
  //         'CREATE TABLE IF NOT EXISTS locations(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');
  //   });

  //   return await db.query('locations');
  // }

  @override
  Widget build(BuildContext context) {
    List<Location> locations = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLocation(),
                  ),
                );
              },
              icon: const Icon(Icons.add_location))
        ],
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          //TODO: replace with list Item
          return Row(
            children: [Text(locations[index].name)],
          );
        },
      ),
    );
  }
}
