import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:star_metter/widgets/number_value_picker.dart';

import '../../blocs/home/home_bloc.dart';
import '../../config/colors.dart';
import '../../models/models.dart';
import '../../pages/pages.dart';
import '../../widgets/widgets.dart';

class Intro extends StatefulWidget {
  final Function() handlePage;
  final IntroMode introMode;

  const Intro({
    Key? key,
    required this.handlePage,
    required this.introMode,
  }) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validator = Validator();

  int _step = 1;
  Sex? _sex;
  double _activityLevel = 3;
  List<String> headers = [
    'Sick / Mostly laying',
    'Low / Office work',
    'Medium / 2-3 trainings/week',
    'Above avarege / 3-4 trainings/week',
    'High / Physical worker / Proffesional'
  ];
  int stars = 0;
  int result = 0;

  int _age = 18;

  Unit _unit = Unit.metric;
  int _heightCm = 175;
  int _heightMm = 5;
  int _weightKg = 85;
  int _weightDec = 5;
  int _targetWeightKg = 75;
  int _targetWeightDec = 5;

  late TextEditingController name;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: '');
  }

  double ppmMale(double weight, double height, int age) {
    // Harris-Benedict
    return 66 + (13.7 * weight) + (5 * height) - (6.76 * age);
  }

  double ppmFemale(double weight, double height, int age) {
    // Harris-Benedict
    return 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
  }

  double? parseMetric({
    required bool isWeight,
    required int v1,
    required int v2,
  }) {
    if (isWeight) {
      double? lb = double.tryParse('$v1.$v2');

      if (lb is double) {
        return lb * 0.45;
      } else {
        return null;
      }
    } else {
      return v1 * 30.48 + v2 * 2.54;
    }
  }

  int? countStars() {
    double? _height = _unit == Unit.metric
        ? double.parse('$_heightCm.$_heightMm')
        : parseMetric(
            isWeight: false,
            v1: _heightCm,
            v2: _heightMm,
          );
    double? _weight = _unit == Unit.metric
        ? double.parse('$_weightKg.$_weightDec')
        : parseMetric(
            isWeight: true,
            v1: _weightKg,
            v2: _weightDec,
          );

    if (_height is double && _weight is double) {
      int _activity = _activityLevel.toInt();

      double ppm = _sex == Sex.male
          ? ppmMale(_weight, _height, _age)
          : ppmFemale(_weight, _height, _age);

      List pal = _sex == Sex.male
          ? [null, 1.2, 1.25, 1.5, 1.75, 2.0]
          : [null, 1.15, 1.2, 1.4, 1.65, 1.9];

      double cpm = ppm * pal[_activity];
      return (cpm / 100).ceil();
    } else {
      return null;
    }
  }

  String parseEnum(dynamic en) {
    return en.toString().split('.').last;
  }

  Widget tileButton({
    required IconData icon,
    required Function() onTap,
    required bool isActive,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 122,
              color: isActive ? CustomColor.primaryAccentLight : Colors.grey,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isActive
                        ? CustomColor.primaryAccentLight
                        : Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget agePicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 62, horizontal: 32),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Text(
                  'How young are you?',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "We need it for our calculations",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              ],
            ),
          ),
          NumberValuePicker(
            value: _age,
            min: 1,
            max: 100,
            axis: Axis.horizontal,
            onChanged: (value) => setState(() => _age = value),
          ),
        ],
      ),
    );
  }

  Widget unitPicker({
    required String text,
    required String textHeight,
    required String textWeight,
    required void Function() onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(top: 24),
        height: 120,
        decoration: BoxDecoration(
          color: isActive ? CustomColor.primaryAccent : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: isActive ? Colors.white : Colors.black87,
                  ),
              textAlign: TextAlign.start,
            ),
            Text(
              textHeight,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: isActive ? Colors.white70 : Colors.black54,
                    fontSize: 18,
                  ),
            ),
            Text(
              textWeight,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: isActive ? Colors.white70 : Colors.black54,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heightPicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberValuePicker(
                value: _heightCm,
                min: _unit == Unit.metric ? 110 : 4,
                max: _unit == Unit.metric ? 245 : 8,
                onChanged: (value) => setState(() => _heightCm = value),
              ),
              const Text(
                ',',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              NumberValuePicker(
                value: _heightMm,
                min: 0,
                max: _unit == Unit.metric ? 10 : 11,
                onChanged: (value) => setState(() => _heightMm = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget weightPicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NumberValuePicker(
            value: _weightKg,
            min: _unit == Unit.metric ? 65 : 110,
            max: _unit == Unit.metric ? 235 : 700,
            onChanged: (value) => setState(() => _weightKg = value),
          ),
          const Text(
            ',',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          NumberValuePicker(
            value: _weightDec,
            min: 0,
            max: 10,
            onChanged: (value) => setState(() => _weightDec = value),
          ),
        ],
      ),
    );
  }

  Widget targetWeightPicker() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NumberValuePicker(
            value: _targetWeightKg,
            min: 65,
            max: 235,
            onChanged: (value) => setState(() => _targetWeightKg = value),
          ),
          const Text(
            ',',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          NumberValuePicker(
            value: _targetWeightDec,
            min: 0,
            max: 10,
            onChanged: (value) => setState(() => _targetWeightDec = value),
          ),
        ],
      ),
    );
  }

  Widget step1() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Gender:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 42),
                child: Text(
                  "Pick your biological sex, so we can calculate your diet",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 15,
            spacing: 15,
            children: [
              tileButton(
                icon: Icons.female,
                onTap: () => setState(() => _sex = Sex.female),
                isActive: _sex == Sex.female,
                text: "Female",
              ),
              tileButton(
                icon: Icons.male,
                onTap: () => setState(() => _sex = Sex.male),
                isActive: _sex == Sex.male,
                text: "Male",
              ),
            ],
          ),
          CustomButton(
            isDisabled: _sex == null,
            onPressed: () {
              if (_sex != null) {
                setState(() => _step = 2);
              }
            },
          )
        ],
      ),
    );
  }

  Widget step2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.only(top: 84),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Your data:',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 42.0),
                child: Column(
                  children: [
                    Text(
                      'What is your name?',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "This is how we will address you",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Input(
                  controller: name,
                  validation: validator.nameValidation,
                ),
              ),
              agePicker(),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 82),
                child: CustomButton(
                  isDisabled: false,
                  onPressed: () {
                    final FormState? form = _formKey.currentState;
                    if (form!.validate()) {
                      setState(() => _step = 3);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget step3() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.only(top: 84),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                child: Text(
                  'Choose unit:',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "It can be changed inside application",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    unitPicker(
                      text: 'Metric',
                      textHeight: 'cm/mm',
                      textWeight: 'kg/dec',
                      onTap: () => setState(() {
                        _unit = Unit.metric;
                        _heightCm = 175;
                        _heightMm = 5;
                        _weightKg = 85;
                        _weightDec = 5;
                        _targetWeightKg = 75;
                        _targetWeightDec = 5;
                      }),
                      isActive: _unit == Unit.metric,
                    ),
                    unitPicker(
                      text: 'Imperial',
                      textHeight: 'feet/inch',
                      textWeight: 'lb/oz',
                      onTap: () => setState(() {
                        _unit = Unit.imperial;
                        _heightCm = 5;
                        _heightMm = 8;
                        _weightKg = 187;
                        _weightDec = 5;
                        _targetWeightKg = 167;
                        _targetWeightDec = 5;
                      }),
                      isActive: _unit == Unit.imperial,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 82),
                child: CustomButton(
                  isDisabled: false,
                  onPressed: () {
                    final FormState? form = _formKey.currentState;
                    if (form!.validate()) {
                      setState(() => _step = 4);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget step4() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Height (${_unit == Unit.metric ? 'm' : 'ft'}):',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 62),
                child: Text(
                  "Pick the one that you feel that fits you the best.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          heightPicker(),
          CustomButton(
            text: 'Next',
            isDisabled: false,
            onPressed: () => setState(() => _step = 5),
          ),
        ],
      ),
    );
  }

  Widget step5() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Weight (${_unit == Unit.metric ? 'kg' : 'lb'}):',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 62),
                child: Text(
                  "Pick the one that you feel that fits you the best.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          weightPicker(),
          CustomButton(
            text: 'Next',
            isDisabled: false,
            onPressed: () => setState(() => _step = 6),
          ),
        ],
      ),
    );
  }

  Widget step6() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Target (${_unit == Unit.metric ? 'm' : 'ft'}):',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 62),
                child: Text(
                  "Pick the one that you feel that fits you the best.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          targetWeightPicker(),
          CustomButton(
            text: 'Next',
            isDisabled: false,
            onPressed: () => setState(() => _step = 7),
          ),
        ],
      ),
    );
  }

  Widget step7() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Activity:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 62),
                child: Text(
                  "Pick the one that you feel that fits you the best.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          Lottie.asset(
            'assets/lotties/activity.json',
            width: 150,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: CustomSlider(
              value: _activityLevel,
              header: headers[_activityLevel.round() - 1],
              onChanged: (double value) {
                setState(() => _activityLevel = value);
              },
            ),
          ),
          CustomButton(
            text: 'Go to summary',
            isDisabled: false,
            onPressed: () {
              int? _stars = countStars();

              if (_stars is int) {
                setState(() {
                  stars = _stars;
                  result = _stars;
                });

                Future.delayed(
                  const Duration(milliseconds: 500),
                  () => setState(() => _step = 8),
                );
              } else {
                setState(() => _step = 4);
              }
            },
          )
        ],
      ),
    );
  }

  Widget step8() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 1,
      padding: const EdgeInsets.only(top: 82),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  Text(
                    'Your plan:',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 52),
                    child: Text(
                      "We have counted out that you need $stars stars to keep your weight. Use slider in case you want to lose or gain some weight.",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Lottie.asset(
                  'assets/lotties/star.json',
                  width: 220,
                  height: 220,
                  repeat: false,
                ),
                Text(
                  result.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 52),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomSlider(
                value: result.toDouble(),
                header: '${(result - stars) * 100}g/week',
                onChanged: (double value) {
                  setState(() {
                    result = value.toInt();
                  });
                },
                min: stars - 10,
                max: stars + 10,
                divisions: 20,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 52),
              child: Text(
                'Reminder: Each star equals to 100 kcal. Remember about your healt! Do not rush - diet should not be a suffering!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: CustomButton(
                  text: 'Proceed to App',
                  isDisabled: false,
                  onPressed: () {
                    DateTime now = DateTime.now();
                    DateParser dateParser = DateParser(date: now);

                    User user = User(
                      name: name.text,
                      age: _age,
                      unit: parseEnum(_unit),
                      height: double.parse('$_heightCm.$_heightMm'),
                      initWeight: double.parse('$_weightKg.$_weightDec'),
                      targetWeight:
                          double.parse('$_targetWeightKg.$_targetWeightDec'),
                      stars: result,
                      gender: parseEnum(_sex),
                      activityLevel: _activityLevel.toInt(),
                      initDate: dateParser.getDateWithoutTime(),
                    );

                    widget.handlePage();
                    BlocProvider.of<HomeBloc>(context)
                        .add(HomeLoadPage(user: user));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _question(int step) {
    switch (step) {
      case 1:
        return step1();
      case 2:
        return step2();
      case 3:
        return step3();
      case 4:
        return step4();
      case 5:
        return step5();
      case 6:
        return step6();
      case 7:
        return step7();
      case 8:
        return step8();
      default:
        return const Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      page: _question(_step),
      isAppBar: _step > 1 || widget.introMode != IntroMode.init,
      margin: const EdgeInsets.only(bottom: 20),
      isBack: true,
      onBack: () {
        if (widget.introMode == IntroMode.init) {
          setState(() => _step = _step - 1);
        } else {
          if (_step == 1) {
            BlocProvider.of<HomeBloc>(context).add(
              HomeLoadInit(
                handlePage: widget.handlePage,
              ),
            );
          } else {
            setState(() => _step = _step - 1);
          }
        }
      },
    );
  }
}
