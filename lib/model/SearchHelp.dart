import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'vars.dart';

class WeatherSearch extends StatefulWidget {
  @override
  _WeatherSearchState createState() => _WeatherSearchState();
}

class _WeatherSearchState extends State<WeatherSearch> {
  TextEditingController citySearchController = TextEditingController();
  List<Map<String, String>> searchSuggestions = [];

  void onSubmitted(String userInput) {

    Location.setuserLocation(userInput);
    Navigator.pop(context);

  }

  void searchLocation(String userInput) async {
    final apiKey = "f561941c401e447082f232805230512";
    final apiUrl = "http://api.worldweatheronline.com/premium/v1/search.ashx";

    final response = await http.get(
      Uri.parse('$apiUrl?key=$apiKey&q=$userInput&format=json&timezone=no&popular=no&num_of_results=10&wct=yes'),
    );

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);

      Map<String, dynamic> decodedData = json.decode(data);

      List<dynamic> result = decodedData['search_api']['result'];

      List<Map<String, String>> suggestions = [];
      for (var location in result) {
        suggestions.add({
          'areaName': location['areaName'][0]['value'],
          'country': location['country'][0]['value'],
          'region': location['region'][0]['value'],
        });
      }
      setState(() {
        searchSuggestions = suggestions;
      });
    } else {
      print('Fehler bei der API-Anfrage: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stadt suchen',
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: citySearchController,
                    onChanged: (String userInput) {
                      searchLocation(userInput);
                    },
                    onSubmitted: (String userInput) {

                      searchLocation(userInput);
                      Location.setuserLocation(userInput);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      hintText: 'Suchen Sie nach Städten',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (searchSuggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < searchSuggestions.length; index++)
                  Column(
                    children: [
                      ListTile(
                        title: Text('${searchSuggestions[index]['areaName']}, ${searchSuggestions[index]['region']}, ${searchSuggestions[index]['country']}'),
                        onTap: () {

                          citySearchController.text = searchSuggestions[index]['areaName'] ?? '';

                          searchLocation(searchSuggestions[index]['areaName'] ?? '');

                          setState(() {
                            searchSuggestions.clear();
                          });

                          onSubmitted(citySearchController.text);
                        },
                      ),
                      if (index < searchSuggestions.length - 1)
                        Divider(
                          color: Colors.black,
                          height: 1,
                          thickness: 1,
                        ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: WeatherSearch(),
    ),
  ));
}
