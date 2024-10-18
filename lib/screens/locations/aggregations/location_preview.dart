import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';

class LocationPreviewWidget extends StatelessWidget {
  final LatLng coords;

  const LocationPreviewWidget({super.key, required this.coords});

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();

    FlutterMap flutterMap = FlutterMap(
      options: MapOptions(
        interactionOptions: const InteractionOptions(flags: 0),
        initialZoom: 13,
        initialCenter: coords,
      ),
      mapController: mapController,
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/tor-cave/clss0dve4007f01qt6ejx3gkp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidG9yLWNhdmUiLCJhIjoiY2wxaTdhd2IzMXNiZjNjcDM4dTl1aTZqMyJ9.oY3wdY0mp7DLFVxqs5_MJg',
          userAgentPackageName: 'loc_logger',
        ),
        MarkerLayer(markers: [
          Marker(
              point: coords,
              child: const SizedBox(
                height: 5,
                child: Icon(Icons.location_on),
              ))
        ]),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('Mapbox')],
          showFlutterMapAttribution: false,
        ),
      ],
    );

    return flutterMap;
  }
}
