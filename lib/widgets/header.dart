import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../lang/keys.dart';
import '../config/colors.dart';

class Header extends StatelessWidget {
  final String text;
  final bool showBottomText;
  final bool isWhite;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const Header({
    Key? key,
    this.text = 'Lazy&Fit',
    this.showBottomText = true,
    this.isWhite = false,
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
            text,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: isWhite ? Colors.white : CustomColor.primaryAccent,
                ),
          ),
          if (showBottomText)
            Text(
              translate(Keys.appDesc),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isWhite
                        ? Colors.white70
                        : CustomColor.primaryAccentSemiLight,
                  ),
            ),
        ],
      ),
    );
  }
}
