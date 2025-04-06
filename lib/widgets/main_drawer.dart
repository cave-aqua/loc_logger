import 'package:flutter/material.dart';
import 'package:loc_logger/screens/locations/location_overview.dart';
import 'package:loc_logger/screens/settings/setting_screen.dart';
import 'package:loc_logger/screens/test_screen.dart';
import 'package:loc_logger/widgets/drawer_aggregation/main_drawer_list_tile.dart';
import 'package:loc_logger/services/advanced_settings.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool isTestScreenEnabled = false;

  @override
  void initState() {
    _setTestScreenSetting();
    super.initState();
  }

  void _setTestScreenSetting() async {
    isTestScreenEnabled = await isTestScreenOn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MainDrawerListTile(
              icon: Icons.location_city_outlined,
              title: 'Locations',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const LocationsOverview();
                  },
                ));
              }),
          MainDrawerListTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ));
            },
          ),
          if (isTestScreenEnabled)
            MainDrawerListTile(
              icon: Icons.settings,
              title: 'Test',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TestScreen()));
              },
            ),
        ],
      ),
    );
  }
}
