import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../config/colors.dart';
import './../widgets/widgets.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Lottie.asset(
              'assets/lotties/loading.json',
              width: 240,
              height: 240,
            ),
            Column(
              children: const [
                Header(),
              ],
            ),
            // Spinner(),
          ],
        ),
      ),
    );
  }
}
