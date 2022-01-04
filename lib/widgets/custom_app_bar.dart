import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class CustomAppBar extends StatelessWidget {
  final Function? onBack;
  final bool isBack;
  final Color? color;

  const CustomAppBar({
    Key? key,
    this.onBack,
    this.isBack = false,
    this.color = Nord.dark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 82,
      color: color,
      child: Row(
        children: [
          Container(
            height: 80,
            width: 50,
            padding: const EdgeInsets.only(top: 32, left: 8),
            child: IconButton(
              onPressed: onBack != null ? () => onBack!() : null,
              icon: Icon(
                isBack ? Icons.arrow_back : Icons.menu,
                size: 32,
                color: Nord.light,
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
