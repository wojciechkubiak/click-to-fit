import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../main.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final CurrentPage page;
  final CurrentPage currentPage;
  final IconData icon;
  final Function(CurrentPage) onClick;

  const MenuButton({
    Key? key,
    required this.text,
    required this.page,
    required this.currentPage,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 16,
        margin: const EdgeInsets.only(left: 16),
        child: GestureDetector(
            onTap: () => onClick(page),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: page == currentPage
                      ? Colors.white
                      : CustomColor.primaryAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: page == currentPage ? Colors.black54 : Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 26,
                        color: page == currentPage
                            ? CustomColor.primaryAccent
                            : Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            )));
  }
}
