// vars.dart
import 'package:flutter/foundation.dart';

const String apiKey = "f561941c401e447082f232805230512";
const String baseUrl = "http://api.worldweatheronline.com/premium/v1/weather.ashx";
const String language = "de";
const int days = 7;
const int intervall = 1;


class Location extends ChangeNotifier {
  static String userLocation = "Basel";

  static final Location _instance = Location._();
  factory Location() => _instance;

  final ChangeNotifier _locationChangeNotifier = ChangeNotifier();
  ChangeNotifier get locationChangeNotifier => _locationChangeNotifier;

  Location._();

  static String getuserLocation() {
    return userLocation;
  }

  static void setuserLocation(String newLocation) {
    userLocation = newLocation;
    _instance._locationChangeNotifier.notifyListeners();
  }
}

class locationSettings {
  static bool _locationEnabled = false;

  static bool getlocationEnabled() => _locationEnabled;

  static setlocationEnabled(bool value) {
    _locationEnabled = value;
  }
}