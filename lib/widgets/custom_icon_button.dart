import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final Function() onClick;
  final IconData? icon;
  final EdgeInsets margin;
  final Color color;
  final Color textColor;
  final double width;

  const CustomIconButton({
    Key? key,
    this.icon,
    this.margin = EdgeInsets.zero,
    this.color = CustomColor.primaryAccentSemiLight,
    this.textColor = CustomColor.primaryAccentLight,
    this.width = 240,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: Theme.of(context).textTheme.headline4,
          primary: color,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
        ),
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: TextStyle(color: textColor),
            ),
            if (icon is IconData)
              Icon(
                icon,
                size: 32,
                color: Nord.light,
              ),
          ],
        ),
      ),
    );
  }
}
