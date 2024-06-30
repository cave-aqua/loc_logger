import 'package:flutter/material.dart';
import 'package:loc_logger/screens/locations/add_location.dart';

class LocationsOverview extends StatelessWidget {
  const LocationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddLocation()));
              },
              icon: const Icon(Icons.add_location))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {},
      ),
    );
  }
}
