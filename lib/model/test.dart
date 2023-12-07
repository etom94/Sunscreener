import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sunscreenergui2/model/vars.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'tempC': tempC,
      'tempF': tempF,
      'weatherIconURL': weatherIconURL,
      'langDe': langDe,
    };
  }
}

void main() async {
  final location = getLocation();
  final apiUrl = "$baseUrl?key=$apiKey&q=$location&tp=$intervall&format=json&lang=$language&extra=utcDateTime";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<Map<String, dynamic>> hourlyDataList = [];
      List<dynamic> hourlyList = data['data']['weather'][0]['hourly'];
      for (var hourlyData in hourlyList) {
        HourlyData dataPoint = HourlyData(
          time: hourlyData['time'],
          tempC: hourlyData['tempC'],
          tempF: hourlyData['tempF'],
          weatherIconURL: hourlyData['weatherIconUrl'][0]['value'],
          langDe: hourlyData['lang_de'][0]['value'],
        );
        hourlyDataList.add(dataPoint.toJson());
      }

      final File file = File('hourly_data.json');
      file.writeAsStringSync(jsonEncode(hourlyDataList), encoding: utf8);

      print("Daten wurden erfolgreich in die Datei geschrieben.");

    } else {
      print("Fehler bei der API-Anfrage. Statuscode: ${response.statusCode}");
    }
  } catch (e) {
    print("Fehler: $e");
  }
}
