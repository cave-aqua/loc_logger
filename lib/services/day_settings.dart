import 'package:loc_logger/models/settings/day_setting.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

Future<List<DaySetting>> getDaySettings() async {
  Database db = await initDb();

  List daySettings = await db.rawQuery('SELECT * FROM $ACTIVE_DAYS_TABLE');

  if (daySettings.isEmpty) {
    return [];
  }

  List<DaySetting> daySettingModels = [];
  for (var daySetting in daySettings) {
    daySettingModels.add(DaySetting(
        daySetting['id'], daySetting['name'], intToBool(daySetting['active'])));
  }

  return daySettingModels;
}

Future<void> setDaySetting(DaySetting daySetting) async {
  Database db = await initDb();
  db.execute(
      'UPDATE $ACTIVE_DAYS_TABLE SET active = ${daySetting.isActive} WHERE id = ${daySetting.id}');
}

Future<bool> isDayActive(int dayId) async {
  Database db = await initDb();
  int? result = firstIntValue(await db
      .rawQuery('SELECT active FROM $ACTIVE_DAYS_TABLE WHERE id = $dayId'));

  return intToBool(result);
}

bool intToBool(int? value) {
  return value == 1;
}
