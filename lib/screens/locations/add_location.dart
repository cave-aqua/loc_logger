import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:geodesy/geodesy.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/screens/locations/aggregations/location_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class AddLocation extends ConsumerStatefulWidget {
  const AddLocation({super.key});

  @override
  ConsumerState<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends ConsumerState<AddLocation> {
  // We need this to the validate form.
  final _formKey = GlobalKey<FormState>();
  bool isHome = false;
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  LatLng? coords;
  Color pickedColor =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  void dispose() {
    // Need to make sure that the controllers are killed when we are done.
    nameController.dispose();
    super.dispose();
  }

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

    if (coords == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location has not been set')),
      );
      return;
    }

    Location location = Location(
      id: const Uuid().v4(),
      name: nameController.text,
      lat: coords!.latitude,
      long: coords!.longitude,
      color: pickedColor,
      isHome: isHome,
    );

    ref.read(locationProvider.notifier).addLocation(location);

    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 2),
                      onPressed: () async {
                        coords = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LocationPicker(),
                            ));
                      },
                      icon: const Icon(Icons.add_location)),
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
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isHome,
                      onChanged: (value) {
                        setState(() {
                          isHome = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ColorPicker(
                onColorChanged: (pickedColor) {
                  pickedColor = pickedColor;
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
