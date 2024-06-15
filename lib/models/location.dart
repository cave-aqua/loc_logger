import 'dart:ui';

class Location {
  final String id;
  final String name;
  final double lat;
  final double long;
  final Color color;
  final bool isHome;

  Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.color,
    required this.isHome,
  });
}
