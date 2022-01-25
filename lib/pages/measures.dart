import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_metter/config/colors.dart';

import '../widgets/widgets.dart';
import '../blocs/home/home_bloc.dart';

class Measures extends StatefulWidget {
  final Function() handlePage;
  const Measures({
    Key? key,
    required this.handlePage,
  }) : super(key: key);

  @override
  State<Measures> createState() => _MeasuresState();
}

class _MeasuresState extends State<Measures> {
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
      page: const Center(
        child: Text('Measures'),
      ),
    );
  }
}
