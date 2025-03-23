import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loc_logger/models/settings/excluded_day.dart';
import 'package:loc_logger/services/excluded_dates.dart';

class ExcludedDateSettingScreen extends StatefulWidget {
  const ExcludedDateSettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExcludedDateSettingScreeenState();
}

class _ExcludedDateSettingScreeenState
    extends State<ExcludedDateSettingScreen> {
  late ExcludedDateSettings excludedDateSettings;

  @override
  void initState() {
    _getSettings();
    super.initState();
  }

  _getSettings() async {
    await getExcludedDateSetting();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    TextEditingController fromDate = TextEditingController();
    TextEditingController untilDate = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluded date ranges'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: fromDate,
                      readOnly: true,
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: untilDate,
                      readOnly: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 2),
                  onPressed: () async {
                    DateTimeRange? dateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(currentDate.year + 1,
                          currentDate.month, currentDate.day),
                    );

                    if (dateRange != null) {
                      fromDate.text =
                          DateFormat('dd-MM-yyyy').format(dateRange.start);
                      untilDate.text =
                          DateFormat('dd-MM-yyyy').format(dateRange.end);
                    }
                  },
                  icon: const Icon(Icons.date_range_outlined),
                ),
                IconButton.filledTonal(
                    onPressed: () {
                      saveExcludedDates(excludedDateSettings);
                    },
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 2),
                    icon: const Icon(Icons.save))
              ],
            )
          ],
        ),
      ),
    );
  }
}
