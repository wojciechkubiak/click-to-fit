import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/blocs/home/home_bloc.dart';
import 'package:star_metter/blocs/measures/measures_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/keys.dart';
import 'package:star_metter/models/measure.dart';
import 'package:star_metter/models/models.dart';
import 'package:star_metter/services/weight.dart';
import 'package:star_metter/widgets/calendar.dart';
import 'package:star_metter/widgets/navigation_button.dart';
import 'package:star_metter/widgets/number_value_picker.dart';
import 'package:star_metter/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class MeasureDetailed extends StatefulWidget {
  final User user;
  final List<String> lockedDates;
  final Weight? weight;
  final Measure? measure;
  final MeasuresDetailedOption option;
  final bool? isNotFirst;

  const MeasureDetailed({
    Key? key,
    required this.option,
    required this.user,
    required this.lockedDates,
    this.weight,
    this.measure,
    this.isNotFirst = true,
  }) : super(key: key);

  @override
  State<MeasureDetailed> createState() => _MeasureDetailedState();
}

class _MeasureDetailedState extends State<MeasureDetailed> {
  DateTime date = DateTime.now();
  bool isError = false;

  late int weightV1;
  late int weightV2;

  int neckV1 = 0;
  int neckV2 = 0;
  int abdomenV1 = 0;
  int abdomenV2 = 0;
  int chestV1 = 0;
  int chestV2 = 0;
  int hipsV1 = 0;
  int hipsV2 = 0;
  int bicepV1 = 0;
  int bicepV2 = 0;
  int thighV1 = 0;
  int thighV2 = 0;
  int waistV1 = 0;
  int waistV2 = 0;
  int calfV1 = 0;
  int calfV2 = 0;

  @override
  void initState() {
    super.initState();

    if (widget.option == MeasuresDetailedOption.edit &&
        widget.weight is Weight) {
      List<String> v1 = widget.weight!.date.split('-');

      date = DateTime.utc(
        int.parse(v1[2]),
        int.parse(v1[1]),
        int.parse(v1[0]),
      );
    }

    if (widget.weight is Weight) {
      List<String> _tempWeight = widget.weight!.weight.toString().split('.');
      weightV1 = int.parse(_tempWeight.first);
      weightV2 = int.parse(_tempWeight.last);
    } else {
      List<String> _tempWeight = widget.user.initWeight.toString().split('.');

      weightV1 = int.parse(_tempWeight.first);
      weightV2 = int.parse(_tempWeight.last);
    }

    print('MEASURE ${widget.measure}');

    if (widget.measure is Measure) {
      List<String> _tempNeck = widget.measure!.neck.toString().split('.');
      neckV1 = int.parse(_tempNeck.first);
      neckV2 = int.parse(_tempNeck.last);

      List<String> _tempAbdomen = widget.measure!.abdomen.toString().split('.');
      abdomenV1 = int.parse(_tempAbdomen.first);
      abdomenV2 = int.parse(_tempAbdomen.last);

      List<String> _tempChest = widget.measure!.chest.toString().split('.');
      chestV1 = int.parse(_tempChest.first);
      chestV2 = int.parse(_tempChest.last);

      List<String> _tempHips = widget.measure!.hips.toString().split('.');
      hipsV1 = int.parse(_tempHips.first);
      hipsV2 = int.parse(_tempHips.last);

      List<String> _tempBicep = widget.measure!.bicep.toString().split('.');
      bicepV1 = int.parse(_tempBicep.first);
      bicepV2 = int.parse(_tempBicep.last);

      List<String> _tempThigh = widget.measure!.thigh.toString().split('.');
      thighV1 = int.parse(_tempThigh.first);
      thighV2 = int.parse(_tempThigh.last);

      List<String> _tempWaist = widget.measure!.waist.toString().split('.');
      waistV1 = int.parse(_tempWaist.first);
      waistV2 = int.parse(_tempWaist.last);

      List<String> _tempCalf = widget.measure!.calf.toString().split('.');
      calfV1 = int.parse(_tempCalf.first);
      calfV2 = int.parse(_tempCalf.last);
    }
  }

  void handleDate({required DateTime dt}) => setState(() => date = dt);

