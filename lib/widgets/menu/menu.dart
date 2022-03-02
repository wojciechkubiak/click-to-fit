import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../blocs/home/home_bloc.dart';
import '../../models/models.dart';
import '../../config/colors.dart';
import '../../main.dart';
import '../header.dart';
import './menu_button.dart';
import '../../lang/keys.dart';

class Menu extends StatefulWidget {
  final Function(CurrentPage) onClick;
  final CurrentPage currentPage;
  final User user;

  const Menu({
    Key? key,
    required this.onClick,
    required this.currentPage,
    required this.user,
  }) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  double textSize() {
    int userLen = widget.user.name.length;
    double baseSize = 50;
    if (userLen < 8) {
      return baseSize;
    } else if (userLen >= 8 && userLen < 10) {
      return 40;
    } else {
      return 30;
    }
  }

  Widget _menuButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${translate(Keys.menuGreet)},',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  '${widget.user.name}!',
                  style: TextStyle(
                    fontSize: textSize(),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        MenuButton(
          text: translate(Keys.menuSummary),
          page: CurrentPage.HOME,
          icon: Icons.home,
          onClick: () {
            widget.onClick(CurrentPage.HOME);
          },
        ),
        MenuButton(
          text: translate(Keys.menuStars),
          page: CurrentPage.ARTICLES,
          icon: Icons.star,
          onClick: () {
            widget.onClick(CurrentPage.SETTINGS);
            BlocProvider.of<HomeBloc>(context).add(HomeLoadStars());
          },
        ),
        MenuButton(
          text: translate(Keys.menuMeasures),
          page: CurrentPage.ARTICLES,
          icon: Icons.book,
          onClick: () {
            widget.onClick(CurrentPage.SETTINGS);
            BlocProvider.of<HomeBloc>(context)
                .add(HomeLoadMeasures(user: widget.user));
          },
        ),
        MenuButton(
          text: translate(Keys.menuSettings),
          page: CurrentPage.SETTINGS,
          icon: Icons.settings,
          onClick: () {
            widget.onClick(CurrentPage.SETTINGS);
            BlocProvider.of<HomeBloc>(context).add(HomeLoadSettings());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      width: width,
      color: CustomColor.primaryAccentDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Header(
            padding: EdgeInsets.only(top: 92),
            showBottomText: true,
            isWhite: true,
          ),
          _menuButtons(),
          Container(),
        ],
      ),
    );
  }
}
