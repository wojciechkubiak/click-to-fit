import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/colors.dart';

enum NumericOptions { SUBSTRACT, ADD }
enum ValueTypes { AGE, HEIGHT, WEIGHT, TARGET_WEIGHT }

class Input extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validation;
  final FocusNode? focusNode;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;

  const Input({
    Key? key,
    required this.controller,
    this.labelText,
    this.validation,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        cursorColor: CustomColor.primaryAccentDark,
        inputFormatters: widget.inputFormatters,
        validator: widget.validation,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: CustomColor.primaryAccentDark),
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Nord.auroraRed, fontSize: 14),
          fillColor: CustomColor.primaryAccentLight,
          filled: true,
          contentPadding: const EdgeInsets.all(12),
          label: widget.labelText is String ? Text(widget.labelText!) : null,
          labelStyle: const TextStyle(
              fontSize: 16, color: CustomColor.primaryAccentLight),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColor.primaryAccent,
              width: 3,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColor.primaryAccentDark,
              width: 3,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColor.primaryAccentDark,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}
