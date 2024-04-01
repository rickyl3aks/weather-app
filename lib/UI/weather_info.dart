import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WeatherInfoWidget extends StatelessWidget {
  final String mainCondition;
  final double temperature;
  final String pollutionIndex;

  const WeatherInfoWidget({
    super.key,
    required this.mainCondition,
    required this.temperature,
    required this.pollutionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(50),
      height: 300,
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 0.5,
            color: Colors.black26,
          )
        ],
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.robotoCondensed(color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              mainCondition,
              style: const TextStyle(fontSize: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                  height: 65,
                  child: Lottie.asset(
                    'assets/icons/temperature.json',
                  ),
                ),
                Text(
                  '${temperature.round()}°C',
                  style: const TextStyle(fontSize: 40),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                  height: 80,
                  child: Lottie.asset(
                    'assets/score/${pollutionIndex.toLowerCase().replaceAll(' ', '_')}.json',
                  ),
                ),
                const Text(
                  "Air quality ",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
