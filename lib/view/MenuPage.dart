import 'package:flutter/material.dart';
import '../model/locationSettings.dart';
import '../model/vars.dart';
import '../model/SearchHelp.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool locationEnabled = locationSettings.getlocationEnabled();
  double horizontalPadding = 15.0;
  TextEditingController citySearchController = TextEditingController();
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 40.0,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 0,
            ),
          ],
        ),
        title: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Menü',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Standortabfrage',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: locationEnabled,
                      onChanged: (value) {
                        setState(() {
                          locationEnabled = value;
                          locationSettings.setlocationEnabled(value);
                          if (locationEnabled) {
                            GPS.checkAndSetLocation();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Wrap WeatherSearch with Expanded
            Expanded(
              child: WeatherSearch(),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  // Hier kannst du beliebige Widgets oder Inhalte hinzufügen
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
