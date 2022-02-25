import 'dart:async';

import 'package:flutter/material.dart';

import '../config/colors.dart';

class CounterButton extends StatefulWidget {
  final IconData icon;
  final Function() onClick;
  final bool isDisabled;

  const CounterButton({
    Key? key,
    required this.onClick,
    required this.icon,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  Timer? timer;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isDisabled,
      child: GestureDetector(
        onTap: () {
          setState(() => isClicked = true);
          widget.onClick();

          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() => isClicked = false);
            }
          });
        },
        onLongPress: () {
          timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
            widget.onClick();
          });
        },
        onLongPressCancel: () {
          if (timer is Timer) {
            timer!.cancel();
          }
        },
        onLongPressEnd: (_) {
          if (timer is Timer) {
            timer!.cancel();
          }
        },
        onTapUp: (TapUpDetails details) {
          if (timer is Timer) {
            timer!.cancel();
          }
        },
        onTapCancel: () {
          if (timer is Timer) {
            timer!.cancel();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 36,
          width: 36,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     width: isClicked ? 4 : 3,
          //     color: Nord.lightDark,
          //   ),
          //   borderRadius: const BorderRadius.all(Radius.circular(4)),
          // ),
          child: Icon(
            widget.icon,
            size: 36,
            color: Nord.light,
          ),
        ),
      ),
    );
  }
}
