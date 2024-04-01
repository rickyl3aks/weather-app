class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String country;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.country,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json["name"],
        temperature: json["main"]["temp"].toDouble(),
        mainCondition: json["weather"][0]["main"],
        country: json["sys"]["country"]);
  }
}

class AirPollution {
  final int indexPollution;

  AirPollution({
    required this.indexPollution,
  });

  factory AirPollution.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json["list"];

    final Map<String, dynamic> firstItem = dataList.first;

    final Map<String, dynamic> mainData = firstItem["main"];

    final int aqi = mainData["aqi"];

    return AirPollution(indexPollution: aqi);
  }
}
