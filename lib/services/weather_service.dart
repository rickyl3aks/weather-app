import "dart:convert";
import "dart:ffi";

import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";

import "../models/weather_model.dart";
import "package:http/http.dart" as http;

class WeatherService {
  final String apiKey;
  final String baseUrl;
  final String weatherType;
  final double? latitude;
  final double? longitude;

  WeatherService(this.apiKey, this.weatherType, {this.latitude, this.longitude})
      : baseUrl = (latitude != null && longitude != null)
            ? "https://api.openweathermap.org/data/2.5/$weatherType?lat=$latitude&lon=$longitude"
            : "https://api.openweathermap.org/data/2.5/$weatherType";

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<AirPollution> getPollution() async {
    final response = await http
        .get(Uri.parse('$baseUrl&appid=$apiKey'));

    if (response.statusCode == 200){
      return AirPollution.fromJson(jsonDecode(response.body));
    }else {
      throw Exception("Failed to load air pollution");
    }
  }

  Future<Map<String, dynamic>> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the location into a list of place-mark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the city name from the first place-mark
    String? city = placemark.isNotEmpty ? placemark[0].locality : null;

    // Check if city is null, if so return an empty map
    if (city == null) {
      return {};
    }

    // Create a map containing city, latitude, and longitude
    return {
      'city': city,
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}
