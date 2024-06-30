import 'package:flutter/material.dart';
import 'package:loc_logger/screens/locations/location_overview.dart';
import 'package:loc_logger/screens/test_screen.dart';
import 'package:loc_logger/widgets/drawer_aggregation/main_drawer_list_tile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MainDrawerListTile(icon: Icons.home, title: 'Home', onTap: () {}),
          MainDrawerListTile(
              icon: Icons.location_city_outlined,
              title: 'Locations',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LocationsOverview();
                  },
                ));
              }),
          MainDrawerListTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          MainDrawerListTile(
            icon: Icons.settings,
            title: 'Test',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestScreen()));
            },
          ),
        ],
      ),
    );
  }
}
