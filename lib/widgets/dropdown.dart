import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/star.dart';

class Dropdown extends StatelessWidget {
  final Future<void>? Function(DateScope?) onChanged;
  final DateScope current;

  const Dropdown({
    Key? key,
    required this.onChanged,
    required this.current,
  }) : super(key: key);

  String getText(DateScope scope) {
    Map<DateScope, String> temp = {
      DateScope.week: translate(Keys.datesRangeWeek),
      DateScope.month: translate(Keys.datesRangeMonth),
      DateScope.year: translate(Keys.datesRangeYear),
    };

    return temp[scope]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
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
      child: DropdownButton<DateScope>(
        elevation: 10,
        value: current,
        dropdownColor: CustomColor.primaryAccentLight,
        icon: const Icon(
          Icons.arrow_downward,
          color: CustomColor.primaryAccentSemiLight,
        ),
        underline: Container(
          height: 2,
          color: CustomColor.primaryAccentLight,
        ),
        items: <DateScope>[DateScope.week, DateScope.month, DateScope.year]
            .map<DropdownMenuItem<DateScope>>((DateScope scope) {
          return DropdownMenuItem<DateScope>(
            value: scope,
            child: Center(
              child: Text(
                getText(scope),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 22,
                      color: CustomColor.primaryAccent,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
