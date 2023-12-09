
Technische Dokumentation

MyHomePage Widget
Dieses Widget repräsentiert die Hauptseite der App.
Es enthält eine AppBar, die den Standort des Benutzers, das aktuelle Wetter und ein Menüsymbol anzeigt.
Der Hauptbereich des Widgets enthält Informationen zum aktuellen Wetter, eine Wettergrafik und Schaltflächen zum Wechseln zwischen der stündlichen und siebentägigen Wetteransicht.
MenuPage Widget
Dieses Widget repräsentiert die Menüseite der App.
Es enthält Einstellungen für die Standortabfrage und eine Suchleiste zum Suchen von Orten.
Die Menüseite verwendet das WeatherSearch-Widget.
WeatherSearch Widget
Ein Widget zum Suchen von Standorten mit Echtzeit-Suchvorschlägen.
Es verwendet das SearchHelp-Modell für die Suche.
Wetterdaten-Modelle
CurrentConditionData, HourlyData, und WeatherData repräsentieren jeweils aktuelle Wetterbedingungen, stündliche Wetterdaten und siebentägige Wettervorhersagedaten.
fetchSevenDaysWeatherData und fetchHourlyWeatherData Funktionen
Asynchrone Funktionen zum Abrufen von siebentägigen bzw. stündlichen Wetterdaten basierend auf dem Standort des Benutzers.
buildWeatherWidget und buildHourlyWeatherWidget Funktionen
Diese Funktionen erstellen Widgets, um die siebentägigen bzw. stündlichen Wetterdaten anzuzeigen.
main.dart
Der Einstiegspunkt der Anwendung, der die MyApp-Klasse startet.
Initialisiert die Lokalisierung für deutsche Datums- und Zeitformate.
Hinweise
Der Code verwendet Flutter-Widgets wie Scaffold, AppBar, ListView, FutureBuilder und viele mehr, um die Benutzeroberfläche zu erstellen.
Es gibt einige Netzwerkanfragen (fetchSevenDaysWeatherData und fetchHourlyWeatherData), die asynchron durchgeführt werden, um Wetterdaten von einer API abzurufen.
Der Code verwendet setState-Aufrufe, um die Benutzeroberfläche bei Änderungen zu aktualisieren.