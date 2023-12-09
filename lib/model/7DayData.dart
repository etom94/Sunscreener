import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vars.dart';

class WeatherData {
  final String date;
  final String weatherIconUrl;
  final String weatherDescDe;
  final int maxTempC;
  final int maxTempF;
  final int minTempC;
  final int minTempF;
  final String weatherCode; // Neu hinzugefügtes Feld

  WeatherData({
    required this.date,
    required this.weatherIconUrl,
    required this.weatherDescDe,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.weatherCode,
  });


  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final hourly = json['hourly'] ?? [];
    final weatherIconUrl = json['hourly']?[0]['weatherIconUrl']?[0]['value'] ?? "";
    final weatherDescDe = hourly?[0]['lang_de']?[0]['value'] ?? "";

    return WeatherData(
      date: json['date'] ?? "",
      weatherIconUrl: weatherIconUrl,
      weatherDescDe: weatherDescDe,
      maxTempC: int.parse(json['maxtempC'] ?? "0"),
      maxTempF: int.parse(json['maxtempF'] ?? "0"),
      minTempC: int.parse(json['mintempC'] ?? "0"),
      minTempF: int.parse(json['mintempF'] ?? "0"),
      // Füge das weatherCode-Feld hinzu, wenn es in den API-Daten vorhanden ist
      weatherCode: json['weatherCode'] ?? "",
    );
  }

  @override
  String toString() {
    return '''
      Date: $date
      Weather Icon URL: $weatherIconUrl
      Weather Description: $weatherDescDe
      Max Temperature: $maxTempC°C / $maxTempF°F
      Min Temperature: $minTempC°C / $minTempF°F
    ''';
  }
}

Future<List<WeatherData>> fetchSevenDaysWeatherData() async {
  final location = Location.getuserLocation();

  try {
    final url7Days = Uri.parse(
        "$baseUrl?key=$apiKey&q=$location&num-of-days=$days&format=json&lang=$language");
    final response7Days = await http.get(url7Days);

    if (response7Days.statusCode == 200) {
      final data7Days = utf8.decode(response7Days.bodyBytes);

      final dynamic decodedData = json.decode(data7Days);

      if (decodedData is Map) {
        final List<dynamic> dailyForecasts = decodedData['data']['weather'];
        final List<WeatherData> weatherDataList = dailyForecasts.map((
            dailyData) => WeatherData.fromJson(dailyData)).toList();

        return weatherDataList;
      } else {
        print("Fehler beim Dekodieren der JSON-Daten.");
        throw Exception("Fehler beim Dekodieren der JSON-Daten.");
      }
    } else {
      print("Fehler beim Abrufen der Daten. Statuscode: ${response7Days
          .statusCode}");
      throw Exception(
          "Fehler beim Abrufen der Wetterdaten. Statuscode: ${response7Days
              .statusCode}");
    }
  } catch (e) {
    print("Fehler: $e");
    throw Exception("Fehler beim Abrufen der Wetterdaten.");
  }
}
