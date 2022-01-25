import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_metter/blocs/home/home_bloc.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/widgets/widgets.dart';

class Stars extends StatefulWidget {
  final Function() handlePage;

  const Stars({
    Key? key,
    required this.handlePage,
  }) : super(key: key);

  @override
  State<Stars> createState() => _StarsState();
}

class _StarsState extends State<Stars> {
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
        child: Text('Stars'),
      ),
    );
  }
}
