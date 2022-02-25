import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../config/colors.dart';
import '../lang/keys.dart';
import '../models/star.dart';
import '../models/weight.dart';

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
  double? maxValue;
  List<Weight> weights = [];

  List<Color> gradientColors = [
    const Color(0xFF624a7b),
    const Color(0xFF88769b),
  ];

  List<FlSpot> generateTarget(double target, List<Weight> weights) {
    List<FlSpot> spots = [];

    spots.add(FlSpot(0, target));

    weights.asMap().forEach((key, value) {
      if (value.weight != 0) {
        spots.add(FlSpot(key.toDouble(), target));
      }
    });

    spots.add(FlSpot(weights.length - 1, target));

    return spots;
    // return List.generate(len, (index) => FlSpot(index.toDouble(), target));
  }

  List<FlSpot> generateSpots(List<Weight> weights) {
    List<FlSpot> spots = [];

    weights.asMap().forEach((key, value) {
      if (value.weight != 0) {
        spots.add(FlSpot(key.toDouble(), value.weight));
      }
    });

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    weights = widget.weights;

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
                translate(Keys.globalNoData),
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

  String getParsedDate({required String date, required DateScope scope}) {
    if (scope != DateScope.year) {
      return date.substring(0, 5).replaceAll('-', '/');
    } else {
      return date.substring(3, 10).replaceAll('-', '/');
    }
  }

  LineChartData mainData(List<Weight> weights) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: CustomColor.primaryAccentLight,
          tooltipMargin: 20,
          getTooltipItems: (touchedSpots) {
            return List<LineTooltipItem>.from(
              touchedSpots.map((e) {
                return LineTooltipItem(
                  "",
                  Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColor.primaryAccentDark,
                        fontWeight: FontWeight.w400,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: e.barIndex != 0
                          ? (e.y).toStringAsFixed(1)
                          : getParsedDate(
                              date: weights[e.x.toInt()].date,
                              scope: widget.scope),
                      style: TextStyle(
                        color: e.barIndex != 0
                            ? CustomColor.primaryAccent
                            : CustomColor.primaryAccentSemiLight,
                        fontSize: e.barIndex != 0 ? 24 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: CustomColor.primaryAccentSemiLight,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          rotateAngle: widget.scope != DateScope.week ? 85 : 0,
          getTitles: (value) => "",
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: weights.length - 1,
      minY: widget.target - 10,
      maxY: widget.init + 10,
      lineBarsData: [
        LineChartBarData(
          spots: generateTarget(widget.target, weights),
          isCurved: false,
          colors: [Nord.auroraGreen],
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, d, data, i) {
              return FlDotCirclePainter(
                radius: 0,
                color: Nord.auroraGreen,
                strokeColor: Nord.auroraGreen,
              );
            },
          ),
        ),
        LineChartBarData(
          spots: generateSpots(weights),
          isCurved: false,
          lineChartStepData: null,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}
