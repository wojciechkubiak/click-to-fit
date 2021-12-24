import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class WeightCard extends StatelessWidget {
  final EdgeInsets padding;
  final double currentWeight;
  final String date;
  final double? previousWeight;
  final String? previousDate;

  const WeightCard({
    Key? key,
    required this.currentWeight,
    required this.date,
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
