import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/screens/locations/aggregations/location_picker.dart';
import 'package:loc_logger/screens/locations/aggregations/location_preview.dart';
import 'package:loc_logger/services/get_global_device_status.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class LocationDetailWidget extends ConsumerStatefulWidget {
  final Location initialLocation;

  const LocationDetailWidget({super.key, required this.initialLocation});

  @override
  ConsumerState<LocationDetailWidget> createState() =>
      _LocationDetailWidgetState();
}

class _LocationDetailWidgetState extends ConsumerState<LocationDetailWidget> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  void _savePlace() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing data')),
      );
      return;
    }

    ref.read(locationProvider.notifier).updateLocation(Location(
          id: widget.initialLocation.id,
          name: nameController.text,
          lat: widget.initialLocation.lat,
          long: widget.initialLocation.long,
          color: widget.initialLocation.color,
          isHome: widget.initialLocation.isHome,
        ));

    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.initialLocation.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Name of location'),
                controller: nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 180,
                  child: LocationPreviewWidget(
                      coords: LatLng(widget.initialLocation.lat,
                          widget.initialLocation.long))),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 9,
                    fit: FlexFit.tight,
                    child: IconButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 2),
                        onPressed: () async {
                          LatLng newCoords = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LocationPicker(),
                              ));
                          widget.initialLocation.lat = newCoords.latitude;
                          widget.initialLocation.long = newCoords.longitude;
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_location)),
                  ),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: IconButton(
                        icon: const Icon(Icons.gps_fixed),
                        onPressed: () async {
                          Position? pos = await getGlobalDeviceStatus();
                          if (pos == null) {
                            return;
                          }

                          setState(() {
                            widget.initialLocation.lat = pos.latitude;
                            widget.initialLocation.long = pos.longitude;
                          });
                        },
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is this location home?'),
                  SizedBox(
                    height: 20,
                    child: Switch(
                      value: widget.initialLocation.isHome,
                      onChanged: (value) {
                        setState(() {
                          widget.initialLocation.isHome = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ColorPicker(
                color: widget.initialLocation.color,
                enableShadesSelection: false,
                title: const Text('Pick a color for your location'),
                enableTonalPalette: false,
                enableOpacity: false,
                onColorChanged: (choosenColor) {
                  widget.initialLocation.color = choosenColor.withOpacity(1);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add place'))
            ],
          ),
        ),
      ),
    );
  }
}
