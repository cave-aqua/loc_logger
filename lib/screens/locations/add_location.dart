import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  // We need this to the validate form.
  final formKey = GlobalKey<FormState>();
  bool isHome = false;
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  Color pickedColor =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  void dispose() {
    // Need to make sure that the controllers are killed when we are done.
    nameController.dispose();
    super.dispose();
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
            child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name of location'),
              controller: nameController,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Lat'),
                        keyboardType: TextInputType.number,
                        controller: latController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Long'),
                    keyboardType: TextInputType.number,
                    controller: longController,
                  ),
                ),
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
            MaterialPicker(
              pickerColor: pickedColor,
              onColorChanged: (value) {
                setState(() {
                  pickedColor = value;
                });
              },
            )
          ],
        )),
      ),
    );
  }
}
