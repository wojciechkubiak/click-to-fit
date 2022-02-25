import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../config/colors.dart';
import '../lang/keys.dart';
import '../widgets/custom_icon_button.dart';
import '../models/models.dart';
import '../blocs/home/home_bloc.dart';
import '../widgets/widgets.dart';

class Settings extends StatefulWidget {
  final Function() handlePage;
  final List<User> users;
  final User currentUser;

  const Settings({
    Key? key,
    required this.handlePage,
    required this.users,
    required this.currentUser,
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
            header: translate(Keys.settingsDialogHeader),
            dialogBody: translate(Keys.settingsDialogBody),
            confirmText: translate(Keys.settingsDialogConfirm),
            declineText: translate(Keys.settingsDialogDecline),
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
          color: isActive
              ? CustomColor.primaryAccentLight
              : CustomColor.primaryAccentSemiLight,
          border: const Border(
            bottom: BorderSide(
              color: CustomColor.primaryAccentLight,
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
              style: TextStyle(
                color: isActive
                    ? CustomColor.primaryAccent
                    : CustomColor.primaryAccentLight,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isActive)
              Icon(
                Icons.favorite_border,
                size: 26,
                color: isActive
                    ? CustomColor.primaryAccent
                    : CustomColor.primaryAccentSemiLight,
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
      color: CustomColor.primaryAccent,
      backgroundColor: CustomColor.primaryAccent,
      isDarkIcon: false,
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
              child: Column(
                children: [
                  Text(
                    translate(Keys.settingsHeader),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 62),
                    child: Text(
                      translate(Keys.settingsSubheader),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
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
                        translate(Keys.settingsShowUsers),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w600,
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
                      color: CustomColor.primaryAccentLight,
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
                        isActive: e.id == widget.currentUser.id,
                        id: e.id,
                      ),
                    )
                  ],
                ),
              ),
            CustomIconButton(
              text: translate(Keys.settingsAdd),
              onClick: () {
                BlocProvider.of<HomeBloc>(context).add(
                  HomeLoadIntro(introMode: IntroMode.create),
                );
              },
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: 320,
            ),
            CustomIconButton(
              text: translate(Keys.settingsUpdate),
              onClick: () {
                BlocProvider.of<HomeBloc>(context).add(
                  HomeLoadIntro(
                    introMode: IntroMode.edit,
                    user: widget.currentUser,
                  ),
                );
              },
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: 320,
            ),
          ],
        ),
      ),
    );
  }
}
