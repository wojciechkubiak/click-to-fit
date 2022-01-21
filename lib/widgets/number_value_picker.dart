import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:star_metter/config/colors.dart';

class NumberValuePicker extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;
  final Axis axis;

  const NumberValuePicker({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.axis = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: NumberPicker(
        value: value,
        minValue: min,
        maxValue: max,
        step: 1,
        itemHeight: axis == Axis.horizontal ? 36 : 32,
        axis: axis,
        onChanged: onChanged,
        textStyle: const TextStyle(
          color: CustomColor.primaryAccent,
          fontSize: 18,
        ),
        selectedTextStyle: TextStyle(
          color: CustomColor.primaryAccentDark,
          fontSize: axis == Axis.horizontal ? 34 : 24,
        ),
      ),
    );
  }
}
