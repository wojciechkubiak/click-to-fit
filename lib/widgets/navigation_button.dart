import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class NavigationButton extends StatelessWidget {
  final Color color;
  final Function() onPressed;
  final String? text;
  final bool isIcon;
  final IconData? icon;
  final bool isDisabled;
  final EdgeInsets? padding;
  final double? customIconPaddingVertical;
  final double? customIconPaddingHorizontal;

  const NavigationButton({
    Key? key,
    this.color = CustomColor.primaryAccentLight,
    this.isIcon = false,
    this.icon,
    this.text,
    this.isDisabled = false,
    this.padding = const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 72,
    ),
    this.customIconPaddingVertical,
    this.customIconPaddingHorizontal,
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
        padding: isIcon
            ? EdgeInsets.symmetric(
                vertical: customIconPaddingVertical ?? 4,
                horizontal: customIconPaddingHorizontal ?? 6,
              )
            : padding,
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
