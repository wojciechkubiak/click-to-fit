import 'package:flutter/material.dart';

import '../config/colors.dart';

class Header extends StatelessWidget {
  final String text;
  final bool showBottomText;
  final bool isWhite;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final bool isHeader;

  const Header({
    Key? key,
    this.text = 'Star Metter',
    this.showBottomText = true,
    this.isWhite = false,
    this.isHeader = false,
    this.fontWeight = FontWeight.bold,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Text(
            isHeader ? text : "Loading",
            style: TextStyle(
              fontSize: 46,
              color: Nord.light,
              fontFamily: 'Merienda',
              fontWeight: fontWeight,
            ),
          ),
          if (showBottomText && isHeader)
            const Text(
              'LOSE WEIGHT LIKE A STAR',
              style: TextStyle(
                  fontSize: 14, color: Nord.light, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
