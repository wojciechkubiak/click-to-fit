import 'package:flutter/material.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

import './custom_app_bar.dart';
import '../config/colors.dart';
import './widgets.dart';

class PageBuilder extends StatefulWidget {
  final bool isAppBar;
  final bool isBack;
  final Widget page;
  final Color? color;
  final EdgeInsets margin;
  final ScrollController? controller;
  final Function? onBack;
  final bool isDarkIcon;
  final Color backgroundColor;

  const PageBuilder({
    Key? key,
    required this.page,
    required this.onBack,
    this.controller,
    this.color,
    this.isAppBar = false,
    this.isBack = false,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 20),
    this.isDarkIcon = true,
    this.backgroundColor = CustomColor.primaryAccentLight,
  }) : super(key: key);

  @override
  _PageBuilderState createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  bool isOut = false;

  @override
  void didChangeDependencies() {
    print('isOut $isOut');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      shouldAddCallbacks: true,
      onWillPop: () => widget.onBack!(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: LayoutBuilder(builder: (
                BuildContext context,
                BoxConstraints constraints,
              ) {
                return Center(
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      double? pos = notification.scrollDelta;

                      if (pos is double) {
                        setState(() => isOut = pos > 0);
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: widget.controller,
                      child: Container(
                        margin: widget.margin,
                        child: widget.page,
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (widget.isAppBar)
              CustomAppBar(
                onBack: widget.onBack,
                isBack: widget.isBack,
                color: widget.color,
                isDarkIcon: widget.isDarkIcon,
                isOut: isOut,
              ),
          ],
        ),
      ),
    );
  }
}
