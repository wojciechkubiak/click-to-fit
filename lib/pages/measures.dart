import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/metric.dart';
import 'package:star_metter/models/models.dart';
import 'package:star_metter/models/star.dart';
import 'package:star_metter/pages/stars.dart';
import 'package:star_metter/services/weight.dart';
import 'package:star_metter/widgets/custom_line_chart.dart';
import 'package:star_metter/widgets/date_navigation.dart';
import 'package:star_metter/widgets/dropdown.dart';
import 'package:star_metter/widgets/navigation_button.dart';

import '../widgets/widgets.dart';
import '../blocs/home/home_bloc.dart';

class Measures extends StatefulWidget {
  final Function() handlePage;
  final List<Weight> weights;
  final List<Weight> allWeights;
  final User user;

  const Measures({
    Key? key,
    required this.handlePage,
    required this.weights,
    required this.allWeights,
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
  DateScope _scope = DateScope.week;

  @override
  void initState() {
    super.initState();

    _weights = widget.weights;
    _allWeights = widget.allWeights;
    _user = widget.user;

    List<Weight> temp = [];

    if (widget.allWeights.length < _valuesShownLength) {
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

  String getBMI() {
    if (_user.unit == 'imperial') {
      Metric metric = Metric(
        height: _user.height,
        weight: _allWeights.last.weight,
      );

      double height = metric.getParsedHeight();
      double weight = metric.getParsedWeight();

      return (weight / ((height / 100) * (height / 100))).toStringAsFixed(2);
    } else {
      String height = _user.height.replaceAll('\'', '.');
      return (_allWeights.last.weight /
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

  Widget listElement({required Weight weight}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              primary: CustomColor.primaryAccent,
            ),
            onPressed: () async {},
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
              'Waga:',
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
                      '${_allWeights.last.weight.toString()} ${_user.unit.toLowerCase() == "metric" ? "kg" : "lb"}',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 56),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        _allWeights.last.date.replaceAll('-', '/'),
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
              padding: const EdgeInsets.only(bottom: 62, left: 20, right: 20),
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
                    onChanged: (DateScope? scope) async {},
                    current: DateScope.week,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CustomLineChart(
                      init: _user.initWeight,
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
                      isNextDisabled: _offset == 0 || _isLoading,
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
                      'Historia wagi:',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
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
                      "Kliknij na wagę po prawej stronie daty w celu edytowania pomiarów.",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._expandedWeights
                                .where((element) => element.id != null)
                                .toList()
                                .map(
                                  (e) => listElement(weight: e),
                                )
                          ]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 62,
                    ),
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: NavigationButton(
                            onPressed: () {},
                            text: "Dodaj pomiar",
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 52),
                          ),
                        ),
                      ],
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
}
