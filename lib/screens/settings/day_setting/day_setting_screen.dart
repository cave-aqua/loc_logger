import 'package:flutter/material.dart';
import 'package:loc_logger/models/settings/day_setting.dart';
import 'package:loc_logger/screens/settings/day_setting/day_setting_row.dart';
import 'package:loc_logger/services/day_settings.dart';

class DaySettingScreen extends StatelessWidget {
  const DaySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getDaySettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              List<DaySetting> daySettings = snapshot.data!;

              return ListView.builder(
                itemCount: daySettings.length,
                itemBuilder: (context, index) {
                  return DaySettingRow(daySetting: daySettings[index]);
                },
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return const Center(
              child: Text('No day settings could be found'),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
