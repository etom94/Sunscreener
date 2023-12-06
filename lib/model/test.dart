import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vars.dart';

class HourlyWeatherData {
  final int time;
  final int tempC;
  final int tempF;
  final String weatherDescDe;
  final String weatherIconUrl;

  HourlyWeatherData({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.weatherDescDe,
    required this.weatherIconUrl,
  });

  factory HourlyWeatherData.fromJson(Map<String, dynamic> json) {
    final weatherDescDe = json['weatherDesc']?[0]['lang_de']?[0]['value'] ?? "";
    final weatherIconUrl = json['weatherIconUrl']?[0]['value'] ?? "";

    return HourlyWeatherData(
      time: int.parse(json['time'] ?? "0"),
      tempC: int.parse(json['tempC'] ?? "0"),
      tempF: int.parse(json['tempF'] ?? "0"),
      weatherDescDe: weatherDescDe,
      weatherIconUrl: weatherIconUrl,
    );
  }





  int get firstTime => time;
  int get firstTempC => tempC;
  String get firstWeatherDescDe => weatherDescDe;

  @override
  String toString() {
    return '''
      Time: $time
      Temperature: $tempC°C / $tempF°F
      Weather Description (DE): $weatherDescDe
      Weather Icon URL: $weatherIconUrl
    ''';
  }
}

Future<List<HourlyWeatherData>> fetchHourlyWeatherData() async {
  final location = getLocation();

  try {
    final urlHourly = Uri.parse("$baseUrl?key=$apiKey&q=$location&tp=$intervall&format=json&lang=$language");
    final responseHourly = await http.get(urlHourly);

    if (responseHourly.statusCode == 200) {
      final dataHourly = json.decode(responseHourly.body);

      // Ausgabe der unformatierten API-Antwort
      print("Unformatierte API-Antwort:");
      print(responseHourly.body);

      if (dataHourly is Map && dataHourly['data'] != null && dataHourly['data']['hourly'] != null) {
        final List<dynamic> hourlyForecasts = dataHourly['data']['hourly'];
        final List<HourlyWeatherData> hourlyWeatherDataList = hourlyForecasts.map((
            hourlyData) => HourlyWeatherData.fromJson(hourlyData)).toList();

        // Ausgabe der Daten in die Konsole
        for (var hourlyData in hourlyWeatherDataList) {
          print(hourlyData);
        }

        return hourlyWeatherDataList;
      } else {
        print("Unerwartete Datenstruktur in der API-Antwort.");
        throw Exception("Unerwartete Datenstruktur in der API-Antwort.");
      }
    } else {
      print("Fehler beim Abrufen der Daten. Statuscode: ${responseHourly.statusCode}");
      throw Exception(
          "Fehler beim Abrufen der Wetterdaten. Statuscode: ${responseHourly.statusCode}");
    }
  } catch (e) {
    print("Fehler: $e");
    throw Exception("Fehler beim Abrufen der Wetterdaten.");
  }
}

void main() async {
  try {
    List<HourlyWeatherData> hourlyWeatherDataList = await fetchHourlyWeatherData();
    // Du kannst die Daten hier weiter verarbeiten, wenn nötig
  } catch (e) {
    print("Fehler beim Abrufen der Wetterdaten: $e");
  }
}

