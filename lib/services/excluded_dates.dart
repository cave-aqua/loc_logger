import 'package:loc_logger/models/settings/excluded_day.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:sqflite/sqflite.dart';

Future<void> saveExcludedDates(
    ExcludedDateSettings excludedDateSettings) async {
  Database db = await initDb();

  Batch batch = db.batch();
  batch.update(EXCLUDED_DAYS_TABLE,
      {'date': excludedDateSettings.fromDate?.millisecondsSinceEpoch},
      where: 'key = from');
  batch.update(EXCLUDED_DAYS_TABLE,
      {'date': excludedDateSettings.untilDate?.millisecondsSinceEpoch},
      where: 'key = until');

  await batch.commit();
}

Future<ExcludedDateSettings> getExcludedDateSetting() async {
  Database db = await initDb();
  ExcludedDateSettings excludedDate = ExcludedDateSettings();

  List result = await db.query('SELECT * FROM $EXCLUDED_DAYS_TABLE');

  for (var element in result) {
    if (element['key'] == 'from') {
      excludedDate.fromDate =
          DateTime.fromMillisecondsSinceEpoch(element['unix_time']);
    } else if (element['key'] == 'until') {
      DateTime.fromMillisecondsSinceEpoch(element['unix_time']);
    }
  }

  return excludedDate;
}

bool isCurrentDateExcluded(ExcludedDateSettings excludedDateSettings) {
  DateTime now = DateTime.now();

  if (excludedDateSettings.untilDate != null &&
      excludedDateSettings.fromDate != null) {
    return now.isBefore(excludedDateSettings.untilDate!) &&
        now.isAfter(excludedDateSettings.fromDate!);
  }

  return false;
}
