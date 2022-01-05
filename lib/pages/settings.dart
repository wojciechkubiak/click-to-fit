import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/widgets/custom_icon_button.dart';

import '../models/models.dart';
import '../blocs/home/home_bloc.dart';
import '../widgets/widgets.dart';

class Settings extends StatefulWidget {
  final Function() handlePage;
  final List<User> users;
  final int userId;

  const Settings({
    Key? key,
    required this.handlePage,
    required this.users,
    required this.userId,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isListVisible = true;
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = widget.users;
  }

  Widget listElement({
    required String name,
    required bool isActive,
    required int? id,
  }) {
    return GestureDetector(
      onTap: () async {
        if (!isActive) {
          bool? result = await CustomDialog().showBaseDialog(
            context: context,
            header: 'User change',
            dialogBody:
                'All your data is already stored. Do you want to change account?',
            confirmText: 'Yes',
            declineText: 'No',
          );
          if (result is bool && result == true) {
            BlocProvider.of<HomeBloc>(context).add(
              HomeLoadInit(
                handlePage: widget.handlePage,
                userId: id,
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
        decoration: BoxDecoration(
          color: isActive ? Nord.darker : Nord.dark,
          border: const Border(
            bottom: BorderSide(
              color: Colors.white30,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: isActive
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isActive)
              Icon(
                Icons.favorite_border,
                size: 26,
                color: isActive ? Nord.auroraGreen : Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      margin: const EdgeInsets.only(bottom: 20),
      isAppBar: true,
      color: Nord.darkMedium,
      onBack: () {
        BlocProvider.of<HomeBloc>(context).add(
          HomeLoadInit(
            handlePage: widget.handlePage,
          ),
        );
      },
      isBack: true,
      page: Padding(
        padding: const EdgeInsets.only(top: 82.0, bottom: 32),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Text(
                'Settings:',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => isListVisible = !isListVisible),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isListVisible ? 0 : 32),
                child: Column(
                  children: [
                    if (!isListVisible)
                      Text(
                        'Show list of users',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                      ),
                    Icon(
                      isListVisible ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 22,
                      color: Nord.light,
                    ),
                  ],
                ),
              ),
            ),
            if (isListVisible)
              Container(
                margin: const EdgeInsets.only(
                  left: 22,
                  right: 22,
                  bottom: 42,
                  top: 16,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Nord.darkLight,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white30,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...users.map(
                      (e) => listElement(
                        name: e.name,
                        isActive: e.id == widget.userId,
                        id: e.id,
                      ),
                    )
                  ],
                ),
              ),
            CustomIconButton(
              text: 'Add user',
              onClick: () {
                BlocProvider.of<HomeBloc>(context).add(
                  HomeLoadIntro(introMode: IntroMode.create),
                );
              },
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: 320,
            ),
            CustomIconButton(
              text: 'Update initial data',
              onClick: () {
                BlocProvider.of<HomeBloc>(context).add(HomeLoadIntro());
              },
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Nord.auroraYellow,
              textColor: Nord.darker,
              width: 320,
            ),
            CustomIconButton(
              text: 'Clear your data',
              onClick: () {},
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Nord.auroraRed,
              textColor: Nord.light,
              width: 320,
            )
          ],
        ),
      ),
    );
  }
}
