import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:star_metter/config/colors.dart';

class NumberValuePicker extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const NumberValuePicker({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: value,
      minValue: min,
      maxValue: max,
      step: 1,
      itemHeight: 32,
      axis: Axis.vertical,
      onChanged: onChanged,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      selectedTextStyle: const TextStyle(
        color: Nord.auroraGreen,
        fontSize: 32,
      ),
    );
  }
}
