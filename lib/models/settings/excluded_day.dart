class ExcludedDateSettings {
  DateTime? fromDate;
  DateTime? untilDate;

  ExcludedDateSettings({this.fromDate, this.untilDate});

  ExcludedDateSettings.fromMap(map)
      : fromDate = map['date_time'],
        untilDate = map['location_id'];
}
