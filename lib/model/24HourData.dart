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
    final hourlyData = json['hourly'] ?? [];
    final weatherDescDe = hourlyData[0]['lang_de']?[0]['value'] ?? "";
    final weatherIconUrl = hourlyData[0]['weatherIconUrl']?[0]['value'] ?? "";

    return HourlyWeatherData(
      time: int.parse(hourlyData[0]['time'] ?? "0"),
      tempC: int.parse(hourlyData[0]['tempC'] ?? "0"),
      tempF: int.parse(hourlyData[0]['tempF'] ?? "0"),
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

      if (dataHourly is Map) {
        final List<dynamic> hourlyForecasts = dataHourly['data']['hourly'];
        final List<HourlyWeatherData> hourlyWeatherDataList = hourlyForecasts.map((
            hourlyData) => HourlyWeatherData.fromJson(hourlyData)).toList();

        return hourlyWeatherDataList;
      } else {
        print("Fehler beim Dekodieren der JSON-Daten.");
        throw Exception("Fehler beim Dekodieren der JSON-Daten.");
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
