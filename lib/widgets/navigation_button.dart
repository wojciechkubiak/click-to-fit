import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class NavigationButton extends StatelessWidget {
  final Color color;
  final Function() onPressed;
  final String? text;
  final bool isIcon;
  final IconData? icon;
  final bool isDisabled;

  const NavigationButton({
    Key? key,
    this.color = CustomColor.primaryAccentLight,
    this.isIcon = false,
    this.icon,
    this.text,
    this.isDisabled = false,
    required this.onPressed,
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
        padding: EdgeInsets.symmetric(
          vertical: isIcon ? 6 : 15,
          horizontal: isIcon ? 6 : 72,
        ),
      ),
      onPressed: isDisabled ? () {} : onPressed,
      child: !isIcon
          ? Text(
              text!,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: CustomColor.primaryAccent,
                    letterSpacing: 2,
                  ),
            )
          : SizedBox(
              height: 42,
              width: 42,
              child: Icon(
                icon!,
                size: 44,
                color: isDisabled
                    ? CustomColor.primaryAccentLightSaturated
                    : CustomColor.primaryAccentSemiLight,
              ),
            ),
    );
  }
}
