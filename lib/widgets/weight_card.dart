import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class WeightCard extends StatelessWidget {
  final EdgeInsets padding;
  final double? currentWeight;
  final String? date;
  final double? previousWeight;
  final String? previousDate;
  final double bmi;

  const WeightCard({
    Key? key,
    required this.bmi,
    this.currentWeight,
    this.date,
    this.previousWeight,
    this.previousDate,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? difference;
    bool isPrevious = previousWeight is double && previousDate is String;
    bool isCurrent = currentWeight is double && date is String;
    bool isBoth = isPrevious && isCurrent;

    if (isBoth) {
      difference = currentWeight! - previousWeight!;
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
                  'BMI: ${bmi > 0 ? bmi.toStringAsFixed(2) : 'N/A'}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: getColor(value: bmi),
                  ),
                ),
                if (isCurrent) ...[
                  Text(
                    '$currentWeight kg',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Nord.light,
                    ),
                  ),
                  Text(
                    date!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Nord.light,
                    ),
                  ),
                ],
                if (isBoth)
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
                if (isPrevious) ...[
                  Text(
                    '$previousWeight kg',
                    style: TextStyle(
                      fontSize: isCurrent ? 34 : 64,
                      fontWeight: FontWeight.bold,
                      color: Nord.light,
                    ),
                  ),
                  Text(
                    previousDate!,
                    style: TextStyle(
                      fontSize: isCurrent ? 12 : 16,
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
