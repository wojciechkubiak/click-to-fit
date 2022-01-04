import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isDisabled;
  final String text;
  final Color color;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.isDisabled = false,
    this.text = "Next",
    this.color = Nord.auroraGreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.8 : 1,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            primary: color,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 80,
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
