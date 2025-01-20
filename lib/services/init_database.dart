import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const String VISISTED_LOCATION_TABLE = 'visited_locations';
const String LOCATIONS_TABLE = 'locations';
Future<Database> initDb() async {
  final dbPath = await sql.getDatabasesPath();
  Database db = await sql.openDatabase(path.join(dbPath, 'vistedLocations.db'),
      version: 1, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $LOCATIONS_TABLE(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');

    await db.execute(
      'CREATE TABLE IF NOT EXISTS $VISISTED_LOCATION_TABLE (id TEXT PRIMARY KEY, date_time TEXT NOT NULL, location_id TEXT NOT NULL, FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE CASCADE)',
    );
  });

  return db;
}
