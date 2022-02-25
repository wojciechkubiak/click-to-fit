import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../config/colors.dart';

class NumberValuePicker extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;
  final Color color;
  final Color textColor;
  final Color selectedTextColor;
  final Axis axis;

  const NumberValuePicker({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.color = Colors.white,
    this.textColor = CustomColor.primaryAccent,
    this.selectedTextColor = CustomColor.primaryAccentDark,
    this.axis = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: NumberPicker(
        value: value,
        minValue: min,
        maxValue: max,
        step: 1,
        itemHeight: axis == Axis.horizontal ? 36 : 32,
        axis: axis,
        onChanged: onChanged,
        textStyle: TextStyle(
          color: textColor,
          fontSize: 18,
        ),
        selectedTextStyle: TextStyle(
          color: selectedTextColor,
          fontSize: axis == Axis.horizontal ? 34 : 24,
        ),
      ),
    );
  }
}
