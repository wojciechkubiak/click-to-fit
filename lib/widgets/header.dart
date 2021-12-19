import 'package:flutter/material.dart';

import '../config/colors.dart';

class Header extends StatelessWidget {
  final String text;
  final bool showBottomText;
  final bool isWhite;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const Header({
    Key? key,
    this.text = 'Star Metter',
    this.showBottomText = true,
    this.isWhite = false,
    this.fontWeight = FontWeight.w400,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 46,
              color: isWhite ? Colors.white : CustomColor.secondaryAccent,
              fontFamily: 'Merienda',
              fontWeight: fontWeight,
            ),
          ),
          if (showBottomText)
            Text(
              'Lose weight like a star',
              style: TextStyle(
                fontSize: 14,
                color: isWhite ? Colors.white : CustomColor.primaryAccentLight,
              ),
            ),
        ],
      ),
    );
  }
}
