import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loc_logger/services/get_global_device_status.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select a location'),
      ),
      body: FutureBuilder(
        future: getGlobalDeviceStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return FlutterMap(
              options: MapOptions(
                initialCenter:
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                onLongPress: (tapPosition, point) {
                  Navigator.pop(context, point);
                  setState(() {});
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/tor-cave/clss0dve4007f01qt6ejx3gkp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidG9yLWNhdmUiLCJhIjoiY2wxaTdhd2IzMXNiZjNjcDM4dTl1aTZqMyJ9.oY3wdY0mp7DLFVxqs5_MJg',
                  userAgentPackageName: 'loc_logger',
                ),
                const RichAttributionWidget(
                  attributions: [TextSourceAttribution('Mapbox')],
                  showFlutterMapAttribution: false,
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
