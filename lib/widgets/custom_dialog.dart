import 'dart:math';

import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'number_value_picker.dart';

class CustomDialogWrapper extends StatefulWidget {
  final String initValue;
  final String? header;
  final String? dialogBody;
  final String? declineText;
  final String? confirmText;
  final String divider;
  final int minLeft;
  final int maxLeft;
  final int minRight;
  final int maxRight;
  final List<String> allowedStars;

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
    this.allowedStars = const [],
  }) : super(key: key);

  @override
  _CustomDialogWrapperState createState() => _CustomDialogWrapperState();
}

class _CustomDialogWrapperState extends State<CustomDialogWrapper> {
  late String chosenDate;
  late String v1;
  late String v2;

  @override
  void initState() {
    super.initState();
    List<String> value = widget.initValue.split('.');
    v1 = value.first;
    v2 = value.last;
    if (widget.allowedStars.isNotEmpty) {
      chosenDate = widget.allowedStars.first;
    }
  }

  Widget weightPicker() {
    print(widget.allowedStars);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          if (widget.allowedStars.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CustomColor.primaryAccentLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 3), //(x,y)
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: DropdownButton<String>(
                elevation: 10,
                value: chosenDate,
                dropdownColor: CustomColor.primaryAccentLight,
                icon: const Icon(
                  Icons.arrow_downward,
                  color: CustomColor.primaryAccentSemiLight,
                ),
                underline: Container(
                  height: 2,
                  color: CustomColor.primaryAccentLight,
                ),
                items: <String>[...widget.allowedStars]
                    .map<DropdownMenuItem<String>>((String allowed) {
                  return DropdownMenuItem<String>(
                    value: allowed,
                    child: Center(
                      child: Text(
                        allowed.replaceAll('-', '/'),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 22,
                              color: CustomColor.primaryAccent,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? _allowedDate) {
                  if (_allowedDate is String) {
                    setState(() => chosenDate = _allowedDate);
                  }
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberValuePicker(
                value: int.parse(v1),
                min: widget.minLeft,
                max: widget.maxLeft,
                onChanged: (value) => setState(() => v1 = value.toString()),
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
                value: int.parse(v2),
                min: widget.minRight,
                max: widget.maxRight,
                onChanged: (value) => setState(() => v2 = value.toString()),
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
                      widget.allowedStars.isNotEmpty
                          ? '$v1.$v2.$chosenDate'
                          : '$v1.$v2',
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
  Future<String?> showNumericDialog({
    required BuildContext context,
    required String initValue,
    required int minleft,
    required int minRight,
    required int maxLeft,
    required int maxRight,
    String? header,
    String? dialogBody,
    String? declineText,
    String? confirmText,
    String divider = ",",
    List<String> allowedStars = const [],
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
          allowedStars: allowedStars,
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
