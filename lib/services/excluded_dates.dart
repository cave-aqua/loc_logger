import 'package:loc_logger/models/settings/excluded_day.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';

Future<void> saveExcludedDates(
    ExcludedDateSettings excludedDateSettings) async {
  Database db = await initDb();

  Batch batch = db.batch();

  batch.update(
    EXCLUDED_DAYS_TABLE,
    {'unix_time': excludedDateSettings.fromDate?.millisecondsSinceEpoch},
    where: 'key = ?',
    whereArgs: ['from'],
  );

  batch.update(
    EXCLUDED_DAYS_TABLE,
    {'unix_time': excludedDateSettings.untilDate?.millisecondsSinceEpoch},
    where: 'key = ?',
    whereArgs: ['until'],
  );

  await batch.commit();
}

Future<ExcludedDateSettings> getExcludedDateSetting() async {
  Database db = await initDb();
  ExcludedDateSettings excludedDate = ExcludedDateSettings();

  List result = await db.rawQuery('SELECT * FROM $EXCLUDED_DAYS_TABLE');

  for (var element in result) {
    if (element['key'] == 'from') {
      if (element['unix_time'] != null) {
        excludedDate.fromDate =
            DateTime.fromMillisecondsSinceEpoch(element['unix_time']);
      } else {
        excludedDate.fromDate = null;
      }
    } else if (element['key'] == 'until') {
      if (element['unix_time'] != null) {
        excludedDate.untilDate =
            DateTime.fromMillisecondsSinceEpoch(element['unix_time']);
      } else {
        excludedDate.untilDate = null;
      }
    }
  }

  return excludedDate;
}

Future<bool> isCurrentDateExcluded() async {
  ExcludedDateSettings excludedDateSettings = await getExcludedDateSetting();
  DateTime current = DateTime.now();
  int now = current.millisecondsSinceEpoch;

  if (excludedDateSettings.untilDate != null &&
      excludedDateSettings.fromDate != null) {
    int fromMill = excludedDateSettings.fromDate!.millisecondsSinceEpoch;
    int untilMill = excludedDateSettings.untilDate!.millisecondsSinceEpoch;

    return now >= fromMill && now <= untilMill;
  }

  return false;
}
