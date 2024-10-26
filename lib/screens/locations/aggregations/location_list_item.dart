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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, location.color],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(location.name,
                  style: Theme.of(context).textTheme.titleLarge),
              if (location.isHome)
                const SizedBox(
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
