// main.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Füge diese Zeile hinzu
import 'view/HomePage.dart';

void main() async {
  // Initialisiere die Lokalisierung für deutsche Datums- und Zeitformate
  await initializeDateFormatting('de_DE', null);

  // Starte die Flutter-Anwendung
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunscreener App',
      home: const MyHomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
