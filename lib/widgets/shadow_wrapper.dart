import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

class ShadowWrapper extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  const ShadowWrapper({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 48),
    this.color = Nord.darker,
    this.borderRadius = const BorderRadius.only(
      bottomRight: Radius.circular(32),
      bottomLeft: Radius.circular(32),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Nord.darker,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
