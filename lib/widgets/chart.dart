import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:star_metter/widgets/shadow_wrapper.dart';

import '../config/colors.dart';
import '../models/models.dart';

class Chart extends StatefulWidget {
  final List<Star> stars;
  final int initialLimit;

  const Chart({
    Key? key,
    required this.stars,
    required this.initialLimit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  final Duration animDuration = const Duration(milliseconds: 250);
  List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    if (widget.stars.isNotEmpty) {
      _stars = widget.stars;
    }
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Nord.darker,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 5,
                          color: Nord.auroraOrange,
                        ),
                      ),
                    ),
                    child: const Text(
                      'This week',
                      style: TextStyle(
                        color: Nord.light,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
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
    Color barColor = Nord.light,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y > 0 ? y + 1 : 0,
          colors: (y + 1) - (limit + 1) > 2
              ? [Nord.auroraRed]
              : (limit + 1) - (y + 1) <= 2
                  ? [Nord.auroraGreen]
                  : [Nord.lightDark],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: limit + 1,
            colors: [Nord.darkMedium],
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
    List<DateTime> dates = [];
    List<ChartStar> result = [];

    int dayOfWeek = now.weekday;

    for (int i = 7; i > dayOfWeek; i--) {
      dates.add(now.add(Duration(days: i - dayOfWeek)));
    }
    dates.add(now);
    for (int i = 1; i < dayOfWeek; i++) {
      dates.add(now.add(Duration(days: i * -1)));
    }

    for (var date in dates) {
      DateParser dateParser = DateParser(date: date);
      String _date = dateParser.getDateWithoutTime();

      ChartStar? chartStar = ChartStar(
        date: _date,
        value: 0,
        limit: widget.initialLimit,
      ); //

      for (var element in list) {
        if (element.date == _date) {
          chartStar.value = element.stars;
          chartStar.limit = element.progressLimit;
        }
      }
      result.add(chartStar);
    }

    List<ChartStar> output = result.reversed.toList();

    return List.generate(7, (i) {
      double value = output[i].value.toDouble();
      double limit = output[i].limit.toDouble();

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
        default:
          return throw Error();
      }
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Nord.lightDark,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Nord.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: const TextStyle(
                      color: Nord.darker,
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
            color: Nord.auroraYellow,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
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
