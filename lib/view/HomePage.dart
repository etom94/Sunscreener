import 'package:flutter/material.dart';
import '../model/vars.dart';
import 'MenuPage.dart';
import 'SiebenTageWetter.dart';
import 'StundenWetter.dart';
import '../model/24HourData.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isWeatherWidgetSelected = true;
  List<CurrentConditionData> currentDataList = [];
  Location location = Location();

  @override
  void initState() {
    super.initState();

    fetchData();


    location.locationChangeNotifier.addListener(() {
      setState(() {
        fetchData();
      });
    });
  }


  void fetchData() {
    fetchCurrentConditionData().then((data) {
      setState(() {
        currentDataList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Object tempC = currentDataList.isNotEmpty ? currentDataList.first.tempC : 0;
    String firstWeatherDescDe = currentDataList.isNotEmpty ? currentDataList.first.langDe : "";

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
              },
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            Location.getuserLocation(),
            style: const TextStyle(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "$tempC°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        firstWeatherDescDe,
                        style: const TextStyle(
                          color: Colors.white,
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
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: Center(
                child: currentDataList.isNotEmpty
                    ? Image.network(
                  currentDataList.first.weatherIconURL,
                  height: 400,
                  width: 400,
                )
                    : Container(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      setState(() {
                        isWeatherWidgetSelected = !isWeatherWidgetSelected;
                      });
                    },
                    color: Colors.white,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  Center(
                    child: isWeatherWidgetSelected
                        ? buildWeatherWidget()
                        : buildHourlyWeatherWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}