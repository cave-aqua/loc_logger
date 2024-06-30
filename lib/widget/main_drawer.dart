import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loc_logger/widget/drawer_aggregation/main_drawer_list_tile.dart';

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
              onTap: () {}),
          MainDrawerListTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          )
        ],
      ),
    );
  }
}
