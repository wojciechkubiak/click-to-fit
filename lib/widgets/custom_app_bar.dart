import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Function? onBack;
  final bool isBack;

  const CustomAppBar({
    Key? key,
    this.onBack,
    this.isBack = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: Colors.white,
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
                color: Colors.black54,
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
