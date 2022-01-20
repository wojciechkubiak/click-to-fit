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
    this.color = CustomColor.primaryAccent,
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
              borderRadius: BorderRadius.circular(32),
            ),
            textStyle: Theme.of(context).textTheme.headline4,
            primary: color,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 72,
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
