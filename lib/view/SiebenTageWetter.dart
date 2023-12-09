import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/7DayData.dart';


Future<List<WeatherData>> sevenDaysData = fetchSevenDaysWeatherData();

String convertDateToDay(String date) {
  DateTime dateTime = DateTime.parse(date);

  String dayOfWeek = DateFormat.E('de_DE').format(dateTime);
  return dayOfWeek;
}

Widget buildWeatherWidget() {
  return FutureBuilder<List<WeatherData>>(
    future: fetchSevenDaysWeatherData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Text("Fehler beim Laden der Daten");
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("Keine Daten verfügbar");
      } else {
        List<WeatherData> weatherDataList = snapshot.data!;
        return Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weatherDataList.map((weatherData) {
                  String dayOfWeek = convertDateToDay(weatherData.date);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dayOfWeek,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          weatherData.weatherIconUrl,
                        ),
                        Text(
                          '${weatherData.minTempC} / ${weatherData.maxTempC}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }
    },
  );
}
