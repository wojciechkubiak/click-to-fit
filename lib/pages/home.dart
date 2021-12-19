import 'package:flutter/material.dart';
import '../widgets/page_builder.dart';

class Home extends StatefulWidget {
  final Function? showMenu;
  const Home({Key? key, required this.showMenu}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      isAppBar: true,
      onBack: widget.showMenu,
      page: const Center(
        child: Text('test'),
      ),
    );
  }
}
