import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/models/star.dart';

class Gauge extends StatefulWidget {
  final double currentValue;
  final double max;
  final Future<void>? Function(Star, double) onChange;
  final Star stars;

  const Gauge({
    Key? key,
    required this.currentValue,
    required this.max,
    required this.onChange,
    required this.stars,
  }) : super(key: key);

  @override
  _GaugeState createState() => _GaugeState();
}

class _GaugeState extends State<Gauge> {
  @override
  Widget build(BuildContext context) {
    print(widget.currentValue);
    return SleekCircularSlider(
      innerWidget: (value) => const SizedBox(),
      onChangeEnd: (value) {
        widget.onChange(widget.stars, value);
      },
      min: 0,
      max: widget.max,
      initialValue:
          widget.currentValue > widget.max ? widget.max : widget.currentValue,
      appearance: CircularSliderAppearance(
        animDurationMultiplier: 0,
        startAngle: 270,
        angleRange: 360,
        customColors: CustomSliderColors(
          trackColor: CustomColor.primaryAccentLight,
          progressBarColor: widget.currentValue > widget.max + 2
              ? Nord.auroraRed
              : widget.currentValue >= widget.max - 2
                  ? Nord.auroraGreen
                  : CustomColor.primaryAccentSemiLight,
          shadowColor: Colors.transparent,
          hideShadow: true,
        ),
      ),
    );
  }
}
