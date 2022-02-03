import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/blocs/home/home_bloc.dart';
import 'package:star_metter/models/metric.dart';
import 'package:star_metter/widgets/gauge.dart';
import 'package:star_metter/widgets/navigation_button.dart';

import '../lang/keys.dart';
import '../../config/colors.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class Home extends StatefulWidget {
  final User user;
  final Progress progress;
  final Function? showMenu;

  const Home({
    Key? key,
    required this.showMenu,
    required this.user,
    required this.progress,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StarsService starsService = StarsService();
  late User user;
  late Progress progress;
  late Star current;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    progress = widget.progress;
    current =
        widget.progress.starProgress.lastWhere((element) => element.id != null);
  }

  double getBMI() {
    if (user.unit == 'imperial') {
      Metric metric = Metric(
        height: user.height,
        weight: progress.weight?.weight ?? progress.prevWeight?.weight,
      );

      double height = metric.getParsedHeight();
      double weight = metric.getParsedWeight();

      return (weight / ((height / 100) * (height / 100)));
    } else {
      String height = user.height.replaceAll('\'', '.');
      if (progress.weight is Weight) {
        return (progress.weight!.weight /
            ((double.parse(height) / 100) * (double.parse(height) / 100)));
      } else {
        if (progress.prevWeight is Weight) {
          return (progress.prevWeight!.weight /
              ((double.parse(height) / 100) * (double.parse(height) / 100)));
        } else {
          return 0;
        }
      }
    }
  }

  Color getColor({required double? current, required double? previous}) {
    if (previous is double && current is double) {
      if (current > previous) {
        return Nord.auroraRed;
      } else if (current < previous) {
        return Nord.auroraGreen;
      } else {
        return CustomColor.primaryAccent;
      }
    } else {
      return CustomColor.primaryAccent;
    }
  }

  Widget starCounter() {
    Star stars = progress.star;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CounterButton(
            onClick: () async {
              if (stars.stars > 0) {
                bool update = await starsService.updateStars(
                    recordId: stars.id!, stars: stars.stars - 1);
                if (update) {
                  setState(() {
                    if (progress.starProgress.isNotEmpty) {
                      current.stars = stars.stars - 1;
                    }
                    stars.stars = stars.stars - 1;
                  });
                }
              }
            },
            icon: Icons.remove,
            isDisabled: stars.stars == 0,
          ),
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  minHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: CustomColor.primaryAccentLight,
                  borderRadius: BorderRadius.circular(160),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_border,
                      size: 64,
                      color: CustomColor.primaryAccentSemiLight,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: Text(
                            '${stars.stars < 10 ? "0" : ""}${stars.stars}',
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: CustomColor.primaryAccent,
                                      fontSize: 52,
                                    ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Text(
                            '/${stars.progressLimit}',
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: CustomColor.primaryAccent,
                                      fontSize: 26,
                                    ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                  minHeight: MediaQuery.of(context).size.width * 0.6,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Gauge(
                  currentValue: progress.star.stars.toDouble(),
                  max: progress.star.progressLimit.toDouble(),
                ),
              ),
            ],
          ),
          CounterButton(
            onClick: () async {
              if (stars.stars < 99) {
                bool update = await starsService.updateStars(
                    recordId: stars.id!, stars: stars.stars + 1);
                if (update) {
                  setState(() {
                    if (progress.starProgress.isNotEmpty) {
                      current.stars = stars.stars + 1;
                    }
                    stars.stars = stars.stars + 1;
                  });
                }
              }
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      margin: EdgeInsets.zero,
      isAppBar: true,
      color: CustomColor.primaryAccent,
      isDarkIcon: false,
      onBack: widget.showMenu,
      backgroundColor: CustomColor.primaryAccent,
      page: Padding(
        padding: const EdgeInsets.only(
          top: 82.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 28),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 42),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: Colors.white30,
                        ),
                      ),
                    ),
                    child: Text(
                      '${translate(Keys.globalToday)}:',
                      style: Theme.of(context).textTheme.headline2!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  starCounter(),
                ],
              ),
            ),
            Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Chart(
                    stars: progress.starProgress,
                    initialLimit: progress.starProgress.isNotEmpty
                        ? progress.starProgress.last.progressLimit
                        : progress.star.progressLimit,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 12),
                    child: NavigationButton(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeLoadStars());
                      },
                      text: translate(Keys.globalMore),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 42.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.3,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${translate(Keys.globalPrevious)}:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: CustomColor.primaryAccentSemiLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (progress.prevWeight?.weight is double) ...[
                                Text(
                                  '${progress.prevWeight?.weight} ${user.unit == 'imperial' ? 'lb' : 'kg'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColor.primaryAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                ),
                                Text(
                                  '${progress.prevWeight?.date.replaceAll('-', '/')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color:
                                            CustomColor.primaryAccentSemiLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                ),
                              ] else
                                Text(
                                  translate(Keys.globalNA),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color:
                                            CustomColor.primaryAccentSemiLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 52,
                                      ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 200,
                            minWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Card(
                            color: getColor(
                              current: progress.weight?.weight,
                              previous: progress.prevWeight?.weight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  '${progress.weight!.weight} ${user.unit == 'imperial' ? 'lb' : 'kg'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 48,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  progress.weight!.date,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColor.primaryAccentLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'BMI ${getBMI().toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    primary: CustomColor.primaryAccentLight,
                                  ),
                                  onPressed: () async {
                                    double initValue = progress.weight is Weight
                                        ? progress.weight!.weight
                                        : progress.prevWeight!.weight;

                                    String? result =
                                        await CustomDialog().showNumericDialog(
                                      context: context,
                                      header:
                                          "${translate(Keys.globalDialogHeader)} (${user.unit == "metric" ? "kg" : "lg"}):",
                                      confirmText:
                                          translate(Keys.starsDialogConfirm),
                                      declineText:
                                          translate(Keys.starsDialogDecline),
                                      initValue: initValue.toString(),
                                      minleft: user.unit == "metric" ? 42 : 85,
                                      maxLeft:
                                          user.unit == "metric" ? 400 : 900,
                                      minRight: 0,
                                      maxRight: 9,
                                    );

                                    if (result is String) {
                                      int? id = progress.weight?.id ??
                                          progress.prevWeight?.id;

                                      if (id is int) {
                                        if (progress.weight is Weight) {
                                          setState(
                                            () => progress.weight!.weight =
                                                double.parse(result),
                                          );
                                          WeightService().updateWeight(
                                            recordId: id,
                                            weight: double.parse(result),
                                          );

                                          if (progress.prevWeight?.weight
                                                  is! double &&
                                              user.id is int) {
                                            HomeService().updateUserWeight(
                                              user.id!,
                                              double.parse(result),
                                            );
                                          }
                                        } else {
                                          Weight? weight = await WeightService()
                                              .insertNewRecord(
                                            userId: user.id!,
                                            weight: double.parse(result),
                                          );
                                          setState(
                                            () => progress.weight = weight,
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    progress.weight is Weight
                                        ? translate(Keys.globalUpdate)
                                        : translate(Keys.globalAdd),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColor.primaryAccentDark,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 62,
                    ),
                    child: NavigationButton(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeLoadMeasures(
                          user: user,
                        ));
                      },
                      text: translate(Keys.globalMore),
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
