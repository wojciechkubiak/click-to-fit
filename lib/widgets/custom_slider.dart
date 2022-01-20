import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final String header;
  final void Function(double)? onChanged;
  final double min;
  final double max;
  final int divisions;
  const CustomSlider({
    Key? key,
    required this.value,
    required this.header,
    required this.onChanged,
    this.min = 1,
    this.max = 5,
    this.divisions = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        valueIndicatorTextStyle: TextStyle(
          color: Colors.black87,
          letterSpacing: 1.0,
        ),
        valueIndicatorColor: Color(0xFFF1F1F1),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        inactiveColor: CustomColor.primaryAccentLight,
        activeColor: CustomColor.primaryAccent,
        label: header,
        onChanged: onChanged,
      ),
    );
  }
}
