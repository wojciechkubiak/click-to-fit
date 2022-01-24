import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../main.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final CurrentPage page;
  final IconData icon;
  final Function() onClick;

  const MenuButton({
    Key? key,
    required this.text,
    required this.page,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 16,
        margin: const EdgeInsets.only(top: 16),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: page == CurrentPage.HOME ? 10 : 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              textStyle: Theme.of(context).textTheme.bodyText1,
              primary: page == CurrentPage.HOME
                  ? CustomColor.primaryAccentLight
                  : CustomColor.primaryAccentDark,
            ),
            onPressed: onClick,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: page == CurrentPage.HOME
                      ? CustomColor.primaryAccent
                      : Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 26,
                      color: page == CurrentPage.HOME
                          ? CustomColor.primaryAccent
                          : Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            )));
  }
}
