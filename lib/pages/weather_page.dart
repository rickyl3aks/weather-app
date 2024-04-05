import "dart:async";
import "package:flutter/material.dart";
import "../UI/weather_info.dart";
import "package:lottie/lottie.dart";
import "../models/weather_model.dart";
import "../services/weather_service.dart";
import "../format_date/date.dart";
import "../api/api_key.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(weatherApiKey, "weather");
  Weather? _weather;
  AirPollution? _pollution;

  //fetch weather
  _fetchWeather() async {
    // get the current city
    Map<String, dynamic> cityData = await _weatherService.getCurrentCity();
    String cityName = cityData['city'];
    double latitude = cityData["latitude"];
    double longitude = cityData["longitude"];

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      final airPollutionService = WeatherService(weatherApiKey, "air_pollution",
          latitude: latitude, longitude: longitude);
      final airPollution = await airPollutionService.getPollution();
      setState(() {
        _pollution = airPollution;
      });
    } catch (error) {
      print(error);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition, time) {
    if (mainCondition == null) return "assets/day/sunny.json";
    if (time == null) return "assets/day/sunny.json";
    int hour = int.parse(time.split(':')[0]);
    String cycle = (hour >= 5 && hour < 18) ? "day" : "night";
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/$cycle/cloud.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/$cycle/rain.json";
      case "thunderstorm":
        return "assets/$cycle/thunder.json";
      case "clear":
        return "assets/$cycle/sunny.json";
      default:
        return "assets/$cycle/sunny.json";
    }
  }

  String getPollutionResult(int? pollutionIdx) {
    if (pollutionIdx == null) return "good";
    String score;

    switch (pollutionIdx) {
      case 5:
        score = "Very Poor";
        break;
      case 4:
        score = "Poor";
        break;
      case 3:
        score = "Moderate";
        break;
      case 2:
        score = "Fair";
        break;
      case 1:
        score = "Good";
        break;
      default:
        score = "Good";
    }
    return score;
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
    // fetch weather
    Timer.periodic(const Duration(hours: 1), (timer) {
      _fetchWeather();
    });
    updateTime();
    Timer.periodic(const Duration(seconds: 50), (timer) {
      updateTime();
    });
  }

  void updateTime() {
    setState(() {
      time = clock.format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weather?.cityName != null) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amberAccent, Colors.lightBlueAccent],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(_weather?.cityName).toString()}, ${(_weather?.country).toString()}",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                date.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                time.toString(),
                style: const TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  getWeatherAnimation(_weather?.mainCondition, time.toString()),
                ),
              ),
              WeatherInfoWidget(
                mainCondition: _weather?.mainCondition ?? "",
                temperature: _weather?.temperature ?? 0,
                pollutionIndex:
                    getPollutionResult(_pollution?.indexPollution),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
          ),
          child: Lottie.asset("assets/loading/loading.json"),
        ),
      );
    }
  }
}
