import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/screens/locations/add_location.dart';
import 'package:loc_logger/screens/locations/aggregations/location_list_item.dart';

class LocationsOverview extends ConsumerStatefulWidget {
  const LocationsOverview({super.key});

  @override
  ConsumerState<LocationsOverview> createState() => _LocationsOverviewState();
}

class _LocationsOverviewState extends ConsumerState<LocationsOverview> {
  @override
  void initState() {
    super.initState();
    // Call the loadLocations method to fetch data from the database
    Future.microtask(() => ref.read(locationProvider.notifier).loadLocations());
  }

  @override
  Widget build(BuildContext context) {
    List<Location> locations = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLocation(),
                  ),
                );
              },
              icon: const Icon(Icons.add_location))
        ],
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              ListItemWidget(
                  removeLocation: (locationId) => ref
                      .read(locationProvider.notifier)
                      .removeLocation(locations[index].id),
                  location: locations[index])
            ],
          );
        },
      ),
    );
  }
}
