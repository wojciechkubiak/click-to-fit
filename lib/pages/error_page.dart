import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';

import '../blocs/home/home_bloc.dart';
import '../lang/keys.dart';
import '../config/colors.dart';
import '../widgets/widgets.dart';

class ErrorPage extends StatefulWidget {
  final Function() handlePage;

  const ErrorPage({Key? key, required this.handlePage}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      isAppBar: true,
      isBack: true,
      isDarkIcon: false,
      color: CustomColor.primaryAccent,
      backgroundColor: CustomColor.primaryAccent,
      page: Container(
        color: CustomColor.primaryAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(),
            Lottie.asset(
              'assets/lotties/error.json',
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
            ),
            Text(
              translate(Keys.globalError),
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 32,
                  ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      onBack: () {
        BlocProvider.of<HomeBloc>(context).add(
          HomeLoadInit(
            handlePage: widget.handlePage,
          ),
        );
      },
    );
  }
}
