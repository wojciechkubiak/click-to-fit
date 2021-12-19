import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:star_metter/blocs/home/home_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/pages/pages.dart';
import 'package:star_metter/services/home.dart';
import 'package:star_metter/widgets/input.dart';
import 'package:star_metter/widgets/page_builder.dart';
import '../models/validators.dart';
import '../models/user.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validator = Validator();

  int _step = 1;
  Sex? _sex;
  double _activityLevel = 1;
  List<String> headers = [
    'Sick / Mostly laying',
    'Low / Office work',
    'Medium / 2-3 trainings/week',
    'Above avarege / 3-4 trainings/week',
    'High / Physical worker / Proffesional'
  ];
  int stars = 0;
  int result = 0;
  StorageType? storageType;

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
    height = TextEditingController(text: '175');
    weight = TextEditingController(text: '95');
    targetWeight = TextEditingController(text: '85');
  }

  double ppmMale(int weight, int height, int age) {
    // Harris-Benedict
    return 66 + (13.7 * weight) + (5 * height) - (6.76 * age);
  }

  double ppmFemale(int weight, int height, int age) {
    // Harris-Benedict
    return 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
  }

  int countStars() {
    int _age = int.parse(age.text);
    int _height = int.parse(height.text);
    int _weight = int.parse(weight.text);
    int _activity = _activityLevel.toInt();

    double ppm = _sex == Sex.male
        ? ppmMale(_weight, _height, _age)
        : ppmFemale(_weight, _height, _age);

    List pal = [null, 1.2, 1.25, 1.5, 1.75, 2.0];

    double cpm = ppm * pal[_activity];
    return (cpm / 100).ceil();
  }

  String parseEnum(dynamic en) {
    return en.toString().split('.').last;
  }

  Widget confirmButton({
    required bool isOpacity,
    required void Function() onPressed,
    String text = "Next",
  }) {
    return Opacity(
      opacity: isOpacity ? 0.8 : 1,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            primary: CustomColor.primaryAccent,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 80,
            ),
          ),
          onPressed: onPressed,
          child: Text(text)),
    );
  }

  Widget tileButton({
    required IconData icon,
    required Function() onTap,
    required bool isActive,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: isActive ? CustomColor.primaryAccent : Colors.black12,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 72,
              color: isActive ? Colors.black87 : Colors.black54,
            ),
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.black87 : Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
          const Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
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
          confirmButton(
            isOpacity: _sex == null,
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
      margin: const EdgeInsets.only(top: 54),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Personal data',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Input(
              controller: name,
              validation: validator.nameValidation,
              labelText: 'Name',
            ),
            Input(
              controller: age,
              keyboardType: TextInputType.number,
              validation: validator.ageValidation,
              labelText: 'Age',
            ),
            Input(
              controller: height,
              keyboardType: TextInputType.number,
              validation: validator.heightValidation,
              labelText: 'Height (cm)',
            ),
            Input(
              controller: weight,
              keyboardType: TextInputType.number,
              validation: validator.weightValidation,
              labelText: 'Weight (kg)',
            ),
            Input(
              controller: targetWeight,
              keyboardType: TextInputType.number,
              validation: validator.weightValidation,
              labelText: 'Target (kg)',
            ),
            confirmButton(
              isOpacity: false,
              onPressed: () {
                final FormState? form = _formKey.currentState;
                if (form!.validate()) {
                  setState(() => _step = 3);
                }
              },
            )
          ],
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
          const Text(
            'Activity',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Lottie.asset(
            'assets/lotties/activity.json',
            width: 150,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Slider(
              value: _activityLevel,
              min: 1,
              max: 5,
              divisions: 4,
              inactiveColor: Colors.black12,
              activeColor: CustomColor.primaryAccent,
              label: headers[_activityLevel.round() - 1],
              onChanged: (double value) {
                setState(() => _activityLevel = value);
              },
            ),
          ),
          confirmButton(
            text: 'Go to summary',
            isOpacity: false,
            onPressed: () {
              int _stars = countStars();
              setState(() {
                stars = _stars;
                result = _stars;
              });

              Future.delayed(
                const Duration(milliseconds: 500),
                () => setState(() => _step = 4),
              );
            },
          )
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
          const Text(
            'Your plan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Column(
            children: [
              const Icon(
                Icons.star_border,
                size: 122,
                color: CustomColor.primaryAccent,
              ),
              Text(
                result.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Slider(
              value: result.toDouble(),
              min: stars - 10,
              max: stars + 10,
              divisions: 20,
              inactiveColor: Colors.black12,
              activeColor: CustomColor.primaryAccent,
              label: '${(result - stars) * 100}g/week',
              onChanged: (double value) {
                setState(() {
                  result = value.toInt();
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Reminder: Each star equals to 100 kcal. Remember about your healt! Do not rush - diet should not be a suffering!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          confirmButton(
            text: 'Confirm',
            isOpacity: false,
            onPressed: () {
              setState(() => _step = 5);
            },
          )
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
          const Text(
            'Pick storage',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tileButton(
                icon: Icons.storage,
                onTap: () => setState(() => storageType = StorageType.local),
                isActive: storageType == StorageType.local,
                text: "Local",
              ),
              tileButton(
                icon: Icons.cloud,
                onTap: () => setState(() => storageType = StorageType.cloud),
                isActive: storageType == StorageType.cloud,
                text: "Cloud",
              ),
            ],
          ),
          confirmButton(
            text: 'Proceed to App',
            isOpacity: storageType == null,
            onPressed: () {
              if (storageType != null) {
                User user = User(
                  name: 'test',
                  age: int.parse(age.text),
                  height: int.parse(height.text),
                  initWeight: int.parse(weight.text),
                  targetWeight: int.parse(targetWeight.text),
                  stars: result,
                  gender: parseEnum(_sex),
                  activityLevel: parseEnum(_activityLevel),
                  storageType: parseEnum(storageType!),
                );

                BlocProvider.of<HomeBloc>(context)
                    .add(HomeLoadPage(user: user));
              }
            },
          )
        ],
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
      default:
        return const Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      page: _question(_step),
      isAppBar: _step > 1,
      isBack: true,
      onBack: () => setState(() => _step = _step - 1),
    );
  }
}