  Measure getMeasure({
    required String date,
    Measure? measure,
    int? weightId,
  }) {
    if (measure is Measure) {
      Measure _measure = measure;
      _measure.userId = widget.user.id!;
      _measure.weightId = weightId;
      _measure.date = date;
      _measure.neck = double.parse('$neckV1.$neckV2');
      _measure.abdomen = double.parse('$abdomenV1.$abdomenV2');
      _measure.chest = double.parse('$chestV1.$chestV2');
      _measure.hips = double.parse('$hipsV1.$hipsV2');
      _measure.bicep = double.parse('$bicepV1.$bicepV2');
      _measure.thigh = double.parse('$thighV1.$thighV2');
      _measure.waist = double.parse('$waistV1.$waistV2');
      _measure.calf = double.parse('$calfV1.$calfV2');
      return _measure;
    } else {
      Measure _measure = Measure(
        userId: widget.user.id!,
        weightId: weightId,
        date: date,
        neck: double.parse('$neckV1.$neckV2'),
        abdomen: double.parse('$abdomenV1.$abdomenV2'),
        chest: double.parse('$chestV1.$chestV2'),
        hips: double.parse('$hipsV1.$hipsV2'),
        bicep: double.parse('$bicepV1.$bicepV2'),
        thigh: double.parse('$thighV1.$thighV2'),
        waist: double.parse('$waistV1.$waistV2'),
        calf: double.parse('$calfV1.$calfV2'),
      );

      return _measure;
    }
  }

