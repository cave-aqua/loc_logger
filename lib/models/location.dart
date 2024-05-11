import 'dart:ffi';
import 'dart:ui';

class Location {
  final String id;
  final String name;
  final Float lat;
  final Float long;
  final Color color;
  final Bool isHome;

  Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.color,
    required this.isHome,
  });
}
