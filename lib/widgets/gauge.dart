import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Gauge extends StatefulWidget {
  final double currentValue;
  final double max;

  const Gauge({
    Key? key,
    required this.currentValue,
    required this.max,
  }) : super(key: key);

  @override
  _GaugeState createState() => _GaugeState();
}

class _GaugeState extends State<Gauge> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      backgroundColor: Colors.transparent,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: widget.max,
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: -90,
          endAngle: 270,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: widget.currentValue,
              color: widget.currentValue > widget.max + 2
                  ? Nord.auroraRed
                  : widget.currentValue >= widget.max - 2
                      ? Nord.auroraGreen
                      : CustomColor.primaryAccentSemiLight,
              startWidth: 15,
              endWidth: 15,
            ),
          ],
        ),
      ],
    );
  }
}
