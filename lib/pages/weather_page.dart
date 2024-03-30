import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "../models/weather_model.dart";
import "../services/weather_service.dart";
import "../api/api_key.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(weatherApiKey);
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloud.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather?.cityName != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weather?.cityName ?? "Loading city...",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              if (_weather?.cityName != null)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                ),
              Text(_weather?.mainCondition ?? ""),
              Text(
                '${_weather?.temperature.round()}°C',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body:  Center(
          child:  Text(
            "Loading city...",
            style:  TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    }
  }
}
