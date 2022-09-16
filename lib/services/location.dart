import 'package:geolocator/geolocator.dart';

class Location {
  double latitude1;
  double longitude1;

  Future<void> getcurrentlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      latitude1 = position.latitude;
      longitude1 = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
