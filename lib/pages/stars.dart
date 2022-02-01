import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/blocs/home/home_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/models.dart';
import 'package:star_metter/services/stars.dart';
import 'package:star_metter/widgets/navigation_button.dart';
import 'package:star_metter/widgets/widgets.dart';

enum OffsetChange { backward, forward }

class Stars extends StatefulWidget {
  final Function() handlePage;
  final List<Star> stars;

  const Stars({
    Key? key,
    required this.handlePage,
    required this.stars,
  }) : super(key: key);

  @override
  State<Stars> createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  StarsService starsService = StarsService();

  late List<Star> _weekStars;
  late List<Star> _chartStars;
  late List<Star> _availableDays;

  int _offset = 0;
  bool _isLoading = false;
  DateScope _scope = DateScope.week;

  @override
  void initState() {
    super.initState();
    _weekStars = widget.stars.reversed.toList();
    _chartStars = widget.stars;
    _availableDays = widget.stars;
  }

  String getText(DateScope scope) {
    Map<DateScope, String> temp = {
      DateScope.week: translate(Keys.datesRangeWeek),
      DateScope.month: translate(Keys.datesRangeMonth),
      DateScope.year: translate(Keys.datesRangeYear),
    };

    return temp[scope]!;
  }

  void handleOffset({
    required OffsetChange direction,
    required int offset,
    DateScope scope = DateScope.week,
  }) async {
    setState(() => _isLoading = true);
    int newOffset =
        direction == OffsetChange.backward ? offset + 1 : offset - 1;
    List<Star> _stars = await starsService.getStars(
      id: _weekStars.first.userId,
      scope: scope,
      offset: newOffset,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _offset = newOffset;
          _chartStars = _stars;
          _isLoading = false;
        });
      }
    });
  }

  Color getColor({required double? stars, required double? limit}) {
    if (stars is double && limit is double) {
      if (stars > limit + 2) {
        return Nord.auroraRed;
      } else if (stars >= limit - 2) {
        return Nord.auroraGreen;
      } else {
        return CustomColor.primaryAccent;
      }
    } else {
      return CustomColor.primaryAccent;
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

  Widget listElement({required Star star}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            star.date.replaceAll('-', '/'),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: Theme.of(context).textTheme.bodyText1,
              primary: getColor(
                stars: star.stars.toDouble(),
                limit: star.progressLimit.toDouble(),
              ),
            ),
            onPressed: () async {
              String? result = await CustomDialog().showNumericDialog(
                context: context,
                header: "${translate(Keys.starsHeader)}:",
                confirmText: translate(Keys.starsDialogConfirm),
                declineText: translate(Keys.starsDialogDecline),
                divider: "/",
                initValue: '${star.stars}.${star.progressLimit}',
                minleft: 0,
                maxLeft: 50,
                minRight: 0,
                maxRight: 50,
              );

              if (result is String) {
                List<String> parsed = result.split('.');
                await starsService.updateStarsLimit(
                  recordId: star.id!,
                  stars: int.parse(parsed.first),
                  limit: int.parse(parsed.last),
                );

                _weekStars[_weekStars
                    .indexWhere((element) => element.id == star.id)] = Star(
                  id: star.id,
                  date: star.date,
                  userId: star.userId,
                  stars: int.parse(parsed.first),
                  progressLimit: int.parse(parsed.last),
                );

                _availableDays[_availableDays
                    .indexWhere((element) => element.id == star.id)] = Star(
                  id: star.id,
                  date: star.date,
                  userId: star.userId,
                  stars: int.parse(parsed.first),
                  progressLimit: int.parse(parsed.last),
                );

                int idx =
                    _chartStars.indexWhere((element) => element.id == star.id);

                setState(() {
                  if (idx != -1) {
                    _chartStars[idx] = Star(
                      id: star.id,
                      date: star.date,
                      userId: star.userId,
                      stars: int.parse(parsed.first),
                      progressLimit: int.parse(parsed.last),
                    );
                  }
                });

                if (_scope == DateScope.month) {
                  List<Star> _stars = await starsService.getStars(
                    id: _weekStars.first.userId,
                    scope: DateScope.month,
                    offset: 0,
                  );

                  setState(() => _chartStars = _stars);
                }
              }
            },
            child: Text(
              '${star.stars}/${star.progressLimit}',
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

  Widget dropdown() {
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
        value: _scope,
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
        onChanged: (DateScope? dateScope) async {
          if (dateScope is DateScope) {
            setState(() => _scope = dateScope);

            if (dateScope == DateScope.week) {
              List<Star> _stars = await starsService.getStars(
                id: _weekStars.first.userId,
                scope: DateScope.week,
                offset: 0,
              );

              setState(() {
                _chartStars = _stars;
                _offset = 0;
              });
            }

            if (dateScope == DateScope.month) {
              List<Star> _stars = await starsService.getStars(
                id: _weekStars.first.userId,
                scope: DateScope.month,
                offset: 0,
              );

              setState(() {
                _chartStars = _stars;
                _offset = 0;
              });
            }

            if (dateScope == DateScope.year) {
              List<Star> _stars = await starsService.getStars(
                id: _weekStars.first.userId,
                scope: DateScope.year,
                offset: 0,
              );

              setState(() {
                _chartStars = _stars;
                _offset = 0;
              });
            }
          }
        },
      ),
    );
  }

  Widget navigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        NavigationButton(
          onPressed: () async => handleOffset(
            direction: OffsetChange.backward,
            offset: _offset,
            scope: _scope,
          ),
          isIcon: true,
          icon: Icons.arrow_back,
          isDisabled: _isLoading,
        ),
        SizedBox(
          width: 150,
          child: Text(
            _scope == DateScope.year
                ? parseDate(_chartStars.first.date, DateScope.year)
                : _scope == DateScope.week
                    ? '${parseDate(_chartStars.first.date, DateScope.week)} - ${parseDate(_chartStars.last.date, DateScope.week)}'
                    : parseDate(
                        _chartStars.first.date,
                        DateScope.month,
                      ),
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
            offset: _offset,
            scope: _scope,
          ),
          isIcon: true,
          isDisabled: _offset == 0 || _isLoading,
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Star> _stars = _weekStars;

    return PageBuilder(
      margin: const EdgeInsets.only(top: 82),
      isAppBar: true,
      color: CustomColor.primaryAccent,
      backgroundColor: CustomColor.primaryAccent,
      isDarkIcon: false,
      onBack: () => BlocProvider.of<HomeBloc>(context).add(
        HomeLoadInit(
          handlePage: widget.handlePage,
        ),
      ),
      isBack: true,
      page: Center(
        child: Column(
          children: [
            Text(
              '${translate(Keys.starsHeader)}:',
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
              child: Text(
                translate(Keys.starsSubheader),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 62),
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
                  dropdown(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Chart(
                      stars: _chartStars,
                      initialLimit: _chartStars.last.progressLimit,
                      scope: _scope,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          child: navigation(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 32,
                            bottom: 12,
                          ),
                          child: Text(
                            '${translate(Keys.starsHeaderWeek)}:',
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
                            translate(Keys.starsSubheaderWeek),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColor.primaryAccentSemiLight,
                                    ),
                          ),
                        ),
                        Card(
                          color: CustomColor.primaryAccentSemiLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._availableDays
                                      .where((element) => element.id != null)
                                      .toList()
                                      .map(
                                        (e) => listElement(star: e),
                                      )
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: NavigationButton(
                            isDisabled: !_availableDays.any(
                              (element) => element.id == null,
                            ),
                            customIconPaddingHorizontal: 52,
                            onPressed: () async {
                              List<String> days = [];

                              for (Star star in _availableDays) {
                                if (star.id == null) {
                                  days.add(star.date);
                                }
                              }

                              String? result =
                                  await CustomDialog().showNumericDialog(
                                context: context,
                                header:
                                    '${translate(Keys.starsDialogNewHeader)}:',
                                confirmText: translate(Keys.starsDialogConfirm),
                                declineText: translate(Keys.starsDialogDecline),
                                divider: "/",
                                initValue: '0.${_stars.last.progressLimit}',
                                allowedStars: days,
                                minleft: 0,
                                maxLeft: 50,
                                minRight: 0,
                                maxRight: 50,
                              );

                              if (result != null) {
                                List<String> collectedData = result.split('.');
                                int stars = int.parse(collectedData[0]);
                                int limit = int.parse(collectedData[1]);

                                Star? newStar = await starsService.insertStar(
                                  userId: _chartStars.first.userId,
                                  date: collectedData[2],
                                  stars: stars,
                                  limit: limit,
                                );

                                int idxChart = _chartStars.indexWhere(
                                  (element) => element.date == collectedData[2],
                                );

                                int idxWeek = _weekStars.indexWhere(
                                  (element) => element.date == collectedData[2],
                                );

                                int idxAv = _availableDays.indexWhere(
                                  (element) => element.date == collectedData[2],
                                );

                                if (newStar is Star) {
                                  setState(() {
                                    if (idxChart != -1 &&
                                        _scope != DateScope.month) {
                                      _chartStars[idxChart] = newStar;
                                    }

                                    if (idxWeek != -1) {
                                      _weekStars[idxWeek] = newStar;
                                      _availableDays[idxAv] = newStar;
                                    }
                                  });
                                }

                                if (idxChart != -1 &&
                                    _scope == DateScope.month) {
                                  List<Star> _stars =
                                      await starsService.getStars(
                                    id: _availableDays.first.userId,
                                    scope: DateScope.month,
                                    offset: 0,
                                  );

                                  setState(() {
                                    _chartStars = _stars;
                                  });
                                }
                              }
                            },
                            isIcon: true,
                            icon: Icons.add,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
