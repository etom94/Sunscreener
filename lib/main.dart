
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'view/HomePage.dart';

void main() async {
  await initializeDateFormatting('de_DE', null);

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
