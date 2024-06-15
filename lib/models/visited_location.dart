import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class VistedLocation {
  final String id;
  final String dateTime;
  final String locationId;

  VistedLocation({
    required this.id,
    required this.dateTime,
    required this.locationId,
  });

  DateTime? getDate() {
    return DateTime.tryParse(dateTime);
  }

  String? getFormattedDate() {
    initializeDateFormatting('nl_NL');
    DateFormat formatter = DateFormat('dd-MM-yyyy | HH:mm:ss');
    DateTime? date = getDate();

    if (date != null) {
      return formatter.format(date);
    }

    return null;
  }
}
