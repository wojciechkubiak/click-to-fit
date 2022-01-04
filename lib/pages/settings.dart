import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_metter/main.dart';

import '../blocs/home/home_bloc.dart';
import '../widgets/widgets.dart';

class Settings extends StatefulWidget {
  final Function() handlePage;

  const Settings({Key? key, required this.handlePage}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      margin: const EdgeInsets.only(bottom: 20),
      isAppBar: true,
      onBack: () {
        BlocProvider.of<HomeBloc>(context).add(
          HomeLoadInit(
            handlePage: widget.handlePage,
          ),
        );
      },
      isBack: true,
      page: const Text('settings'),
    );
  }
}