  Widget picker({
    required Unit unit,
    required int v1,
    required int v2,
    required Function(int) handleV1,
    required Function(int) handleV2,
    required int max,
    required String header,
    int min = 0,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              header,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: CustomColor.primaryAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberValuePicker(
                value: v1,
                min: min,
                max: max,
                onChanged: handleV1,
                color: CustomColor.primaryAccentDark,
                textColor: CustomColor.primaryAccentLightSaturated,
                selectedTextColor: CustomColor.primaryAccentLight,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  ',',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.primaryAccent,
                  ),
                ),
              ),
              NumberValuePicker(
                value: v2,
                min: 0,
                max: 9,
                onChanged: handleV2,
                color: CustomColor.primaryAccent,
                textColor: CustomColor.primaryAccentLightSaturated,
                selectedTextColor: CustomColor.primaryAccentLight,
              ),
            ],
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
        BlocProvider.of<MeasuresBloc>(context).add(MeasuresLoadInit());
      },
      isBack: true,
      page: Center(
        child: Column(
          children: [
            Text(
              '${translate(Keys.measuresDayHeader)}:',
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
              child: Calendar(
                lockedDates: List.from(
                  widget.lockedDates.map(
                    (e) {
                      List<String> v1 = e.split('-');

                      if (v1.length == 3) {
                        return DateTime.utc(
                          int.parse(v1[2]),
                          int.parse(v1[1]),
                          int.parse(v1[0]),
                        );
                      }
                    },
                  ),
                ),
                hideError: () => setState(() => isError = false),
                handleDate: handleDate,
                weight: widget.weight,
                option: widget.option,
              ),
            ),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      bottom: 12,
                    ),
                    child: Text(
                      '${translate(Keys.measuresMeasuresHeader)}:',
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
                    ),
                    child: Text(
                      translate(Keys.measuresMeasuresSubheader),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColor.primaryAccentSemiLight,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: picker(
                      header:
                          '${translate(Keys.measuresHeader)} (${widget.user.unit.toLowerCase() == "metric" ? "kg" : "lb"}):',
                      unit: widget.user.unit.toLowerCase() == "metric"
                          ? Unit.metric
                          : Unit.imperial,
                      v1: weightV1,
                      v2: weightV2,
                      min: widget.user.initWeight > widget.user.targetWeight
                          ? (widget.user.targetWeight - 30).floor()
                          : (widget.user.targetWeight - 10).floor(),
                      max: 999,
                      handleV1: (value) => setState(() => weightV1 = value),
                      handleV2: (value) => setState(() => weightV1 = value),
                    ),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresNeck)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: neckV1,
                    v2: neckV2,
                    min: 0,
                    max: 150,
                    handleV1: (value) => setState(() => neckV1 = value),
                    handleV2: (value) => setState(() => neckV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresChest)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: chestV1,
                    v2: chestV2,
                    min: 0,
                    max: 500,
                    handleV1: (value) => setState(() => chestV1 = value),
                    handleV2: (value) => setState(() => chestV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresAbdomen)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: abdomenV1,
                    v2: abdomenV2,
                    min: 0,
                    max: 500,
                    handleV1: (value) => setState(() => abdomenV1 = value),
                    handleV2: (value) => setState(() => abdomenV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresWaist)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: waistV1,
                    v2: waistV2,
                    min: 0,
                    max: 500,
                    handleV1: (value) => setState(() => waistV1 = value),
                    handleV2: (value) => setState(() => waistV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresHips)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: hipsV1,
                    v2: hipsV2,
                    min: 0,
                    max: 500,
                    handleV1: (value) => setState(() => hipsV1 = value),
                    handleV2: (value) => setState(() => hipsV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresBicep)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: bicepV1,
                    v2: bicepV2,
                    min: 0,
                    max: 300,
                    handleV1: (value) => setState(() => bicepV1 = value),
                    handleV2: (value) => setState(() => bicepV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresThigh)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: thighV1,
                    v2: thighV2,
                    min: 0,
                    max: 400,
                    handleV1: (value) => setState(() => thighV1 = value),
                    handleV2: (value) => setState(() => thighV2 = value),
                  ),
                  picker(
                    header:
                        '${translate(Keys.measuresCalf)} (${widget.user.unit.toLowerCase() == "metric" ? "cm" : "in"}):',
                    unit: widget.user.unit.toLowerCase() == "metric"
                        ? Unit.metric
                        : Unit.imperial,
                    v1: calfV1,
                    v2: calfV2,
                    min: 0,
                    max: 350,
                    handleV1: (value) => setState(() => calfV1 = value),
                    handleV2: (value) => setState(() => calfV2 = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: NavigationButton(
                      isDisabled: isError,
                      onPressed: () {
                        String _date =
                            DateParser(date: date).getDateWithoutTime();

                        String dateFound = widget.lockedDates.firstWhere(
                          (element) => element == _date,
                          orElse: () => '',
                        );

                        if (dateFound.isNotEmpty && widget.weight is! Weight) {
                          setState(() => isError = true);
                        } else {
                          Weight newWeight = Weight(
                            id: widget.weight is Weight
                                ? widget.weight!.id
                                : null,
                            date: widget.weight is Weight
                                ? widget.weight!.date
                                : _date,
                            userId: widget.user.id!,
                            weight: double.parse('$weightV1.$weightV2'),
                          );

                          Measure? newMeasure = getMeasure(
                            date: _date,
                            weightId: newWeight.id,
                            measure: widget.measure,
                          );

                          if (widget.weight is Weight &&
                              widget.measure is! Measure) {
                            BlocProvider.of<MeasuresBloc>(context)
                                .add(MeasureCreate(
                              weight: newWeight,
                              measure: newMeasure,
                            ));
                            BlocProvider.of<HomeBloc>(context).add(
                              HomeLoadMeasures(
                                user: widget.user,
                                isDelayed: true,
                              ),
                            );
                          }

                          if (widget.weight is Weight &&
                              widget.measure is Measure) {
                            BlocProvider.of<MeasuresBloc>(context).add(
                              MeasureUpdate(
                                weight: newWeight,
                                measure: newMeasure,
                              ),
                            );
                            BlocProvider.of<HomeBloc>(context).add(
                              HomeLoadMeasures(
                                user: widget.user,
                                isDelayed: true,
                              ),
                            );
                          }

                          if (widget.weight is! Weight &&
                              widget.measure is! Measure) {
                            bool isLast = false;

                            for (String locked in widget.lockedDates) {
                              List<String> v1 = locked.split('-');

                              DateTime dt = DateTime.utc(
                                int.parse(v1[2]),
                                int.parse(v1[1]),
                                int.parse(v1[0]),
                              );

                              DateTime dt2 = DateTime.utc(
                                date.year,
                                date.month,
                                date.day,
                              );

                              if (dt2.isBefore(dt)) {
                                isLast = true;
                              }
                            }

                            BlocProvider.of<MeasuresBloc>(context)
                                .add(MeasureCreate(
                              weight: newWeight,
                              measure: newMeasure,
                              isLast: isLast,
                            ));
                            BlocProvider.of<HomeBloc>(context).add(
                              HomeLoadMeasures(
                                user: widget.user,
                                isDelayed: true,
                              ),
                            );
                          }
                        }
                      },
                      text: widget.option == MeasuresDetailedOption.create
                          ? translate(Keys.measuresAddBtn)
                          : translate(Keys.measuresSubmitBtn),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 52,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: isError
                        ? Text(
                            translate(Keys.measuresExists),
                            style: const TextStyle(
                              color: Nord.auroraRed,
                            ),
                          )
                        : null,
                  ),
                  if (widget.weight is Weight && widget.isNotFirst!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: NavigationButton(
                        isDisabled: isError,
                        onPressed: () async {
                          bool? result = await CustomDialog().showBaseDialog(
                            context: context,
                            header: "${translate(Keys.measuresDialogHeader)}:",
                            dialogBody: translate(Keys.measuresDialogBody),
                            confirmText: translate(Keys.measuresDialogConfirm),
                            declineText: translate(Keys.measuresDialogDecline),
                          );

                          if (result is bool) {
                            if (result) {
                              if (widget.weight?.id is int) {
                                BlocProvider.of<MeasuresBloc>(context).add(
                                  MeasureDelete(
                                    weightId: widget.weight!.id!,
                                  ),
                                );
                                BlocProvider.of<HomeBloc>(context).add(
                                  HomeLoadMeasures(
                                    user: widget.user,
                                    isDelayed: true,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        text: translate(Keys.measuresDeleteBtn),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 52,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
