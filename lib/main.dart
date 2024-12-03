import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  String errorMessage = '';
  String location = '';
  double temperature = 0;
  String weatherDescription = '';
  String weatherIcon = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      // Fetch user location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      // Fetch weather data
      String apiKey = '14b48d5f7fee00abf0cb871256e0b75c';
      String apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey';
      http.Response response = await http.get(Uri.parse(apiUrl));
      Map<String, dynamic> weatherData = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        location = weatherData['name'];
        temperature = weatherData['main']['temp'];
        weatherDescription = weatherData['weather'][0]['description'];
        weatherIcon = weatherData['weather'][0]['icon'];
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(fontSize: 18),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 16),
                        Image.network(
                          'https://openweathermap.org/img/w/$weatherIcon.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${temperature.toStringAsFixed(1)}°C',
                          style:
                              TextStyle(fontSize: 24, fontFamily: 'CustomFont'),
                        ),
                        SizedBox(height: 16),
                        Text(
                          weatherDescription,
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'CustomFont'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
