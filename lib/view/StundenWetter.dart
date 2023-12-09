import 'package:flutter/material.dart';
import 'package:sunscreenergui2/model/24HourData.dart';

Future<List<HourlyData>> sevenDaysData = fetchHourlyWeatherData();

Widget buildHourlyWeatherWidget() {
  return FutureBuilder<List<HourlyData>>(
    future: fetchHourlyWeatherData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        print("Fehler beim Laden der Daten: ${snapshot.error}");
        return const Text("Fehler beim Laden der Daten");
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("Keine Daten verfügbar");
      } else {
        List<HourlyData> weatherDataList = snapshot.data!;

        for (HourlyData data in weatherDataList) {
          print(data.toString());
        }

        return Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weatherDataList.map((hourlyWeatherData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          hourlyWeatherData.time,
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
                          hourlyWeatherData.weatherIconURL,
                          height: 25,
                          width: 25,
                        ),
                        Text(
                          '${hourlyWeatherData.tempC}°C',
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
