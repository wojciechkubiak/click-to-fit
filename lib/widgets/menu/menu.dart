import 'package:flutter/material.dart';
import 'package:star_metter/models/user.dart';

import '../../config/colors.dart';
import '../../main.dart';
import '../header.dart';
import './menu_button.dart';

class Menu extends StatelessWidget {
  final Function(CurrentPage) onClick;
  final CurrentPage currentPage;
  final User user;

  const Menu({
    Key? key,
    required this.onClick,
    required this.currentPage,
    required this.user,
  }) : super(key: key);

  double textSize() {
    int userLen = user.name.length;
    double baseSize = 64;
    if (userLen < 6) {
      return baseSize;
    } else if (userLen >= 6 && userLen < 10) {
      return 42;
    } else {
      return 30;
    }
  }

  Widget _menuButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 32, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi,',
                style: TextStyle(
                  fontSize: textSize(),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: textSize(),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        MenuButton(
          text: 'Summary',
          page: CurrentPage.HOME,
          currentPage: currentPage,
          icon: Icons.home,
          onClick: onClick,
        ),
        MenuButton(
          text: 'Stars',
          page: CurrentPage.ARTICLES,
          currentPage: currentPage,
          icon: Icons.star,
          onClick: onClick,
        ),
        MenuButton(
          text: 'Measures',
          page: CurrentPage.ARTICLES,
          currentPage: currentPage,
          icon: Icons.book,
          onClick: onClick,
        ),
        MenuButton(
          text: 'Settings',
          page: CurrentPage.ARTICLES,
          currentPage: currentPage,
          icon: Icons.settings,
          onClick: onClick,
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
        color: CustomColor.primaryAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Header(
              padding: EdgeInsets.only(top: 112),
              showBottomText: true,
              isWhite: true,
            ),
            _menuButtons(),
            Container(),
          ],
        ));
  }
}
