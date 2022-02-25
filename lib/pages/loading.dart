import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../config/colors.dart';
import '../widgets/widgets.dart';

class Loading extends StatefulWidget {
  final bool isHeader;

  const Loading({Key? key, this.isHeader = false}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: CustomColor.primaryAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isHeader)
              Column(
                children: const [
                  Header(
                    isWhite: true,
                  ),
                ],
              ),
            SleekCircularSlider(
                appearance: CircularSliderAppearance(
              customColors: CustomSliderColors(
                  trackColor: CustomColor.primaryAccent,
                  shadowColor: CustomColor.primaryAccentDark,
                  dotColor: CustomColor.primaryAccent,
                  progressBarColors: [
                    CustomColor.primaryAccentLight,
                    CustomColor.primaryAccentLightSaturated,
                    CustomColor.primaryAccentSemiLight,
                  ]),
              spinnerMode: true,
            )),
            // Lottie.asset(
            //   'assets/lotties/loading.json',
            //   width: MediaQuery.of(context).size.width * 0.9,
            //   height: MediaQuery.of(context).size.width * 0.9,
            // ),
          ],
        ),
      ),
    );
  }
}
