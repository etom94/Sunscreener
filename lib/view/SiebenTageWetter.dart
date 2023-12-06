import 'package:flutter/material.dart';
import '../model/7DayData.dart';

// Funktion für den asynchronen Aufruf der Wetterdaten
  Future<List<WeatherData>> sevenDaysData = fetchSevenDaysWeatherData();


// Deine bestehende Funktion zum Erstellen des Widget
Widget buildWeatherWidget() {
  return FutureBuilder<List<WeatherData>>(
    // Hier rufst du die Funktion für die Wetterdaten auf
    future: fetchSevenDaysWeatherData(), // Hier den gewünschten Ort einfügen
    builder: (context, snapshot) {
      // Prüfe, ob Daten verfügbar sind
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // Zeige einen Ladeindikator, während die Daten geladen werden
      } else if (snapshot.hasError) {
        return const Text("Fehler beim Laden der Daten"); // Zeige eine Fehlermeldung, wenn ein Fehler auftritt
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("Keine Daten verfügbar"); // Zeige eine Nachricht, wenn keine Daten vorhanden sind
      } else {
        // Daten sind verfügbar, erstelle das Widget mit den Wetterdaten
        List<WeatherData> weatherDataList = snapshot.data!;

        return Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: weatherDataList.map((weatherData) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        weatherData.date,
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
                        // Hier kannst du die Größe oder andere Eigenschaften der Grafik anpassen
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
        );
      }
    },
  );
}
