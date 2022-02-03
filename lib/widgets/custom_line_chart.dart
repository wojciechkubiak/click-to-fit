import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/star.dart';
import 'package:star_metter/models/weight.dart';

class CustomLineChart extends StatefulWidget {
  final double init;
  final double target;
  final DateScope scope;
  final List<Weight> weights;

  const CustomLineChart({
    Key? key,
    required this.init,
    required this.target,
    required this.scope,
    required this.weights,
  }) : super(key: key);

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  List<Color> gradientColors = [
    const Color(0xFF624a7b),
    const Color(0xFF88769b),
  ];

  List<FlSpot> generateSpots(List<Weight> weights) {
    List<FlSpot> spots = [];

    weights.asMap().forEach((key, value) {
      if (value.id != null) {
        spots.add(FlSpot(key.toDouble(), value.weight));
      }
    });

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    List<Weight> weights = widget.weights;

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.10,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: CustomColor.primaryAccentLight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 32,
              ),
              child: LineChart(
                mainData(weights),
              ),
            ),
          ),
        ),
        if (generateSpots(weights).isEmpty)
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(top: 52.0),
              child: Text(
                "Brak danych",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColor.primaryAccentSemiLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
      ],
    );
  }

  LineChartData mainData(List<Weight> weights) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: CustomColor.primaryAccentSemiLight,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortJanuary)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortMonday)
                        : weights[0].date.substring(0, 5).replaceAll('-', '/');
              case 1:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortFebruary)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortTuesday)
                        : weights[1].date.substring(0, 5).replaceAll('-', '/');
              case 2:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortMarch)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortWednesday)
                        : weights[2].date.substring(0, 5).replaceAll('-', '/');
              case 3:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortApril)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortThursday)
                        : weights[3].date.substring(0, 5).replaceAll('-', '/');
              case 4:
                return widget.scope == DateScope.year
                    ? translate(Keys.monthsShortMay)
                    : widget.scope == DateScope.week
                        ? translate(Keys.daysShortFriday)
                        : weights.length == 5
                            ? weights[4]
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
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: widget.weights.length - 1,
      minY: widget.target - 10,
      maxY: widget.init + 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, widget.target),
            FlSpot(1, widget.target),
            FlSpot(2, widget.target),
            FlSpot(3, widget.target),
            FlSpot(4, widget.target),
            FlSpot(5, widget.target),
            FlSpot(widget.weights.length - 1, widget.target),
          ],
          isCurved: true,
          colors: [Nord.auroraGreen],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: generateSpots(weights),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => barData.spots.length == 1,
          ),
        ),
      ],
    );
  }
}
