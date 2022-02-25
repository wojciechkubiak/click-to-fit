import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomAppBar extends StatelessWidget {
  final Function? onBack;
  final bool isBack;
  final Color? color;
  final bool isDarkIcon;
  final bool isOut;

  const CustomAppBar({
    Key? key,
    required this.isDarkIcon,
    required this.isOut,
    this.onBack,
    this.isBack = false,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 82,
      decoration: BoxDecoration(
        boxShadow: isOut
            ? const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]
            : [],
        color: color,
      ),
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
                color: isDarkIcon ? CustomColor.primaryAccent : Colors.white,
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
