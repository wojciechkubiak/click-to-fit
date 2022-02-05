import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/blocs/measures/measures_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/measure.dart';
import 'package:star_metter/models/metric.dart';
import 'package:star_metter/models/models.dart';
import 'package:star_metter/models/star.dart';
import 'package:star_metter/pages/error_page.dart';
import 'package:star_metter/pages/measures/measure_detailed.dart';
import 'package:star_metter/pages/pages.dart';
import 'package:star_metter/pages/stars.dart';
import 'package:star_metter/services/weight.dart';
import 'package:star_metter/widgets/custom_line_chart.dart';
import 'package:star_metter/widgets/date_navigation.dart';
import 'package:star_metter/widgets/dropdown.dart';
import 'package:star_metter/widgets/navigation_button.dart';
import 'package:collection/collection.dart';

import '../../widgets/widgets.dart';
import '../../blocs/home/home_bloc.dart';

class Measures extends StatefulWidget {
  final Function() handlePage;
  final List<Weight> weights;
  final List<Weight> allWeights;
  final List<Measure> allMeasures;
  final User user;

  const Measures({
    Key? key,
    required this.handlePage,
    required this.weights,
    required this.allWeights,
    required this.allMeasures,
    required this.user,
  }) : super(key: key);

  @override
  State<Measures> createState() => _MeasuresState();
}

class _MeasuresState extends State<Measures> {
  late User _user;

  WeightService weightService = WeightService();
  final int _valuesShownLength = 5;

  int _offset = 0;
  bool _allowExpand = true;
  bool _isLoading = false;
  List<Weight> _weights = [];
  List<Weight> _allWeights = [];
  List<Weight> _expandedWeights = [];
  Measure? firstMeasure;
  Measure? lastMeasure;
  DateScope _scope = DateScope.week;

  @override
  void initState() {
    super.initState();

    _weights = widget.weights;
    _allWeights = widget.allWeights;
    _user = widget.user;

    if (widget.allMeasures.length > 1) {
      firstMeasure = widget.allMeasures.last;
      lastMeasure = widget.allMeasures.first;
    }

    if (widget.allMeasures.length == 1) {
      firstMeasure = widget.allMeasures.first;
    }

    List<Weight> temp = [];

    if (widget.allWeights.length <= _valuesShownLength) {
      for (Weight wght in widget.allWeights) {
        temp.add(wght);
      }
      _allowExpand = false;
    } else {
      for (int i = 0; i < _valuesShownLength; i++) {
        temp.add(widget.allWeights[i]);
      }
    }

    _expandedWeights = temp;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    List<Weight> temp = [];

    if (_allWeights.length <= _valuesShownLength) {
      for (Weight wght in _allWeights) {
        temp.add(wght);
      }
      _allowExpand = false;
    } else {
      for (int i = 0; i < _valuesShownLength; i++) {
        temp.add(_allWeights[i]);
      }
    }

    _expandedWeights = temp;
  }

  double maxValue(List<Weight> weights) {
    double _max = widget.user.initWeight;

    for (Weight weight in weights) {
      if (weight.weight > _max) {
        _max = weight.weight;
      }
    }

    return _max;
  }

  String getBMI() {
    if (_user.unit == 'imperial') {
      Metric metric = Metric(
        height: _user.height,
        weight: _allWeights.first.weight,
      );

      double height = metric.getParsedHeight();
      double weight = metric.getParsedWeight();

      return (weight / ((height / 100) * (height / 100))).toStringAsFixed(2);
    } else {
      String height = _user.height.replaceAll('\'', '.');
      return (_allWeights.first.weight /
              ((double.parse(height) / 100) * (double.parse(height) / 100)))
          .toStringAsFixed(2);
    }
  }

  String parseDate(String date, DateScope scope) {
    if (scope == DateScope.week) {
      return date.substring(0, 5).replaceAll('-', '/');
    }

    if (scope == DateScope.month) {
      return date.substring(3, 10).replaceAll('-', '/');
    }

    if (scope == DateScope.year) {
      return date.substring(6, 10);
    }

    return '';
  }

