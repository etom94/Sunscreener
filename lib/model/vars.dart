// vars.dart
import 'package:flutter/foundation.dart';

const String apiKey = "f561941c401e447082f232805230512";
const String baseUrl = "http://api.worldweatheronline.com/premium/v1/weather.ashx";
const String language = "de";
const int days = 7;
const int intervall = 1;


class Location extends ChangeNotifier {
  // Defaultwert setzen, falls der Benutzer noch keinen Ort eingegeben hat
  static String userLocation = "basel";

  // ChangeNotifier-Instanz erstellen
  static final Location _instance = Location._();
  factory Location() => _instance;

  // Location-Change-Notifier
  final ChangeNotifier _locationChangeNotifier = ChangeNotifier();
  ChangeNotifier get locationChangeNotifier => _locationChangeNotifier;

  Location._();

  // Getter für userLocation
  static String getuserLocation() {
    return userLocation;
  }

  // Setter für userLocation
  static void setuserLocation(String newLocation) {
    userLocation = newLocation;
    // Benachrichtigen Sie Listener über die Änderung
    _instance._locationChangeNotifier.notifyListeners();
  }
}


//☁️🌧️🌦️⛅☀️🌧️❄️🌩️