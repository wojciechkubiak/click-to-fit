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
  final String divider;
  final int minLeft;
  final int maxLeft;
  final int minRight;
  final int maxRight;

  const CustomDialogWrapper({
    Key? key,
    required this.initValue,
    required this.header,
    required this.dialogBody,
    required this.declineText,
    required this.confirmText,
    required this.minLeft,
    required this.minRight,
    required this.maxLeft,
    required this.maxRight,
    this.divider = ",",
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
    List<String> value = widget.initValue.toString().split('.');
    _weightKg = int.parse(value.first);
    _weightDec = int.parse(value.last);
  }

  Widget weightPicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberValuePicker(
                value: _weightKg,
                min: widget.minLeft,
                max: widget.maxLeft,
                onChanged: (value) => setState(() => _weightKg = value),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.divider,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              NumberValuePicker(
                value: _weightDec,
                min: widget.minRight,
                max: widget.maxRight,
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
      backgroundColor: CustomColor.primaryAccent,
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
              style:
                  Theme.of(context).textTheme.headline2!.copyWith(fontSize: 42),
            ),
            weightPicker(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      widget.declineText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text(
                      widget.confirmText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(
                      context,
                      double.parse('$_weightKg.$_weightDec'),
                    ),
                  ),
                ],
              ),
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
    required int minleft,
    required int minRight,
    required int maxLeft,
    required int maxRight,
    String? header,
    String? dialogBody,
    String? declineText,
    String? confirmText,
    String divider = ",",
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
          divider: divider,
          minLeft: minleft,
          minRight: minRight,
          maxLeft: maxLeft,
          maxRight: maxRight,
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
          backgroundColor: CustomColor.primaryAccent,
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
