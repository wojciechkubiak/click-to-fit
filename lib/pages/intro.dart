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

  final double imperialHeightMultiplier = 3.35; // 1m = 3.35ft
  final double imperialWeightMultiplier = 2.21; // 1kg = 2.21lb
  final double feet = 30.48;
  final double inch = 2.54;

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

  int _heightCm = 175;
  int _heightMm = 5;
  int _heightFeet = 5;
  int _heightInch = 8;
  Unit _heightUnit = Unit.metric;

  int _weightKg = 85;
  int _weightDec = 5;
  int _weightLb = 187;
  int _weightOz = 4;
  Unit _weightUnit = Unit.metric;

  int _targetWeightKg = 75;
  int _targetWeightDec = 5;
  Unit _targetWeightUnit = Unit.metric;

  late TextEditingController name;
  late TextEditingController age;
  late TextEditingController height;
  late TextEditingController weight;
  late TextEditingController targetWeight;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: '');
    age = TextEditingController(text: '18');
    height = TextEditingController(text: '175.0');
    weight = TextEditingController(text: '95.0');
    targetWeight = TextEditingController(text: '85.0');
  }

  double ppmMale(double weight, double height, int age) {
    // Harris-Benedict
    return 66 + (13.7 * weight) + (5 * height) - (6.76 * age);
  }

  double ppmFemale(double weight, double height, int age) {
    // Harris-Benedict
    return 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
  }

  int countStars() {
    int _age = int.parse(age.text);
    double _height = double.parse(height.text);
    double _weight = double.parse(weight.text);
    int _activity = _activityLevel.toInt();

    double ppm = _sex == Sex.male
        ? ppmMale(_weight, _height, _age)
        : ppmFemale(_weight, _height, _age);

    List pal = [null, 1.2, 1.25, 1.5, 1.75, 2.0];

    double cpm = ppm * pal[_activity];
    return (cpm / 100).ceil();
  }

  void parseHeight(Unit unit, int beforeDecimal, int afterDecimal) async {
    if (unit == Unit.imperial) {
      double initial = double.tryParse('$beforeDecimal.$afterDecimal') ?? 5;
      int _feet = (initial / feet).floor();
      double rest = initial - (_feet * feet);
      int _inch = (rest / inch).floor();

      setState(() {
        _heightFeet = _feet;
        _heightInch = _inch;
      });
    } else {
      String _cm =
          ((beforeDecimal * feet) + (afterDecimal * inch)).toStringAsFixed(1);
      List<String> _arr = _cm.split('.');

      setState(() {
        _heightCm = int.tryParse(_arr[0]) ?? 100;
        _heightMm = int.tryParse(_arr[1]) ?? 0;
      });
    }
    // return unit == Unit.imperial ? value * imperialHeightMultiplier : ;
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
    required void Function() onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? CustomColor.primaryAccent : Colors.white,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18),
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
                value: _heightUnit == Unit.metric ? _heightCm : _heightFeet,
                min: _heightUnit == Unit.metric ? 110 : 4,
                max: _heightUnit == Unit.metric ? 245 : 8,
                onChanged: (value) => setState(() => _heightUnit == Unit.metric
                    ? _heightCm = value
                    : _heightFeet = value),
              ),
              const Text(
                ',',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              NumberValuePicker(
                value: _heightUnit == Unit.metric ? _heightMm : _heightInch,
                min: 0,
                max: _heightUnit == Unit.metric ? 10 : 11,
                onChanged: (value) => setState(
                  () => _heightUnit == Unit.metric
                      ? _heightMm = value
                      : _heightInch = value,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                unitPicker(
                  text: 'Metric (m)',
                  onTap: () {
                    parseHeight(Unit.metric, _heightFeet, _heightInch);
                    setState(() => _heightUnit = Unit.metric);
                  },
                  isActive: _heightUnit == Unit.metric,
                ),
                unitPicker(
                  text: 'Imperial (lb)',
                  onTap: () {
                    parseHeight(Unit.imperial, _heightCm, _heightMm);
                    setState(() => _heightUnit = Unit.imperial);
                  },
                  isActive: _heightUnit == Unit.imperial,
                )
              ],
            ),
          )
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
            min: 65,
            max: 235,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Height:',
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
            onPressed: () => setState(() => _step = 4),
          ),
        ],
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
                'Weight:',
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
                'Target:',
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
              int _stars = countStars();
              setState(() {
                stars = _stars;
                result = _stars;
              });

              Future.delayed(
                const Duration(milliseconds: 500),
                () => setState(() => _step = 7),
              );
            },
          )
        ],
      ),
    );
  }

  Widget step7() {
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
                      height: double.parse('$_heightCm.$_heightMm'),
                      heightUnit: _heightUnit.toString(),
                      initWeight: double.parse('$_weightKg.$_weightDec'),
                      initWeightUnit: _weightUnit.toString(),
                      targetWeight:
                          double.parse('$_targetWeightKg.$_targetWeightDec'),
                      targetWeightUnit: _targetWeightUnit.toString(),
                      stars: result,
                      gender: parseEnum(_sex),
                      activityLevel: parseEnum(_activityLevel),
                      initDate: dateParser.getDateWithoutTime(),
                    );

                    print('USER ${user.toJson()}');
                    // widget.handlePage();
                    // BlocProvider.of<HomeBloc>(context)
                    //     .add(HomeLoadPage(user: user));
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
