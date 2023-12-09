import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'vars.dart';
import 'package:permission_handler/permission_handler.dart';

class GPS {
  static Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      print('Location permission granted. Proceeding to get location.');
    } else {
      print('Location permission denied. Location not set.');
    }
  }

  static Future<void> checkAndSetLocation() async {
    try {
      // Überprüfen Sie die Standortberechtigungen
      var status = await Permission.location.status;
      if (status == PermissionStatus.denied) {
        // Berechtigungen anfordern
        await Permission.location.request();
      }

      // Überprüfen Sie, ob der Standortdienst aktiviert ist
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (status == PermissionStatus.granted) {
        if (!isLocationServiceEnabled) {
          // Standortdienst ist deaktiviert, aktivieren Sie ihn
          await Geolocator.openLocationSettings();
          return;
        }

        // Get location
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

        // Call the weather API to get areaName
        await getAreaName(latitude, longitude);
      } else {
        print('Location permission denied. Location not set.');
      }
    } catch (e) {
      print('Error obtaining location: $e');
    }
  }

  static Future<void> getAreaName(double latitude, double longitude) async {
    try {
      String formattetLocation = '$latitude,$longitude';
      final String apiUrl =
          'http://api.worldweatheronline.com/premium/v1/weather.ashx?key=f561941c401e447082f232805230512&q=$formattetLocation&format=json&num_of_days=1&extra=no&date=no&fx=no&cc=no&mca=no&fx24=no&includelocation=yes&show_comments=no&tp=no&showlocaltime=no&callback=no&lang=no&alerts=no&aqi=no';
      final Uri uri = Uri.parse(apiUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        String responseBody = response.body;

        // Entferne unerwünschte Zeichen am Anfang und Ende der JSON-Antwort
        if (responseBody.startsWith('no(') && responseBody.endsWith(')')) {
          responseBody = responseBody.substring(3, responseBody.length - 1);
        }

        Map<String, dynamic> data = json.decode(responseBody);
        String areaName =
        data['data']['nearest_area'][0]['areaName'][0]['value'];

        // Set location using areaName
        print('Areaname:::::::::::' + areaName);
        Location.setuserLocation(areaName);
        print('AreaName set to: $areaName');
      } else {
        print('Failed to get areaName. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting areaName: $e');
    }
  }
}
