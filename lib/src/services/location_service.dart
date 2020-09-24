import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static String country;
  static Future<String> fetchCountryCode() async {
    try {
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await getLastKnownPosition();
        final address = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        address.forEach((element) {
          print(element.name);
        });
        country = address.first.country;
        return address.first.isoCountryCode;
      } else if (permission == LocationPermission.denied) {
        //request permission
        await requestPermission();
        return fetchCountryCode();
      } else {
        country = "United States";
        return "US";
      }
    } catch (e) {
      print("Location error: $e");
      country = "United States";
      return "US";
    }
  }
}
