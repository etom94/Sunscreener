import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vars.dart';

class HourlyData {
  final String time;
  final String tempC;
  final String tempF;
  final String weatherIconURL;
  final String langDe;

  HourlyData({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.weatherIconURL,
    required this.langDe,
  });
}

class CurrentConditionData {
  final String tempC;
  final String tempF;
  final String weatherIconURL;
  final String langDe;

  CurrentConditionData({
    required this.tempC,
    required this.tempF,
    required this.weatherIconURL,
    required this.langDe,
  });
}

Future<List<HourlyData>> fetchHourlyWeatherData() async {
  final location = getLocation();
  final apiUrl = "$baseUrl?key=$apiKey&q=$location&tp=$intervall&format=json&lang=$language&extra=utcDateTime";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<HourlyData> hourlyDataList = [];
      List<dynamic> hourlyList = data['data']['weather'][0]['hourly'];
      for (var hourlyData in hourlyList) {
        HourlyData dataPoint = HourlyData(
          time: convertMinutesToTime(hourlyData['time']),
          tempC: hourlyData['tempC'],
          tempF: hourlyData['tempF'],
          weatherIconURL: hourlyData['weatherIconUrl'][0]['value'],
          langDe: hourlyData['lang_de'][0]['value'],
        );
        hourlyDataList.add(dataPoint);
      }

      return hourlyDataList;
    } else {
      print("Fehler bei der API-Anfrage. Statuscode: ${response.statusCode}");
      throw Exception("Fehler bei der API-Anfrage. Statuscode: ${response.statusCode}");
    }
  } catch (e) {
    print("Fehler: $e");
    throw Exception("Fehler bei der Verarbeitung.");
  }
}

// Funktion zur Umwandlung von Minuten-String in Stunden und Minuten-String
String convertMinutesToTime(String minutesString) {
  int minutes = int.parse(minutesString);
  int hours = (minutes ~/ 100); // Ganzzahldivision, um Stunden zu erhalten
  int mins = minutes % 100; // Modulo, um Minuten zu erhalten

  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = mins.toString().padLeft(2, '0');

  return "$formattedHours:$formattedMinutes";
}


Future<List<CurrentConditionData>> fetchCurrentConditionData() async {
  final location = getLocation();
  final apiUrl = "$baseUrl?key=$apiKey&q=$location&tp=$intervall&format=json&lang=$language&extra=utcDateTime";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<CurrentConditionData> currentConditionDataList = [];
      List<dynamic> currentConditionList = data['data']['current_condition'];
      for (var currentConditionData in currentConditionList) {
        CurrentConditionData dataPoint = CurrentConditionData(
          tempC: currentConditionData['temp_C'],
          tempF: currentConditionData['temp_F'],
          weatherIconURL: currentConditionData['weatherIconUrl'][0]['value'],
          langDe: currentConditionData['lang_de'][0]['value'],
        );
        currentConditionDataList.add(dataPoint);
      }

      return currentConditionDataList;
    } else {
      print("Fehler bei der API-Anfrage. Statuscode: ${response.statusCode}");
      throw Exception("Fehler bei der API-Anfrage. Statuscode: ${response.statusCode}");
    }
  } catch (e) {
    print("Fehler: $e");
    throw Exception("Fehler bei der Verarbeitung.");
  }
}


void main() async {
  try {
    List<HourlyData> hourlyDataList = await fetchHourlyWeatherData();
    List<CurrentConditionData> currentConditionDataList = await fetchCurrentConditionData();

    // Ausgabe der gespeicherten Werte für hourly
    for (var dataPoint in hourlyDataList) {
      print("Hourly - Time: ${dataPoint.time}, TempC: ${dataPoint.tempC}, TempF: ${dataPoint.tempF}, WeatherIconURL: ${dataPoint.weatherIconURL}, LangDe: ${dataPoint.langDe}");
    }

    // Ausgabe der gespeicherten Werte für current_condition
    for (var dataPoint in currentConditionDataList) {
      print("Current Condition - TempC: ${dataPoint.tempC}, TempF: ${dataPoint.tempF}, WeatherIconURL: ${dataPoint.weatherIconURL}, LangDe: ${dataPoint.langDe}");
    }
  } catch (e) {
    print("Fehler: $e");
  }
}