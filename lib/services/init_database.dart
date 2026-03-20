import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const String VISISTED_LOCATION_TABLE = 'visited_locations';
const String LOCATIONS_TABLE = 'locations';
const String ACTIVE_DAYS_TABLE = 'active_days';
const String EXCLUDED_DAYS_TABLE = 'excluded_days';

const String ADVANCED_SETTINGS_TABLE = 'advanded_settings';
const String TEST_SCREEN_KEY = 'test_screen';

Future<Database> initDb() async {
  final dbPath = await sql.getDatabasesPath();
  Database db = await sql.openDatabase(
    path.join(dbPath, 'vistedLocations.db'),
    version: 4,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $LOCATIONS_TABLE(id TEXT PRIMARY KEY, name TEXT, lat REAL, long REAL, color TEXT, is_home INTEGER)');

      await db.execute(
        'CREATE TABLE IF NOT EXISTS $VISISTED_LOCATION_TABLE (id TEXT PRIMARY KEY, date_time TEXT NOT NULL, location_id TEXT NOT NULL, FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE CASCADE)',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS $ACTIVE_DAYS_TABLE (id INTEGER PRIMARY KEY, name TEXT NOT NULL, active INTEGER)',
      );

      await addDayRecords(db);

      await db.execute(
          'CREATE TABLE IF NOT EXISTS $EXCLUDED_DAYS_TABLE (key VARCHAR(5), unix_time INTEGER NULL)');

      await addExcludedDayRecords(db);

      await db.execute(
          'CREATE TABLE IF NOT EXISTS $ADVANCED_SETTINGS_TABLE (key VARCHAR PRIMARY key, enabled INTEGER DEFAULT 0)');

      await db.insert(ADVANCED_SETTINGS_TABLE, {
        'key': TEST_SCREEN_KEY,
        'enabled': 0,
      });
    },
  );

  return db;
}

Future<void> addDayRecords(Database db) async {
  await db.insert(ACTIVE_DAYS_TABLE, {'id': 1, 'name': 'Monday', 'active': 0});
  await db.insert(ACTIVE_DAYS_TABLE, {'id': 2, 'name': 'Tuesday', 'active': 0});
  await db
      .insert(ACTIVE_DAYS_TABLE, {'id': 3, 'name': 'Wednesday', 'active': 0});
  await db
      .insert(ACTIVE_DAYS_TABLE, {'id': 4, 'name': 'Thursday', 'active': 0});
  await db.insert(ACTIVE_DAYS_TABLE, {'id': 5, 'name': 'Friday', 'active': 0});
  await db
      .insert(ACTIVE_DAYS_TABLE, {'id': 6, 'name': 'Saturday', 'active': 0});
  await db.insert(ACTIVE_DAYS_TABLE, {'id': 7, 'name': 'Sunday', 'active': 0});
}

Future<void> addExcludedDayRecords(Database db) async {
  await db.insert(EXCLUDED_DAYS_TABLE, {'key': 'from', 'unix_time': null});
  await db.insert(EXCLUDED_DAYS_TABLE, {'key': 'until', 'unix_time': null});
}

Future<void> dropAllTables(Database db) async {
  await db.execute('DROP TABLE IF EXISTS $VISISTED_LOCATION_TABLE');
  await db.execute('DROP TABLE IF EXISTS $LOCATIONS_TABLE');
  await db.execute('DROP TABLE IF EXISTS $ACTIVE_DAYS_TABLE');
  await db.execute('DROP TABLE IF EXISTS $EXCLUDED_DAYS_TABLE');
  await db.execute('DROP TABLE IF EXISTS $ADVANCED_SETTINGS_TABLE');
}
