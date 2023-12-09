import 'package:geolocator/geolocator.dart';
import 'vars.dart';

class GPS {
  static void setLocation(double latitude, double longitude) {
    String formattedLocation = '$latitude,$longitude';
    Location.setuserLocation(formattedLocation);
    print('Location set to: $formattedLocation');
  }

  static Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      print('Location permission granted. Proceeding to get location.');
    } else {
      print('Location permission denied. Location not set.');
    }
  }

  static void checkAndSetLocation() async {
    try {
      bool isLocationServiceEnabled = await Geolocator
          .isLocationServiceEnabled();

      if (isLocationServiceEnabled) {
        // Berechtigungen überprüfen
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          // Berechtigungen anfordern
          await requestLocationPermission();
          // Jetzt erneut überprüfen
          permission = await Geolocator.checkPermission();
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          // Standort abrufen
          Position position;
          try {
            position = await Future.delayed(
              Duration(seconds: 10),
                  () =>
                  Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  ),
            );
          } catch (timeoutError) {
            print('Timeout: Unable to obtain location within 10 seconds.');
            return;
          }

          double latitude = position.latitude;
          double longitude = position.longitude;

          setLocation(latitude, longitude);
        } else {
          print('Location permission denied. Location not set.');
        }
      } else {
        print('GPS is disabled. Location not set.');
      }
    } catch (e) {
      print('Error obtaining location: $e');
    }
  }
}
