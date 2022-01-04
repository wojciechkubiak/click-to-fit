import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            border: Border.all(
              width: isClicked ? 4 : 3,
              color: Nord.lightDark,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Icon(
            widget.icon,
            size: 24,
            color: Nord.light,
          ),
        ),
      ),
    );
  }
}
