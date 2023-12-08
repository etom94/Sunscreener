import 'dart:html';

import 'package:geolocator/geolocator.dart';
import 'dart:async'; // Füge diese Zeile hinzu
import 'vars.dart';

class GPS {
  static void setLocation(double latitude, double longitude) {
    String formattedLocation = '$latitude,$longitude';
    Location.setuserLocation(formattedLocation);
    print('Location set to: $formattedLocation');
  }

  static void checkAndSetLocation() async {
    try {
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (isLocationServiceEnabled) {
        // Wartezeit für getCurrentPosition
        Position position;
        try {
          position = await Future.delayed(
            Duration(seconds: 10),
                () => Geolocator.getCurrentPosition(
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
        print('GPS is disabled. Location not set.');
      }
    } catch (e) {
      print('Error obtaining location: $e');
    }
  }
}

void main() {
  GPS.checkAndSetLocation();
}
