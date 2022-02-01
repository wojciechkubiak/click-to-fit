import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/widgets/shadow_wrapper.dart';

import '../config/colors.dart';
import '../models/models.dart';

class Chart extends StatefulWidget {
  final List<Star> stars;
  final int initialLimit;
  final DateScope scope;

  const Chart({
    Key? key,
    required this.stars,
    required this.initialLimit,
    this.scope = DateScope.week,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  final Duration animDuration = const Duration(milliseconds: 250);
  List<Star> _stars = [];

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    _stars = widget.stars;

    for (var star in _stars) {
      print(star.toJson());
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.primaryAccentLight,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: BarChart(
                mainBarData(),
                swapAnimationDuration: animDuration,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    double limit, {
    bool isTouched = false,
    Color barColor = CustomColor.primaryAccent,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y > 0 ? y + 1 : 0,
          colors: [
            y >= limit + 3
                ? Nord.auroraRed
                : y > limit - 3
                    ? Nord.auroraGreen
                    : CustomColor.primaryAccent,
          ],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: limit + 1,
            colors: [CustomColor.primaryAccentLightSaturated],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups({
    required List<Star> list,
  }) {
    DateTime now = DateTime.now();
    List<ChartStar> result = [];

    for (var star in list) {
      result.add(ChartStar(
        date: star.date,
        value: star.stars,
        limit: star.progressLimit,
      ));
    }

    return List.generate(result.length, (i) {
      double value = result[i].value.toDouble();
      double limit = result[i].limit.toDouble();

      switch (i) {
        case 0:
          return makeGroupData(0, value, limit, isTouched: i == touchedIndex);
        case 1:
          return makeGroupData(1, value, limit, isTouched: i == touchedIndex);
        case 2:
          return makeGroupData(2, value, limit, isTouched: i == touchedIndex);
        case 3:
          return makeGroupData(3, value, limit, isTouched: i == touchedIndex);
        case 4:
          return makeGroupData(4, value, limit, isTouched: i == touchedIndex);
        case 5:
          return makeGroupData(5, value, limit, isTouched: i == touchedIndex);
        case 6:
          return makeGroupData(6, value, limit, isTouched: i == touchedIndex);
        case 7:
          return makeGroupData(7, value, limit, isTouched: i == touchedIndex);
        case 8:
          return makeGroupData(8, value, limit, isTouched: i == touchedIndex);
        case 9:
          return makeGroupData(9, value, limit, isTouched: i == touchedIndex);
        case 10:
          return makeGroupData(10, value, limit, isTouched: i == touchedIndex);
        case 11:
          return makeGroupData(11, value, limit, isTouched: i == touchedIndex);
        case 12:
          return makeGroupData(12, value, limit, isTouched: i == touchedIndex);
        default:
          return throw Error();
      }
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: CustomColor.primaryAccentDark,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongJanuary)
                      : weekDay = widget.scope == DateScope.week
                          ? translate(Keys.daysLongMonday)
                          : _stars[0].date.substring(0, 5).replaceAll('-', '/');
                  break;
                case 1:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongFebruary)
                      : weekDay = widget.scope == DateScope.week
                          ? translate(Keys.daysLongTuesday)
                          : _stars[1].date.substring(0, 5).replaceAll('-', '/');
                  break;
                case 2:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongMarch)
                      : weekDay = widget.scope == DateScope.week
                          ? translate(Keys.daysLongWednesday)
                          : _stars[2].date.substring(0, 5).replaceAll('-', '/');
                  break;
                case 3:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongApril)
                      : weekDay = widget.scope == DateScope.week
                          ? translate(Keys.daysLongThursday)
                          : _stars[3].date.substring(0, 5).replaceAll('-', '/');
                  break;
                case 4:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongMay)
                      : weekDay = widget.scope == DateScope.week
                          ? translate(Keys.daysLongFriday)
                          : _stars.length == 5
                              ? _stars[4]
                                  .date
                                  .substring(0, 5)
                                  .replaceAll('-', '/')
                              : '';
                  break;
                case 5:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongJune)
                      : weekDay = translate(Keys.daysLongSaturday);
                  break;
                case 6:
                  widget.scope == DateScope.year
                      ? weekDay = translate(Keys.monthsLongJuly)
                      : weekDay = translate(Keys.daysLongSunday);
                  break;
                case 7:
                  weekDay = translate(Keys.monthsLongAugust);
                  break;
                case 8:
                  weekDay = translate(Keys.monthsLongSeptember);
                  break;
                case 9:
                  weekDay = translate(Keys.monthsLongOctober);
                  break;
                case 10:
                  weekDay = translate(Keys.monthsLongNovember);
                  break;
                case 11:
                  weekDay = translate(Keys.monthsLongDecember);
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: CustomColor.primaryAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          rotateAngle: widget.scope != DateScope.week ? 85 : 0,
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortJanuary)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortMonday)
                        : _stars[0].date.substring(0, 5).replaceAll('-', '/');
              case 1:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortFebruary)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortTuesday)
                        : _stars[1].date.substring(0, 5).replaceAll('-', '/');
              case 2:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortMarch)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortWednesday)
                        : _stars[2].date.substring(0, 5).replaceAll('-', '/');
              case 3:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortApril)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortThursday)
                        : _stars[3].date.substring(0, 5).replaceAll('-', '/');
              case 4:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortMay)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortFriday)
                        : _stars.length == 5
                            ? _stars[4]
                                .date
                                .substring(0, 5)
                                .replaceAll('-', '/')
                            : '';
              case 5:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortJune)
                    : translate(Keys.daysShortSaturday);
              case 6:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortJuly)
                    : translate(Keys.daysShortSunday);
              case 7:
                return translate(Keys.monthsShortAugust);
              case 8:
                return translate(Keys.monthsShortSeptember);
              case 9:
                return translate(Keys.monthsShortOctober);
              case 10:
                return translate(Keys.monthsShortNovember);
              case 11:
                return translate(Keys.monthsShortDecember);
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(list: _stars),
      gridData: FlGridData(show: false),
    );
  }
}
