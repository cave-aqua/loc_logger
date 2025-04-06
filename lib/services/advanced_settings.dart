import 'dart:ffi';

import 'package:loc_logger/services/day_settings.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> isTestScreenOn() async {
  Database db = await initDb();

  List result = await db.query(ADVANCED_SETTINGS_TABLE,
      where: 'key = ?', whereArgs: [TEST_SCREEN_KEY]);

  return intToBool(result.first['enabled']);
}

Future<bool> setTestScreenSetting(bool value) async {
  Database db = await initDb();

  int res = await db.update(
    ADVANCED_SETTINGS_TABLE,
    {'enabled': value},
    where: 'key = ?',
    whereArgs: [TEST_SCREEN_KEY],
  );

  return intToBool(res);
}
