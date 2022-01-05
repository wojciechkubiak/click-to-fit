import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:star_metter/widgets/custom_icon_button.dart';
import 'package:star_metter/widgets/shadow_wrapper.dart';

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

  @override
  void initState() {
    super.initState();
    user = widget.user;
    progress = widget.progress;
  }

  double getBMI() {
    if (progress.weight is Weight) {
      return (progress.weight!.weight /
          ((user.height / 100) * (user.height / 100)));
    } else {
      if (progress.prevWeight is Weight) {
        return (progress.prevWeight!.weight /
            ((user.height / 100) * (user.height / 100)));
      } else {
        return 0;
      }
    }
  }

  Widget starCounter() {
    Star stars = progress.star;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 42),
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
                      progress.starProgress.last.stars = stars.stars - 1;
                    }
                    stars.stars = stars.stars - 1;
                  });
                }
              }
            },
            icon: Icons.remove,
            isDisabled: stars.stars == 0,
          ),
          Column(
            children: [
              Icon(
                Icons.star_border,
                size: 64,
                color: stars.stars < stars.progressLimit - 2
                    ? Nord.light
                    : stars.stars > stars.progressLimit + 2
                        ? Nord.auroraRed
                        : Nord.auroraGreen,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Text(
                      '${stars.stars < 10 ? "0" : ""}${stars.stars}',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: stars.stars < stars.progressLimit - 2
                            ? Nord.light
                            : stars.stars > stars.progressLimit + 2
                                ? Nord.auroraRed
                                : Nord.auroraGreen,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: Text(
                        '/${stars.progressLimit}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          color: Nord.light,
                        ),
                      ))
                ],
              )
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
                      progress.starProgress.last.stars = stars.stars + 1;
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
      margin: const EdgeInsets.only(bottom: 20),
      isAppBar: true,
      color: Nord.darker,
      onBack: widget.showMenu,
      page: Padding(
        padding: const EdgeInsets.only(top: 82.0, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadowWrapper(
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
                      'Today:',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  starCounter(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Chart(
                    stars: progress.starProgress,
                    initialLimit: progress.starProgress.isNotEmpty
                        ? progress.starProgress.last.progressLimit
                        : progress.star.progressLimit,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 42.0),
                    child: Text(
                      'Weight:',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w300,
                        color: Nord.light,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  WeightCard(
                    padding: const EdgeInsets.only(top: 24, bottom: 32),
                    currentWeight: progress.weight?.weight,
                    date: progress.weight?.date,
                    previousWeight: progress.prevWeight?.weight,
                    previousDate: progress.prevWeight?.date,
                    bmi: getBMI(),
                  ),
                  Center(
                    child: CustomIconButton(
                      text: progress.weight is Weight
                          ? 'Update weight'
                          : 'Add weight',
                      onClick: () async {
                        double initValue = progress.weight is Weight
                            ? progress.weight!.weight
                            : progress.prevWeight!.weight;

                        double? result = await CustomDialog().showNumericDialog(
                          context: context,
                          header: "New weight",
                          confirmText: "Confirm",
                          declineText: "Cancel",
                          dialogBody: "test",
                          initValue: initValue,
                        );

                        if (result != null && result != initValue) {
                          double value = result;
                          int? id =
                              progress.weight?.id ?? progress.prevWeight?.id;

                          if (id is int) {
                            if (progress.weight is Weight) {
                              setState(
                                () => progress.weight!.weight = value,
                              );
                              WeightService()
                                  .updateWeight(recordId: id, weight: value);
                            } else {
                              Weight? weight =
                                  await WeightService().insertNewRecord(
                                id: user.id!,
                                weight: value,
                              );
                              setState(
                                () => progress.weight = weight,
                              );
                            }
                          }

                          if (id != null) {}
                        }
                      },
                      icon: Icons.add,
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
