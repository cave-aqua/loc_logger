import 'package:flutter/material.dart';
import 'package:loc_logger/screens/settings/advanced_settings_screen.dart';
import 'package:loc_logger/screens/settings/aggregations/setting_list_item.dart';
import 'package:loc_logger/screens/settings/day_setting/day_setting_screen.dart';
import 'package:loc_logger/screens/settings/excluded_date_settings/excluded_date_setting_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              SettingListItem(
                name: 'Days to be logged',
                settingScreen: DaySettingScreen(),
              ),
              SettingListItem(
                name: 'Excluded dates',
                settingScreen: ExcludedDateSettingScreen(),
              ),
              SettingListItem(
                name: 'Advanced Settings',
                settingScreen: AdvancedSettingsScreen(),
              ),
            ],
          ),
        ));
  }
}
