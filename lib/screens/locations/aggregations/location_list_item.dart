import 'package:flutter/material.dart';
import 'package:loc_logger/models/location.dart';

class ListItemWidget extends StatelessWidget {
  final void Function(String locationId) removeLocation;

  final Location location;

  const ListItemWidget({
    required this.removeLocation,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Dismissible(
        key: Key(location.id),
        onDismissed: (direction) => removeLocation(location.id),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(location.name,
                  style: Theme.of(context).textTheme.titleLarge),
              if (location.isHome)
                const SizedBox(
                  child: Icon(Icons.home),
                )
            ],
          ),
        ),
      ),
    );
  }
}
