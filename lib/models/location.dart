import 'dart:ui';

class Location {
  String id;
  String name;
  double lat;
  double long;
  Color color;
  bool isHome;

  Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.color,
    required this.isHome,
  });
}
