import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class NavigationButton extends StatelessWidget {
  final Color color;
  final Function() onPressed;
  final String text;

  const NavigationButton({
    Key? key,
    this.color = CustomColor.primaryAccentLight,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: Theme.of(context).textTheme.headline4,
        primary: color,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 72,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: CustomColor.primaryAccent,
              letterSpacing: 2,
            ),
      ),
    );
  }
}
