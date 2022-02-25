import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../models/star.dart';
import '../pages/stars.dart';
import './navigation_button.dart';

class DateNavigation extends StatelessWidget {
  final Future<void> Function({
    required OffsetChange direction,
    required int offset,
    required DateScope scope,
  }) handleOffset;
  final DateScope scope;
  final int offset;
  final bool isDisabled;
  final bool isNextDisabled;
  final String text;

  const DateNavigation({
    Key? key,
    required this.handleOffset,
    required this.scope,
    required this.offset,
    required this.isDisabled,
    required this.isNextDisabled,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        NavigationButton(
          onPressed: () async => handleOffset(
            direction: OffsetChange.backward,
            offset: offset,
            scope: scope,
          ),
          isIcon: true,
          icon: Icons.arrow_back,
          isDisabled: isDisabled,
        ),
        SizedBox(
          width: 150,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColor.primaryAccent,
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        NavigationButton(
          onPressed: () async => handleOffset(
            direction: OffsetChange.forward,
            offset: offset,
            scope: scope,
          ),
          isIcon: true,
          isDisabled: isDisabled || isNextDisabled,
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }
}
