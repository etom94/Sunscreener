import 'package:geolocator/geolocator.dart';
import 'vars.dart';

class GPS {
  static void setLocation(double latitude, double longitude) {
    // Implementieren Sie hier die Logik zum Speichern der Koordinaten
    String formattedLocation = '$latitude,$longitude';
    Location.setuserLocation(formattedLocation);
    print('Location set to: $formattedLocation');
  }

  static void checkAndSetLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      // GPS ist aktiviert
      Position position = await Geolocator.getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      setLocation(latitude, longitude);
    } else {
      // GPS ist deaktiviert
        print('GPS is disabled. Location not set.');
    }
  }
}

void main() {
  GPS.checkAndSetLocation();
}
