import 'dart:math';

import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'number_value_picker.dart';

class CustomDialogWrapper extends StatefulWidget {
  final double initValue;
  final String? header;
  final String? dialogBody;
  final String? declineText;
  final String? confirmText;

  const CustomDialogWrapper({
    Key? key,
    required this.initValue,
    required this.header,
    required this.dialogBody,
    required this.declineText,
    required this.confirmText,
  }) : super(key: key);

  @override
  _CustomDialogWrapperState createState() => _CustomDialogWrapperState();
}

class _CustomDialogWrapperState extends State<CustomDialogWrapper> {
  int _weightKg = 1;
  int _weightDec = 5;

  @override
  void initState() {
    super.initState();
    _weightKg = int.parse(widget.initValue.floor().toStringAsFixed(0));
    _weightDec = ((widget.initValue % 1) * pow(10, 1)).floor();
  }

  Widget weightPicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 42),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Weight:',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 36,
                color: Nord.light,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberValuePicker(
                value: _weightKg,
                min: 65,
                max: 235,
                onChanged: (value) => setState(() => _weightKg = value),
              ),
              NumberValuePicker(
                value: _weightDec,
                min: 0,
                max: 10,
                onChanged: (value) => setState(() => _weightDec = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Nord.darker,
      insetPadding: const EdgeInsets.all(24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.header!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                color: Nord.light,
                fontWeight: FontWeight.bold,
              ),
            ),
            weightPicker(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    widget.declineText!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Nord.light,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text(
                    widget.confirmText!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Nord.light,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    double.parse('$_weightKg.$_weightDec'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog {
  Future<double?> showNumericDialog({
    required BuildContext context,
    required double initValue,
    String? header,
    String? dialogBody,
    String? declineText,
    String? confirmText,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogWrapper(
          initValue: initValue,
          header: header,
          dialogBody: dialogBody,
          declineText: declineText,
          confirmText: confirmText,
        );
      },
    );
  }

  Future<bool?> showBaseDialog({
    required BuildContext context,
    String? header,
    String? dialogBody,
    String? declineText,
    String? confirmText,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Nord.darker,
          insetPadding: const EdgeInsets.all(24.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  header!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Nord.light,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Text(
                    dialogBody!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Nord.light,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        declineText!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Nord.light,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text(
                        confirmText!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Nord.light,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