  Future<void> handleOffset({
    required OffsetChange direction,
    required int offset,
    DateScope scope = DateScope.week,
  }) async {
    setState(() => _isLoading = true);
    int newOffset =
        direction == OffsetChange.backward ? offset + 1 : offset - 1;

    if (_user.id is int) {
      List<Weight>? weights = await weightService.getScopeWeights(
        id: _user.id!,
        scope: scope,
        offset: newOffset,
      );

      print(weights);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _weights = weights ?? [];
            _offset = newOffset;
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void>? handleDropdown(DateScope? dateScope) async {
    if (dateScope is DateScope) {
      setState(() => _scope = dateScope);

      List<Weight> weights = await weightService.getScopeWeights(
            id: widget.user.id!,
            scope: dateScope,
            offset: 0,
          ) ??
          [];

      print(weights);

      setState(() {
        _weights = weights;
        _offset = 0;
      });
    }
  }

  Widget measureListElement({
    required String text,
    required double prev,
    required double curr,
    int? prevId,
    int? nextId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColor.primaryAccent,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                primary: CustomColor.primaryAccentSemiLight,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
              child: Text(
                '$prev',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColor.primaryAccentLight,
                    ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                if (prevId is int) {
                  Weight? weightFound = _allWeights
                      .firstWhereOrNull((element) => element.id == prevId);

                  if (weightFound is Weight) {
                    BlocProvider.of<MeasuresBloc>(context).add(
                      MeasuresLoadDetailed(
                        weights: _allWeights,
                        weight: weightFound,
                        option: MeasuresDetailedOption.edit,
                        isNotFirst: weightFound.date != _allWeights.last.date,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                primary: CustomColor.primaryAccent,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
              child: Text(
                '$curr',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColor.primaryAccentLight,
                    ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                if (nextId is int) {
                  Weight? weightFound = _allWeights
                      .firstWhereOrNull((element) => element.id == nextId);

                  if (weightFound is Weight) {
                    BlocProvider.of<MeasuresBloc>(context).add(
                      MeasuresLoadDetailed(
                        weights: _allWeights,
                        weight: weightFound,
                        option: MeasuresDetailedOption.edit,
                        isNotFirst: weightFound.date != _allWeights.last.date,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listElement({required Weight weight, required int idx}) {
    Color getColor({required double prev, required double curr}) {
      if (prev < curr) {
        return Nord.auroraRed;
      } else if (prev > curr) {
        return Nord.auroraGreen;
      } else {
        return CustomColor.primaryAccent;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            weight.date.replaceAll('-', '/'),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: CustomColor.primaryAccent,
                ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: Theme.of(context).textTheme.bodyText1,
              primary: idx == _expandedWeights.length - 1
                  ? CustomColor.primaryAccent
                  : getColor(
                      prev: _expandedWeights[idx + 1].weight,
                      curr: _expandedWeights[idx].weight,
                    ),
            ),
            onPressed: () async {
              BlocProvider.of<MeasuresBloc>(context).add(
                MeasuresLoadDetailed(
                  weights: _allWeights,
                  weight: weight,
                  option: MeasuresDetailedOption.edit,
                  isNotFirst: weight.date != _allWeights.last.date,
                ),
              );
            },
            child: Text(
              '${weight.weight} ${_user.unit.toLowerCase() == "metric" ? "kg" : "lb"}',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 22,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.primaryAccentLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasuresBloc, MeasuresState>(builder: (context, state) {
      if (state is MeasuresInitial) {
        return PageBuilder(
          margin: const EdgeInsets.only(top: 82),
          isAppBar: true,
          color: CustomColor.primaryAccent,
          backgroundColor: CustomColor.primaryAccent,
          isDarkIcon: false,
          onBack: () {
            BlocProvider.of<HomeBloc>(context).add(
              HomeLoadInit(
                handlePage: widget.handlePage,
              ),
            );
          },
          isBack: true,
          page: Center(
            child: Column(
              children: [
                Text(
                  '${translate(Keys.measuresHeader)}:',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                      left: 42,
                      right: 42,
                      top: 12,
                      bottom: 48,
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_allWeights.first.weight.toString()} ${_user.unit.toLowerCase() == "metric" ? "kg" : "lb"}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 56),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            _allWeights.first.date.replaceAll('-', '/'),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontSize: 24),
                          ),
                        ),
                        Text(
                          'BMI: ${getBMI()}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 30),
                        ),
                      ],
                    )),
                Container(
                  padding:
                      const EdgeInsets.only(bottom: 62, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: CustomColor.primaryAccentLight,
                  ),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    children: [
                      Dropdown(
                        onChanged: handleDropdown,
                        current: _scope,
                      ),
                      if (_scope != DateScope.week)
                        Text(
                          translate(Keys.chartAprox),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 12,
                                    color: CustomColor.primaryAccentSemiLight,
                                  ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: CustomLineChart(
                          init: maxValue(_weights),
                          target: _user.targetWeight,
                          scope: _scope,
                          weights: _weights,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                        ),
                        child: DateNavigation(
                          text: _scope == DateScope.year
                              ? parseDate(_weights.first.date, DateScope.year)
                              : _scope == DateScope.week
                                  ? '${parseDate(_weights.first.date, DateScope.week)} - ${parseDate(_weights.last.date, DateScope.week)}'
                                  : parseDate(
                                      _weights.first.date,
                                      DateScope.month,
                                    ),
                          isDisabled: _isLoading,
                          isNextDisabled: _isLoading || _offset == 0,
                          offset: _offset,
                          scope: _scope,
                          handleOffset: handleOffset,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 12,
                        ),
                        child: Text(
                          '${translate(Keys.measuresHistoryHeader)}:',
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: CustomColor.primaryAccentDark,
                                    fontSize: 52,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 42,
                          right: 42,
                          top: 12,
                          bottom: 48,
                        ),
                        child: Text(
                          translate(Keys.measuresHistorySubheader),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColor.primaryAccentSemiLight,
                                  ),
                        ),
                      ),
                      Card(
                        color: CustomColor.primaryAccentLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._expandedWeights
                                    .where((element) => element.id != null)
                                    .toList()
                                    .mapIndexed(
                                      (index, e) => listElement(
                                        weight: e,
                                        idx: index,
                                      ),
                                    )
                              ]),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 12,
                          bottom: 24,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: NavigationButton(
                                onPressed: () {
                                  if (_expandedWeights.length <
                                      widget.allWeights.length) {
                                    List<Weight> temp = [];

                                    if (_expandedWeights.length +
                                            _valuesShownLength >=
                                        widget.allWeights.length) {
                                      for (int i = 0;
                                          i < widget.allWeights.length;
                                          i++) {
                                        temp.add(widget.allWeights[i]);
                                      }

                                      setState(() {
                                        _expandedWeights = temp;
                                        _allowExpand = false;
                                      });
                                    } else {
                                      for (int i = 0;
                                          i <
                                              _expandedWeights.length +
                                                  _valuesShownLength;
                                          i++) {
                                        temp.add(widget.allWeights[i]);
                                      }

                                      setState(() => _expandedWeights = temp);
                                    }
                                  }
                                },
                                isIcon: true,
                                icon: Icons.arrow_downward,
                                isDisabled: !_allowExpand,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        child: Text(
                          '${translate(Keys.measuresMeasuresHeader)}:',
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: CustomColor.primaryAccentDark,
                                    fontSize: 52,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 42,
                          right: 42,
                          top: 12,
                          bottom: 28,
                        ),
                        child: Text(
                          translate(Keys.measuresMeasuresSubheader),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColor.primaryAccentSemiLight,
                                  ),
                        ),
                      ),
                      if (widget.allMeasures.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 48.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Text(
                                        translate(Keys.measuresMeasuresStart),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color:
                                                  CustomColor.primaryAccentDark,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Text(
                                        translate(Keys.measuresMeasuresEnd),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color:
                                                  CustomColor.primaryAccentDark,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              measureListElement(
                                text: translate(Keys.measuresNeck),
                                prev: firstMeasure?.neck ?? 0,
                                curr: lastMeasure?.neck ??
                                    firstMeasure?.neck ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresChest),
                                prev: firstMeasure?.chest ?? 0,
                                curr: lastMeasure?.chest ??
                                    firstMeasure?.chest ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresAbdomen),
                                prev: firstMeasure?.abdomen ?? 0,
                                curr: lastMeasure?.abdomen ??
                                    firstMeasure?.abdomen ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresWaist),
                                prev: firstMeasure?.waist ?? 0,
                                curr: lastMeasure?.waist ??
                                    firstMeasure?.calf ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresHips),
                                prev: firstMeasure?.hips ?? 0,
                                curr: lastMeasure?.hips ??
                                    firstMeasure?.hips ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresBicep),
                                prev: firstMeasure?.bicep ?? 0,
                                curr: lastMeasure?.bicep ??
                                    firstMeasure?.bicep ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresThigh),
                                prev: firstMeasure?.thigh ?? 0,
                                curr: lastMeasure?.thigh ??
                                    firstMeasure?.thigh ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                              measureListElement(
                                text: translate(Keys.measuresCalf),
                                prev: firstMeasure?.calf ?? 0,
                                curr: lastMeasure?.calf ??
                                    firstMeasure?.calf ??
                                    0,
                                prevId: firstMeasure?.weightId,
                                nextId: lastMeasure?.weightId ??
                                    firstMeasure?.weightId,
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 4,
                        ),
                        child: NavigationButton(
                          onPressed: () {
                            BlocProvider.of<MeasuresBloc>(context).add(
                              MeasuresLoadDetailed(
                                weights: _allWeights,
                                option: MeasuresDetailedOption.create,
                              ),
                            );
                          },
                          text: translate(Keys.measuresAddBtn),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 42,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }

      if (state is MeasuresDetailed) {
        return MeasureDetailed(
          user: _user,
          lockedDates: state.lockedDates,
          weight: state.weight,
          measure: state.measure,
          option: state.option,
          isNotFirst: state.isNotFirst,
        );
      }

      if (state is MeasuresError) {
        return ErrorPage(handlePage: widget.handlePage);
      }

      return const Loading();
    });
  }
}
