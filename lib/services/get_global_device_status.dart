import 'package:geolocator/geolocator.dart';

Future<Position?> getGlobalDeviceStatus() async {
  LocationPermission locationPermission = await Geolocator.checkPermission();
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (locationPermission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
