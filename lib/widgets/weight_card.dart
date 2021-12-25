import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class WeightCard extends StatelessWidget {
  final EdgeInsets padding;
  final double currentWeight;
  final String date;
  final double? previousWeight;
  final String? previousDate;
  final double bmi;

  const WeightCard({
    Key? key,
    required this.currentWeight,
    required this.date,
    required this.bmi,
    this.previousWeight,
    this.previousDate,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? difference;
    bool isPrevious = previousWeight != null && previousDate != null;

    if (isPrevious) {
      difference = currentWeight - previousWeight!;
    }

    Color getColor({required double value}) {
      if (value > 40) {
        return Nord.auroraRed;
      } else if (value > 30) {
        return Nord.auroraOrange;
      } else if (value > 25) {
        return Nord.auroraYellow;
      } else if (value > 18.5) {
        return Nord.auroraGreen;
      } else if (value > 17) {
        return Nord.auroraOrange;
      } else {
        return Nord.auroraRed;
      }
    }

    return Padding(
      padding: padding,
      child: AspectRatio(
        aspectRatio: isPrevious ? 1 : 2,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Nord.darker,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BMI: ${bmi.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: getColor(value: bmi),
                  ),
                ),
                Text(
                  '$currentWeight kg',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Nord.light,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Nord.light,
                  ),
                ),
                if (isPrevious) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Text(
                      '${difference! > 0 ? "+" : ""} ${difference.toStringAsFixed(2)} kg',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: difference == 0
                            ? Nord.light
                            : difference < 0
                                ? Nord.auroraGreen
                                : Nord.auroraRed,
                      ),
                    ),
                  ),
                  Text(
                    '$previousWeight kg',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Nord.light,
                    ),
                  ),
                  Text(
                    previousDate!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Nord.light,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
